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
@Schema(description = "Transfer request between cards")
@ValidTransactionRequest
public class TransferRequest {

    @Schema(description = "Sender card ID", example = "1")
    @NotNull(message = "Sender card ID is required")
    Long fromCardId;

    @Schema(description = "Recipient card ID", example = "2")
    @NotNull(message = "Recipient card ID is required")
    Long toCardId;

    @Schema(description = "Transfer amount", example = "1500.50")
    @NotNull(message = "Transfer amount is required")
    @DecimalMin(value = "0.01", message = "Transfer amount must be greater than 0")
    BigDecimal amount;

    @Schema(description = "Transfer description", example = "Transfer to another card")
    @Size(max = 500, message = "Description cannot exceed 500 characters")
    String description;
}