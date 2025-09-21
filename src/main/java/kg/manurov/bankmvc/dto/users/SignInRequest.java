package kg.manurov.bankmvc.dto.users;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Accessors(chain = true)
@Schema(description = "Запрос на аутентификацию")
public class SignInRequest {
    @Schema(description = "Номер телефона пользователя", example = "777010203")
    @NotBlank(message = "Номер телефона не может быть пустыми")
    @Pattern(regexp = "^\\+7\\([0-9]{3}\\)[0-9]{3}[0-9]{4}$", message = "Неверный формат номера телефона! -> +7(XXX)XXXXXXX")
    String phoneNumber;

    @Schema(description = "Пароль", example = "my_1secret1_password")
    @NotBlank(message = "Пароль не может быть пустыми")
    String password;
}
