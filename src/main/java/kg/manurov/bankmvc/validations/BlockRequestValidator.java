package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.CardBlockRequest;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.repositories.CardBlockRequestRepository;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Objects;

@RequiredArgsConstructor
public class BlockRequestValidator implements ConstraintValidator<ValidBlockRequest, Long> {
    private final CardRepository cardRepository;
    private final CardBlockRequestRepository cardBlockRequestRepository;
    private final AuthenticatedUserUtil userUtil;

    @Override
    public boolean isValid(Long id, ConstraintValidatorContext context) {
        context.disableDefaultConstraintViolation();

        Card card = cardRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Card not found!"));

        List<CardBlockRequest> request = cardBlockRequestRepository.findByCardIdAndStatus(id, CardRequestStatus.PENDING.name());

        if (!userUtil.isCardOwner(userUtil.getCurrentUserId(), userUtil.getCurrentUsername())) {
            context.buildConstraintViolationWithTemplate("No access to this card")
                    .addConstraintViolation();
            return false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            context.buildConstraintViolationWithTemplate("Card is already blocked")
                    .addConstraintViolation();
            return false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.EXPIRED.name())) {
            context.buildConstraintViolationWithTemplate("Cannot block expired card")
                    .addConstraintViolation();
            return false;
        }

        if (!request.isEmpty()) {
            context.buildConstraintViolationWithTemplate("An active block request already exists for this card")
                    .addConstraintViolation();
            return false;
        }

        return true;
    }
}