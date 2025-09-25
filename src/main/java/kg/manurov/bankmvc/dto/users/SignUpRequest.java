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
@Schema(description = "Registration request")
public class SignUpRequest {
    @Schema(description = "First name", example = "John")
    @NotBlank
    String name;
    @Schema(description = "Last name", example = "Smith")
    @NotBlank
    String surname;
    @Schema(description = "Middle name", example = "Robert")
    String middleName;
    @Schema(description = "Phone number", example = "+7(900)1234567")
    @NotBlank
    @Pattern(regexp = "^\\+7\\([0-9]{3}\\)[0-9]{3}[0-9]{4}$", message = "Phone number must be in format +7(XXX)XXXXXXX")
    @ValidPhoneNumber
    String phoneNumber;
    @Schema(description = "Password", example = "password")
    @NotBlank
    @Size(max = 11, min = 5)
    String password;

    public String getFullName() {
        return String.format("%s %s %s%n", name, middleName != null ? middleName : "", surname);
    }
}