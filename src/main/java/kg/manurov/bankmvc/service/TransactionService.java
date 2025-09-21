package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.mappers.TransactionMapper;
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.dto.transactions.TransferRequest;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.Transaction;
import kg.manurov.bankmvc.enums.EnumInterface;
import kg.manurov.bankmvc.enums.TransactionStatus;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.TransactionRepo;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.NoSuchElementException;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class TransactionService {

    private final TransactionRepo transactionRepository;
    private final AuthenticatedUserUtil userUtil;
    private final CardRepository cardRepository;
    private final CardService cardService;
    private final TransactionMapper transactionMapper;

    @Transactional
    public TransactionDto transferBetweenUserCards(TransferRequest request) {
        Card fromCard = cardRepository.findById(request.getFromCardId())
                .orElseThrow(() -> new NoSuchElementException("Карта отправителя не найдена"));

        Card toCard = cardRepository.findById(request.getToCardId())
                .orElseThrow(() -> new NoSuchElementException("Карта получателя не найдена"));

        try {
            Transaction transaction = transactionMapper.toEntity(fromCard, toCard, request);

            if (!request.getFromCardId().equals(request.getToCardId())) {
                cardService.deductBalance(request.getFromCardId(), request.getAmount());
            }
            cardService.addBalance(request.getToCardId(), request.getAmount());

            log.info("Перевод пользователя {} с карты {} на карту {} на сумму {}",
                    fromCard.getOwner().getFullName(), request.getFromCardId(), request.getToCardId(), request.getAmount());
            Transaction savedTransaction = transactionRepository.save(transaction);

            log.info("Перевод выполнен успешно. ID транзакции: {}", savedTransaction.getId());
            return transactionMapper.toDto(savedTransaction);

        } catch (Exception e) {
            log.error("Ошибка при выполнении перевода: {}", e.getMessage(), e);
            Transaction failedTransaction = transactionMapper
                    .toEntityWithError(toCard,fromCard,request, e.getMessage());
            transactionRepository.save(failedTransaction);

            throw new RuntimeException("Ошибка при выполнении перевода: " + e.getMessage());
        }
    }

    @Transactional(readOnly = true)
    public Page<TransactionDto> getUserTransactions(Long userId, Long cardId, Pageable pageable) {
        log.info("Получение транзакций для пользователя {}, карта: {}", userId, cardId);

        Page<Transaction> transactions;

        if (cardId != null) {
            transactions = transactionRepository.findByCardId(cardId, pageable);
            Card card = cardRepository.findById(cardId)
                    .orElseThrow(() -> new NoSuchElementException("Карта не найдена"));
            if (!Objects.equals(card.getOwner().getId(), userId)) {
                throw new IllegalArgumentException("Карта не принадлежит пользователю");
            }
        } else {
            transactions = transactionRepository.findByUserId(userId, pageable);
        }

        return transactions.map(transactionMapper::toDto);
    }

    @Transactional(readOnly = true)
    public TransactionDto getTransactionById(Long transactionId) {
        Long userId = userUtil.getCurrentUserId();
        log.info("Получение транзакции {} для пользователя {}", transactionId, userId);

        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new NoSuchElementException("Транзакция не найдена"));

        boolean hasAccess = Objects.equals(transaction.getFromCard().getOwner().getId(), userId) ||
                            Objects.equals(transaction.getToCard().getOwner().getId(), userId);

        boolean admin = false;
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getAuthorities() != null) {
            admin = authentication.getAuthorities().stream()
                    .anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()));
        }


        if (!hasAccess || admin) {
            throw new IllegalArgumentException("Нет доступа к данной транзакции");
        }

        return transactionMapper.toDto(transaction);
    }


    public Page<TransactionDto> getAllTransactions(Pageable pageable) {
        return transactionRepository.findAll(pageable).map(transactionMapper::toDto);
    }

    public TransactionDto toggleTransaction(Long id, String status) {
        Transaction transaction = transactionRepository.findById(id).orElseThrow(NoSuchElementException::new);
        if (!transaction.getStatus().equals(TransactionStatus.PENDING.name())){
            throw new IllegalArgumentException("The transaction is already processed!");
        }
        if (!EnumInterface.isExists(TransactionStatus.class, status)){
            throw new NoSuchElementException("Such a transaction status does not exist: " + status+ ". -> "
                                             + EnumInterface.getEnumDescription(TransactionStatus.class));
        }
        if (userUtil.isCardOwner(id,userUtil.getCurrentUsername()) && !status.equals(TransactionStatus.CANCELLED.name())){
            throw new AccessDeniedException("You have no right for such operation!");
        }
        transaction.setStatus(status.toUpperCase());
        transactionRepository.save(transaction);
        return transactionMapper.toDto(transaction);
    }
}