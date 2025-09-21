package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/cards")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Карты", description = "Операции управления банковскими картами")
@Slf4j
public class CardController {
    private final AuthenticatedUserUtil userUtil;
    private final CardService cardService;

    @Operation(summary = "Получить все карты пользователя",
            description = "Получение списка карт текущего пользователя с пагинацией")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Список карт получен",
                    content = @Content(schema = @Schema(implementation = Page.class)))
    })
    @GetMapping("/my")
    @PreAuthorize("hasRole('USER')")
    public String getMyCards(
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {
        Long userId = userUtil.getCurrentUserId();
        Page<CardDto> cards = cardService.getUserCards(userId, pageable);
        model.addAttribute("cards", cards);
        return "user/profile";
    }

    @Operation(summary = "Получить все карты",
            description = "Получение списка карт с пагинацией")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Список карт получен",
                    content = @Content(schema = @Schema(implementation = Page.class)))
    })
    @GetMapping("/all")
    @PreAuthorize("hasRole('ADMIN')")
    public String getAllCards(
            @PageableDefault(size = 10, sort = "id", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Page<CardDto> cards = cardService.getAllCards(pageable);
        model.addAttribute("cards", cards);
        return "admin/adminAllCards";
    }

    @Operation(summary = "Получить карту по ID",
            description = "Получение подробной информации о карте")
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
    @GetMapping("/{id}")
    @PreAuthorize("@authenticatedUserUtil.isCardOwner(#id, authentication.name) or hasRole('ADMIN')")
    public String getCard(
            @Parameter(description = "ID карты") @PathVariable Long id,
            Model model) {
        CardDto card = cardService.getCardById(id);
        model.addAttribute("card", card);
        return "cardDetails";
    }

}
