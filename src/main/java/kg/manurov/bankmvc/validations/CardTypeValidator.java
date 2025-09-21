package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.enums.CardType;
import kg.manurov.bankmvc.enums.EnumInterface;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import static kg.manurov.bankmvc.enums.EnumInterface.getEnumDescription;

public class CardTypeValidator implements ConstraintValidator<ValidCardType, String> {
    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        boolean isValid = true;

        context.disableDefaultConstraintViolation();

        if (!EnumInterface.isExists(CardType.class, value)) {
            context.buildConstraintViolationWithTemplate(getEnumDescription(CardType.class))
                    .addConstraintViolation();
            isValid = false;
        }

        return isValid;
    }
}
