package kg.manurov.bankmvc.controllers.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.ApiResponse;
import kg.manurov.bankmvc.service.CardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/cards")
@SecurityRequirement(name = "Bearer Authentication")
@RequiredArgsConstructor
@SecurityRequirement(name = "Basic Authentication")
@Tag(name = "Cards", description = "Bank card management operations")
@Slf4j
public class RestCardController {
    private final CardService cardService;


    @Operation(summary = "Change card status (admin)",
            description = "Change card status by administrator")
    @PutMapping("/{id}/toggle")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<ApiResponse<Void>> toggleCard(
            @Parameter(description = "card ID") @PathVariable Long id) {
        log.info("Administrator changes card status with ID: {}", id);
        cardService.toggleCard(id);
        return ResponseEntity.ok(ApiResponse.success("Card status changed successfully!"));
    }

}