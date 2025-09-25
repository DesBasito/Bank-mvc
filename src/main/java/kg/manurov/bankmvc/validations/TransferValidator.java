package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.dto.transactions.TransferRequest;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;

import java.math.BigDecimal;
import java.util.NoSuchElementException;
import java.util.Objects;

@RequiredArgsConstructor
public class TransferValidator implements ConstraintValidator<ValidTransactionRequest, TransferRequest> {
    private final CardRepository repository;
    private final AuthenticatedUserUtil userUtil;
    private static final String FROM_CARD_ID = "fromCardId";
    private static final String TO_CARD_ID = "toCardId";

    @Override
    public boolean isValid(TransferRequest value, ConstraintValidatorContext context) {
        boolean isValid = true;
        context.disableDefaultConstraintViolation();

        if (value.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
            context.buildConstraintViolationWithTemplate("Transfer amount must be positive")
                    .addPropertyNode("amount")
                    .addConstraintViolation();
            isValid = false;
        }

        Card fromCard = repository.findById(value.getFromCardId())
                .orElseThrow(() -> new NoSuchElementException("Sender card not found"));

        Card toCard = repository.findById(value.getToCardId())
                .orElseThrow(() -> new NoSuchElementException("Recipient card not found"));


        if (!Objects.equals(fromCard.getOwner().getId(), userUtil.getCurrentUserId())) {
            context.buildConstraintViolationWithTemplate("Sender card does not belong to user")
                    .addPropertyNode(FROM_CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }

        if (!Objects.equals(toCard.getOwner().getId(), userUtil.getCurrentUserId())) {
            context.buildConstraintViolationWithTemplate("Recipient card does not belong to user")
                    .addPropertyNode(TO_CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }


        validateCardForTransaction(fromCard, "sender");
        validateCardForTransaction(toCard, "recipient");

        if (!value.getFromCardId().equals(value.getToCardId()) && fromCard.getBalance().compareTo(value.getAmount()) < 0) {
            context.buildConstraintViolationWithTemplate("Insufficient funds on sender card")
                    .addPropertyNode(FROM_CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }


        return isValid;
    }

    private void validateCardForTransaction(Card card, String cardRole) {
        if ("BLOCKED".equals(card.getStatus())) {
            throw new IllegalArgumentException("The " + cardRole + " card is blocked");
        }

        if ("EXPIRED".equals(card.getStatus())) {
            throw new IllegalArgumentException("The " + cardRole + " card has expired");
        }
    }
}