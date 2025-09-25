package kg.manurov.bankmvc.dto.cardApplication;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import kg.manurov.bankmvc.validations.ValidCardType;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Card creation request")
public class CardApplicationRequest {

    @Schema(description = "Card type", example = "DEBIT", allowableValues = {"DEBIT", "CREDIT", "VIRTUAL", "PREPAID"})
    @NotBlank(message = "Card type is required")
    @ValidCardType
    String cardType;

    @Schema(description = "Application comment", example = "Main salary card")
    String comment;
}