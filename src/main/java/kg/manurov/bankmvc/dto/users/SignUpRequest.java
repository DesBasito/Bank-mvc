package kg.manurov.bankmvc.dto.users;

import kg.manurov.bankmvc.validations.ValidPhoneNumber;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Accessors(chain = true)
@Schema(description = "Запрос на регистрацию")
public class SignUpRequest {
    @Schema(description = "Имя пользователя", example = "Сергей")
    @NotBlank
    String name;
    @Schema(description = "Фамилия пользователя", example = "Сергеев")
    @NotBlank
    String surname;
    @Schema(description = "Отчество пользователя", example = "Сергеевич")
    String middleName;
    @Schema(description = "Мобильный телефон пользователя", example = "+7(900)1234567")
    @NotBlank
    @Pattern(regexp = "^\\+7\\([0-9]{3}\\)[0-9]{3}[0-9]{4}$", message = "Номер телефона должен быть в формате +7(XXX)XXXXXXX")
    @ValidPhoneNumber
    String phoneNumber;
    @Schema(description = "Пароль для пользователя", example = "password")
    @NotBlank
    @Size(max = 11, min = 5)
    String password;

    public String getFullName() {
        return String.format("%s %s %s%n", name, middleName != null ? middleName : "", surname);
    }
}