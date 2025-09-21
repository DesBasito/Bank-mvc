package kg.manurov.bankmvc.dto.cardApplication;

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
@Schema(description = "Заявка на создание карты")
public class CardApplicationDto {

    @Schema(description = "ID заявки")
    Long id;

    @Schema(description = "ID пользователя")
    Long userId;

    @Schema(description = "Имя пользователя")
    String userName;

    @Schema(description = "Тип карты")
    String cardType;

    @Schema(description = "Комментарий к заявке")
    String comment;

    @Schema(description = "Статус заявки", allowableValues = {"PENDING", "APPROVED", "REJECTED", "CANCELLED"})
    String status;

    @Schema(description = "Дата создания заявки")
    Instant createdAt;

    @Schema(description = "Дата обработки заявки")
    Instant processedAt;
}