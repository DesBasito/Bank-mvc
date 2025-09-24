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
                .orElseThrow(() -> new NoSuchElementException("Карта не найдена!"));

        List<CardBlockRequest> request = cardBlockRequestRepository.findByCardIdAndStatus(id, CardRequestStatus.PENDING.name());

        if (userUtil.isCardOwner(id, userUtil.getCurrentUsername())) {
            context.buildConstraintViolationWithTemplate("Нет доступа к данной карте")
                    .addConstraintViolation();
            return false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.BLOCKED.name())) {
            context.buildConstraintViolationWithTemplate("Карта уже заблокирована")
                    .addConstraintViolation();
            return false;
        }

        if (Objects.equals(card.getStatus(), CardStatus.EXPIRED.name())) {
            context.buildConstraintViolationWithTemplate("Нельзя заблокировать истекшую карту")
                    .addConstraintViolation();
            return false;
        }

        if (!request.isEmpty()) {
            context.buildConstraintViolationWithTemplate("На данную карту уже существует активный запрос на блокировку")
                    .addConstraintViolation();
            return false;
        }


        return true;
    }
}
