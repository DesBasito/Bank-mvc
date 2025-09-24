package kg.manurov.bankmvc.dto.cards;

import kg.manurov.bankmvc.validations.ValidBlockRequest;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Card block request creation")
public class CardBlockRequestCreateDto {

    @Schema(description = "Card ID to block", example = "1")
    @NotNull(message = "Card ID is required")
    @ValidBlockRequest
    Long cardId;

    @Schema(description = "Block reason", example = "LOST",
            allowableValues = {"LOST", "STOLEN", "COMPROMISED", "SUSPICIOUS", "OTHER"})
    @NotBlank(message = "Block reason is required")
    @Size(max = 50, message = "Reason cannot exceed 50 characters")
    String reason;
}