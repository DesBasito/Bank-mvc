package kg.manurov.bankmvc.dto.cards;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.time.Instant;

@Getter
@Setter
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Schema(description = "Card block request")
public class CardBlockRequestDto {

    @Schema(description = "Request ID")
    Long id;

    @Schema(description = "Card ID")
    Long cardId;

    @Schema(description = "Card number (masked)")
    String cardNumber;

    @Schema(description = "User ID")
    Long userId;

    @Schema(description = "User name")
    String userName;

    @Schema(description = "Block reason")
    String reason;

    @Schema(description = "Request status", allowableValues = {"PENDING", "APPROVED", "REJECTED"})
    String status;

    @Schema(description = "Admin comment")
    String adminComment;

    @Schema(description = "Request creation date")
    String createdAt;

    @Schema(description = "Request processing date")
    String processedAt;
}