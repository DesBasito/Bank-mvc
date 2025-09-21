package kg.manurov.bankmvc.dto.transactions;

import kg.manurov.bankmvc.validations.ValidTransactionRequest;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Запрос на перевод между картами")
@ValidTransactionRequest
public class TransferRequest {

    @Schema(description = "ID карты отправителя", example = "1")
    @NotNull(message = "ID карты отправителя обязателен")
    Long fromCardId;

    @Schema(description = "ID карты получателя", example = "2")
    @NotNull(message = "ID карты получателя обязателен")
    Long toCardId;

    @Schema(description = "Сумма перевода", example = "1500.50")
    @NotNull(message = "Сумма перевода обязательна")
    @DecimalMin(value = "0.01", message = "Сумма перевода должна быть больше 0")
    BigDecimal amount;

    @Schema(description = "Описание перевода", example = "Перевод на другую карту")
    @Size(max = 500, message = "Описание не может превышать 500 символов")
    String description;
}