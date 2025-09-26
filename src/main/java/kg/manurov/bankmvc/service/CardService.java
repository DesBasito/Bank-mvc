package kg.manurov.bankmvc.service;

import jakarta.validation.ValidationException;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.mappers.CardMapper;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import kg.manurov.bankmvc.service.specifications.CardSpecification;
import kg.manurov.bankmvc.util.EncryptionUtil;
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
    private static final String CARD_NOT_FOUND = "Card not found!";


    public CardDto createCard(Long ownerId, String cardType) {
        log.info("Creating card for user with ID: {}", ownerId);

        User owner = userRepository.findById(ownerId)
                .orElseThrow(() -> new NoSuchElementException("User with phone number " + ownerId + " not found"));
        String plainCardNumber = encryptionUtil.generateCardNumber();

        log.debug("Creating card with encrypted number for user: {}", owner.getFullName());

        Card card = cardMapper.createEntity(owner, plainCardNumber, cardType);
        Card savedCard = cardRepository.save(card);

        log.info("Card created with ID: {}", savedCard.getId());
        return cardMapper.toDto(savedCard);
    }

    @Transactional(readOnly = true)
    public CardDto getCardById(Long id) {
        Card card = cardRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));
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
        log.info("Blocking card with ID: {}, reason: {}", cardId, reason);

        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            throw new ValidationException("Card is already blocked");
        }

        card.setStatus(CardStatus.BLOCKED.name());
        cardRepository.save(card);

        log.info("Card {} blocked", card);
    }

    public void toggleCard(Long cardId) {
        log.info("Blocking card with ID: {}", cardId);

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

        log.info("Card {} blocked", card);
    }

    public void addBalance(Long cardId, BigDecimal amount) {
        log.info("Adding balance to card with ID: {} amount: {}", cardId, amount);
        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException(CARD_NOT_FOUND));

        card.setBalance(card.getBalance().add(amount));
        cardRepository.save(card);

        log.info("Card {} balance topped up by {}", card, amount);
    }

    public void deductBalance(Long cardId, BigDecimal amount) {
        log.info("Deducting from card with ID: {} amount: {}", cardId, amount);
        Card card = cardRepository.findById(cardId)
                .orElseThrow(() -> new NoSuchElementException("Card not found"));

        card.setBalance(card.getBalance().subtract(amount));
        cardRepository.save(card);

        log.info("Deducted {} from card {}", amount, card);
    }


    @Transactional
    @Scheduled(cron = "0 0 0 * * *")
    public void updateExpiredCards() {
        log.info("Updating expired cards status");

        List<Card> expiredCards = cardRepository.findExpiredCards(LocalDate.now());

        for (Card card : expiredCards) {
            if (!Objects.equals(card.getStatus(), CardStatus.EXPIRED.name())) {
                card.setStatus(CardStatus.EXPIRED.name());
                cardRepository.save(card);
                log.info("Card {} marked as expired", card);
            }
        }

        log.info("Updated {} expired cards", expiredCards.size());
    }


    public Page<CardDto> getAllCards(String balanceTo, String balanceFrom, String status, String sort, int page) {
        BigDecimal from = null;
        BigDecimal to = null;
        if (balanceFrom != null && !balanceFrom.isBlank()) from = BigDecimal.valueOf(Double.parseDouble(balanceFrom));
        if (balanceTo != null && !balanceTo.isBlank()) to = BigDecimal.valueOf(Double.parseDouble(balanceTo));
        Specification<Card> cardSpecification = CardSpecification.createSpecification(status, from, to);
        Pageable pageable = PageRequest.of(page, size, Sort.by(sort));
        return cardRepository.findAll(cardSpecification, pageable).map(cardMapper::toDto);
    }
}