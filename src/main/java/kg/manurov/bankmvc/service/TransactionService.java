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
import kg.manurov.bankmvc.service.specifications.TransactionSpecification;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.*;
import java.util.List;
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
    public Long transferBetweenUserCards(TransferRequest request) {
        Card fromCard = cardRepository.findById(request.getFromCardId())
                .orElseThrow(() -> new NoSuchElementException("Sender card not found"));

        Card toCard = cardRepository.findById(request.getToCardId())
                .orElseThrow(() -> new NoSuchElementException("Recipient card not found"));

        try {
            Transaction transaction = transactionMapper.toEntity(fromCard, toCard, request);

            if (!request.getFromCardId().equals(request.getToCardId())) {
                cardService.deductBalance(request.getFromCardId(), request.getAmount());
            }
            cardService.addBalance(request.getToCardId(), request.getAmount());

            log.info("Transfer from user {} from card {} to card {} amount {}",
                    fromCard.getOwner().getFullName(), request.getFromCardId(), request.getToCardId(), request.getAmount());
            Transaction savedTransaction = transactionRepository.save(transaction);

            log.info("Transfer completed successfully. Transaction ID: {}", savedTransaction.getId());
            return savedTransaction.getId();

        } catch (Exception e) {
            log.error("Error during transfer: {}", e.getMessage(), e);
            Transaction failedTransaction = transactionMapper
                    .toEntityWithError(toCard, fromCard, request, e.getMessage());
            transactionRepository.save(failedTransaction);

            throw new RuntimeException("Error during transfer: " + e.getMessage());
        }
    }

    @Transactional(readOnly = true)
    public TransactionDto getTransactionById(Long transactionId) {
        Long userId = userUtil.getCurrentUserId();
        log.info("Getting transaction {} for user {}", transactionId, userId);

        Transaction transaction = transactionRepository.findById(transactionId)
                .orElseThrow(() -> new NoSuchElementException("Transaction not found"));

        boolean hasAccess = Objects.equals(transaction.getFromCard().getOwner().getId(), userId) ||
                            Objects.equals(transaction.getToCard().getOwner().getId(), userId);

        boolean admin = false;
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getAuthorities() != null) {
            admin = authentication.getAuthorities().stream()
                    .anyMatch(auth -> "ROLE_ADMIN".equals(auth.getAuthority()));
        }

        if (!hasAccess || admin) {
            throw new IllegalArgumentException("No access to this transaction");
        }

        return transactionMapper.toDto(transaction);
    }

    public Page<TransactionDto> getAllTransactions(Pageable pageable) {
        return transactionRepository.findAll(pageable).map(transactionMapper::toDto);
    }

    public TransactionDto refundTransaction(Long id) {
        Transaction transaction = transactionRepository.findById(id).orElseThrow(NoSuchElementException::new);
        if (!transaction.getStatus().equals(TransactionStatus.SUCCESS.name())) {
            throw new IllegalArgumentException("The transaction is already processed!");
        }

        cardService.addBalance(transaction.getFromCard().getId(), transaction.getAmount());
        cardService.deductBalance(transaction.getToCard().getId(), transaction.getAmount());
        transaction.setStatus(TransactionStatus.REFUNDED.name());
        transactionRepository.save(transaction);
        return transactionMapper.toDto(transaction);
    }

    public int getMonthlyTransactionCount(Long id) {
        YearMonth month = YearMonth.now();
        Instant start = month.atDay(1).atStartOfDay(ZoneOffset.UTC).toInstant();
        Instant end = month.atEndOfMonth().atTime(LocalTime.MAX).toInstant(ZoneOffset.UTC);

        return transactionRepository.countTransactionsByUserIdAndDateRange(id, start, end);
    }

    public int getMonthlyTransactionByUserId(Long id) {
        return transactionRepository.countTransactionsByUserId(id);
    }

    public List<TransactionDto> getTransactionsByCardId(Long cardId) {
        log.info("Getting last 10 transactions for card ID: {}", cardId);
        Pageable pageable = PageRequest.of(0, 10, Sort.by(Sort.Direction.DESC, "createdAt"));

        Page<Transaction> transactions = transactionRepository.findByCardId(cardId, pageable);

        return transactions.getContent()
                .stream()
                .map(transactionMapper::toDto)
                .toList();
    }

    public Page<TransactionDto> getTransactionByUserId(Pageable pageable, Long userId, LocalDate dateFrom, LocalDate dateTo, Long cardId) {
        Instant from = dateFrom != null ? dateFrom.atStartOfDay().toInstant(ZoneOffset.UTC) : null;
        Instant to = dateTo != null ? dateTo.atStartOfDay().toInstant(ZoneOffset.UTC) : null;

        Specification<Transaction> spec = TransactionSpecification.createSpecification(userId, from, to, cardId);
        Page<Transaction> transactions = transactionRepository.findAll(spec, pageable);
        return transactions.map(transactionMapper::toDto);
    }

    public BigDecimal getTotTransAmount(Long userId) {
        return transactionRepository.getTotalAmountByUserId(userId);
    }
}