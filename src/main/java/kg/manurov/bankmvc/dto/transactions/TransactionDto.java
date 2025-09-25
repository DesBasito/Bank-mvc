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
@Schema(description = "Transaction information")
public class TransactionDto {
    @Schema(description = "Transaction ID")
    Long id;

    @Schema(description = "Sender card ID")
    Long fromCardId;

    @Schema(description = "Masked sender card number")
    String fromCardNumber;

    @Schema(description = "Recipient card ID")
    Long toCardId;

    @Schema(description = "Masked recipient card number")
    String toCardNumber;

    @NotNull
    @Schema(description = "Transaction amount")
    BigDecimal amount;

    @Schema(description = "Transaction description")
    String description;

    @NotNull
    @Schema(description = "Transaction status", allowableValues = {"SUCCESS", "CANCELLED", "REFUNDED"})
    String status;

    @NotNull
    @Schema(description = "Transaction creation date")
    String createdAt;

    @Schema(description = "Transaction processing date")
    String processedAt;

    @Schema(description = "Error message (if any)")
    String errorMessage;
}