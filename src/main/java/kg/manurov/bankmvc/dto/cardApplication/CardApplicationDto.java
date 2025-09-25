package kg.manurov.bankmvc.dto.cardApplication;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import lombok.experimental.FieldDefaults;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Card application")
public class CardApplicationDto {

    @Schema(description = "Application ID")
    Long id;

    @Schema(description = "User ID")
    Long userId;

    @Schema(description = "Username")
    String userName;

    @Schema(description = "Card type")
    String cardType;

    @Schema(description = "Application comment")
    String comment;

    @Schema(description = "Application status", allowableValues = {"PENDING", "APPROVED", "REJECTED", "CANCELLED"})
    String status;

    @Schema(description = "Creation date")
    String createdAt;

    @Schema(description = "Processing date")
    String processedAt;
}