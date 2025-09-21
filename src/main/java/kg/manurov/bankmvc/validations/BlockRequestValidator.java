package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.repositories.CardBlockRequestRepository;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;

import java.util.NoSuchElementException;
import java.util.Objects;

@RequiredArgsConstructor
public class BlockRequestValidator implements ConstraintValidator<ValidBlockRequest, Long> {
    private final CardRepository cardRepository;
    private final CardBlockRequestRepository cardBlockRequestRepository;
    private final AuthenticatedUserUtil userUtil;
    private static final String CARD_ID = "cardId";

    @Override
    public boolean isValid(Long id, ConstraintValidatorContext context) {
        boolean isValid = true;
        context.disableDefaultConstraintViolation();

        Card card = cardRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Карта не найдена!"));

        if (userUtil.isCardOwner(id, userUtil.getCurrentUsername())) {
            context.buildConstraintViolationWithTemplate("Нет доступа к данной карте")
                    .addPropertyNode(CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            context.buildConstraintViolationWithTemplate("Карта уже заблокирована")
                    .addPropertyNode(CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.EXPIRED.name())) {
            context.buildConstraintViolationWithTemplate("Нельзя заблокировать истекшую карту")
                    .addPropertyNode(CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }

        if (cardBlockRequestRepository.existsPendingRequestForCard(id)) {
            context.buildConstraintViolationWithTemplate("На данную карту уже существует активный запрос на блокировку")
                    .addPropertyNode(CARD_ID)
                    .addConstraintViolation();
            isValid = false;
        }


        return isValid;
    }
}
