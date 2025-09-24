package kg.manurov.bankmvc.controllers.rest;

import kg.manurov.bankmvc.dto.ApiResponse;
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
import java.util.Map;

@RestController
@RequestMapping("/cards")
@SecurityRequirement(name = "Bearer Authentication")
@RequiredArgsConstructor
@SecurityRequirement(name = "Basic Authentication")
@Tag(name = "Cards", description = "Bank card management operations")
@Slf4j
public class RestCardController {
    private final AuthenticatedUserUtil userUtil;
    private final CardService cardService;


    @Operation(summary = "Change card status (admin)",
            description = "Change card status by administrator")
    @PutMapping("/{id}/toggle")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> toggleCard(
            @Parameter(description = "card ID") @PathVariable Long id) {
        log.info("Administrator changes card status with ID: {}", id);
        cardService.toggleCard(id);
        return ResponseEntity.ok(ApiResponse.success("Card status changed successfully!"));
    }

    @Operation(summary = "Get user's active cards",
            description = "Get list of active cards for current user")
    @GetMapping("/my/active")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<List<CardDto>> getMyActiveCards() {
        Long userId = userUtil.getCurrentUserId();
        List<CardDto> cards = cardService.getUserActiveCards(userId);
        return ResponseEntity.ok(cards);
    }

    @Operation(summary = "Get card by number",
            description = "Get detailed card information by its number")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Card information retrieved",
                    content = @Content(schema = @Schema(implementation = CardDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "Card not found"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "No access to card")
    })
    @GetMapping()
    public ResponseEntity<CardDto> getCardByNumber(
            @Parameter(description = "Card number") @RequestParam String number) {
        CardDto card = cardService.getCardByNumber(number);
        return ResponseEntity.ok(card);
    }

}