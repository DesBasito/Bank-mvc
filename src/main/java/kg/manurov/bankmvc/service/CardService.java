package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.mappers.CardMapper;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import kg.manurov.bankmvc.service.specifications.CardSpecification;
import kg.manurov.bankmvc.util.EncryptionUtil;
import jakarta.validation.ValidationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CardService {
    @Value("${app.page_size}")
    private Integer size;
    private final CardRepository cardRepository;
    private final UserRepository userRepository;
    private final EncryptionUtil encryptionUtil;
    private final CardMapper cardMapper;
    private static final String CARD_NOT_FOUND = "Карта не найдена!";


    public CardDto createCard(Long ownerId, String cardType) {
        log.info("Создание карты для пользователя с ID: {}", ownerId);

        User owner = userRepository.findById(ownerId)
                .orElseThrow(() -> new NoSuchElementException("Пользователь с номером телефона " + ownerId + " не найден"));
        String plainCardNumber = encryptionUtil.generateCardNumber();
        String encryptedCardNumber = encryptionUtil.encryptCardNumber(plainCardNumber);

        log.debug("Создается карта с зашифрованным номером для пользователя: {}", owner.getFullName());

        Card card = cardMapper.createEntity(owner, encryptedCardNumber, cardType);
        Card savedCard = cardRepository.save(card);

        log.info("Карта создана с ID: {}", savedCard.getId());
        return cardMapper.toDto(savedCard);
    }

    @Transactional(readOnly = true)
    public CardDto getCardById(Long id) {
        Card card = cardRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));
        return cardMapper.toDto(card);
    }

    @Transactional(readOnly = true)
    public CardDto getCardByNumber(String cardNumber) {
        String encryptedNumber = encryptionUtil.encryptCardNumber(cardNumber);
        Card card = cardRepository.findByCardNumber(encryptedNumber)
                .orElseThrow(() -> new NoSuchElementException("Карта с указанным номером не найдена"));
        return cardMapper.toDto(card);
    }

    @Transactional(readOnly = true)
    public List<CardDto> getUserCards(Long userId) {
        return cardRepository.findByOwnerId(userId)
                .stream()
                .map(cardMapper::toDto)
                .toList();
    }

    @Transactional(readOnly = true)
    public List<CardDto> getUserActiveCards(Long userId) {
        return cardRepository.findActiveCardsByOwnerId(userId)
                .stream()
                .map(cardMapper::toDto)
                .toList();
    }


    public void blockCard(Long cardId, String reason) {
        log.info("Блокировка карты с ID: {}, причина: {}", cardId, reason);

        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            throw new ValidationException("Карта уже заблокирована");
        }

        card.setStatus(CardStatus.BLOCKED.name());
        cardRepository.save(card);

        log.info("Карта {} заблокирована", card);
    }

    public void toggleCard(Long cardId) {
        log.info("Блокировка карты с ID: {}", cardId);

        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            card.setStatus(CardStatus.ACTIVE.name());
        } else if (Objects.equals(card.getStatus(), CardStatus.ACTIVE.name())) {
            card.setStatus(CardStatus.BLOCKED.name());
        } else {
            throw new ValidationException("Cannot change status of expired card!");
        }

        cardRepository.save(card);

        log.info("Карта {} заблокирована", card);
    }

    public void addBalance(Long cardId, BigDecimal amount) {
        log.info("Пополнение карты с ID: {} на сумму: {}", cardId, amount);
        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));

        card.setBalance(card.getBalance().add(amount));
        cardRepository.save(card);

        log.info("Баланс карты {} пополнен на {}", card, amount);
    }

    public void deductBalance(Long cardId, BigDecimal amount) {
        log.info("Списание с карты с ID: {} суммы: {}", cardId, amount);
        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException("Карта не найдена"));

        card.setBalance(card.getBalance().subtract(amount));
        cardRepository.save(card);

        log.info("С карты {} списано {}", card, amount);
    }


    @Transactional
    @Scheduled(cron = "0 0 0 * * *")
    public void updateExpiredCards() {
        log.info("Обновление статуса истекших карт");

        List<Card> expiredCards = cardRepository.findExpiredCards(LocalDate.now());

        for (Card card : expiredCards) {
            if (!Objects.equals(card.getStatus(), CardStatus.EXPIRED.name())) {
                card.setStatus(CardStatus.EXPIRED.name());
                cardRepository.save(card);
                log.info("Карта {} помечена как истекшая", card);
            }
        }

        log.info("Обновлено {} истекших карт", expiredCards.size());
    }

    public void deleteCard(Long cardId) {
        log.info("Удаление карты с ID: {}", cardId);

        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException("Карта не найдена"));

        if (card.getBalance().compareTo(BigDecimal.ZERO) > 0) {
            throw new ValidationException("Нельзя удалить карту с положительным балансом");
        }

        cardRepository.delete(card);
        log.info("Карта {} удалена", card);
    }


    public Page<CardDto> getAllCards(String balanceTo, String balanceFrom, String status, String sort, int page) {
        BigDecimal from = null;
        BigDecimal to = null;
        if (balanceFrom != null && !balanceFrom.isBlank()) from = BigDecimal.valueOf(Double.parseDouble(balanceFrom));
        if (balanceTo != null && !balanceTo.isBlank()) to = BigDecimal.valueOf(Double.parseDouble(balanceTo));
        Specification<Card> cardSpecification = CardSpecification.createSpecification(status,from, to);
        Pageable pageable = PageRequest.of(page, size, Sort.by(sort));
        return cardRepository.findAll(cardSpecification,pageable).map(cardMapper::toDto);
    }
}