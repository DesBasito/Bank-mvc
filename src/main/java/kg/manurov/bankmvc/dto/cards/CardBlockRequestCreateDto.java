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
@Schema(description = "Запрос на создание заявки блокировки карты")
public class CardBlockRequestCreateDto {

    @Schema(description = "ID карты для блокировки", example = "1")
    @NotNull(message = "ID карты обязательно")
@ValidBlockRequest
    Long cardId;

    @Schema(description = "Причина блокировки", example = "Потеря карты")
    @NotBlank(message = "Причина блокировки обязательна")
    @Size(max = 500, message = "Причина не может превышать 500 символов")
    String reason;
}