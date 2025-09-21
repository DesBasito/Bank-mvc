package kg.manurov.bankmvc.validations;

import kg.manurov.bankmvc.enums.RoleType;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Set;

public class RoleTypeValidator implements ConstraintValidator<ValidRoleType, Set<Long>> {
    @Override
    public boolean isValid(Set<Long> value, ConstraintValidatorContext context) {
        boolean isValid = true;

        context.disableDefaultConstraintViolation();
        for (Long id : value){
            if (RoleType.existsById(id)) {
                context.buildConstraintViolationWithTemplate("Роль по указанному id не существует (1:USER, 2:Admin)")
                        .addPropertyNode("roleIds")
                        .addConstraintViolation();
                isValid = false;
            }
        }

        return isValid;
    }
}
