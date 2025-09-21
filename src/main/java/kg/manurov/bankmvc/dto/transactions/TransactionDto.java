package kg.manurov.bankmvc.dto.transactions;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.time.Instant;

@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Информация о транзакции")
public class TransactionDto {
    @Schema(description = "ID транзакции")
    Long id;

    @Schema(description = "ID карты отправителя")
    Long fromCardId;

    @Schema(description = "Маскированный номер карты отправителя")
    String fromCardCardNumber;

    @Schema(description = "ID карты получателя")
    Long toCardId;

    @Schema(description = "Маскированный номер карты получателя")
    String toCardCardNumber;

    @NotNull
    @Schema(description = "Сумма транзакции")
    BigDecimal amount;

    @Schema(description = "Описание транзакции")
    String description;

    @NotNull
    @Schema(description = "Статус транзакции", allowableValues = {"SUCCESS", "CANCELLED", "REFUNDED"})
    String status;

    @NotNull
    @Schema(description = "Дата создания транзакции")
    Instant createdAt;

    @Schema(description = "Дата обработки транзакции")
    Instant processedAt;

    @Schema(description = "Сообщение об ошибке (если есть)")
    String errorMessage;
}