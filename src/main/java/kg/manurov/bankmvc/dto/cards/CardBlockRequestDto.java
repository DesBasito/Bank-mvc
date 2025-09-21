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
@Schema(description = "Запрос на блокировку карты")
public class CardBlockRequestDto {

    @Schema(description = "ID запроса")
    Long id;

    @Schema(description = "ID карты")
    Long cardId;

    @Schema(description = "Номер карты (маскированный)")
    String cardNumber;

    @Schema(description = "ID пользователя")
    Long userId;

    @Schema(description = "Имя пользователя")
    String userName;

    @Schema(description = "Причина блокировки")
    String reason;

    @Schema(description = "Статус запроса", allowableValues = {"PENDING", "APPROVED", "REJECTED"})
    String status;

    @Schema(description = "Комментарий администратора")
    String adminComment;

    @Schema(description = "Дата создания запроса")
    Instant createdAt;

    @Schema(description = "Дата обработки запроса")
    Instant processedAt;
}