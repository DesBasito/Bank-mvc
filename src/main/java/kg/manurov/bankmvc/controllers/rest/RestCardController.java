package kg.manurov.bankmvc.controllers.rest;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/cards")
@SecurityRequirement(name = "Bearer Authentication")
@RequiredArgsConstructor
@SecurityRequirement(name = "Basic Authentication")
@Tag(name = "Карты", description = "Операции управления банковскими картами")
@Slf4j
public class RestCardController {
    private final AuthenticatedUserUtil userUtil;
    private final CardService cardService;


    @Operation(summary = "Изменение статуса карты (админ)",
            description = "Изменение статуса карты администратором")
    @PostMapping("/{id}/toggle")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<HttpStatus> toggleCard(
            @Parameter(description = "card ID") @PathVariable Long id) {
        log.info("Администратор меняет статус карты с ID: {}", id);
        cardService.toggleCard(id);
        return ResponseEntity.ok().body(HttpStatus.OK);
    }

    @Operation(summary = "Получить активные карты пользователя",
            description = "Получение списка активных карт текущего пользователя")
    @GetMapping("/my/active")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<CardDto>> getMyActiveCards() {
        Long userId = userUtil.getCurrentUserId();
        List<CardDto> cards = cardService.getUserActiveCards(userId);
        return ResponseEntity.ok(cards);
    }

    @Operation(summary = "Получить карту по номеру",
            description = "Получение подробной информации о карте по его номеру")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Информация о карте получена",
                    content = @Content(schema = @Schema(implementation = CardDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "Карта не найдена"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "Нет доступа к карте")
    })
    @GetMapping()
    public ResponseEntity<CardDto> getCardByNumber(
            @Parameter(description = "Номер карты") @RequestParam String number) {
        CardDto card = cardService.getCardByNumber(number);
        return ResponseEntity.ok(card);
    }

}