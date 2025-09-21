package kg.manurov.bankmvc.dto.cards;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;


@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class CardDto {
    Long id;
    @NotNull
    @NotBlank
    @Schema()
    String cardNumber;
    @NotNull
    @Schema()
    String ownerName;
    Long ownerId;
    @NotNull
    @Future
    @Schema()
    LocalDate expiryDate;
    @NotNull
    @Schema()
    String status;
    String type;
    @NotNull
    @PositiveOrZero(message = "Баланс не может быть меньше 0!")
    @Schema()
    BigDecimal balance;
    @NotNull
    @Schema()
    Instant createdAt;
    @Schema()
    Instant updatedAt;
}
