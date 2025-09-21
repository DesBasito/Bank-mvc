package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.repositories.UserRepository;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import lombok.RequiredArgsConstructor;

import java.util.regex.Pattern;

@RequiredArgsConstructor
public class PhoneNumberValidator implements ConstraintValidator<ValidPhoneNumber, String> {
    private final UserRepository userRepository;

    @Override
    public boolean isValid(String number, ConstraintValidatorContext context) {
        boolean isValid = true;

        context.disableDefaultConstraintViolation();

        if (!Pattern.compile("^\\+7\\([0-9]{3}\\)[0-9]{3}[0-9]{4}$").matcher(number).matches()) {
            context.buildConstraintViolationWithTemplate("Номер телефона должен быть в формате '+7(XXX)XXXXXXX'!")
                    .addConstraintViolation();
            isValid = false;
        }
        if (userRepository.existsByPhoneNumber(number)){
            context.buildConstraintViolationWithTemplate("Такой номер телефона уже существует!")
                    .addConstraintViolation();
            isValid = false;
        }

        return isValid;
    }
}
