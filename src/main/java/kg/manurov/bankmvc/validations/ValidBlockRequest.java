package kg.manurov.bankmvc.validations;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = BlockRequestValidator.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface ValidBlockRequest {
    String message() default "Data not valid!";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
