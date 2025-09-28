package kg.manurov.bankmvc.controllers.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import kg.manurov.bankmvc.dto.ApiResponse;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.service.CardApplicationService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/card-applications")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Card Applications", description = "Card application management")
public class RestCardApplicationController {
    private final CardApplicationService cardApplicationService;
    private final AuthenticatedUserUtil userUtil;


    @Operation(summary = "Create card application",
            description = "Creating a new card application by user")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Application created successfully",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Bad request",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class)))
    })
    @PostMapping
    public ResponseEntity<ApiResponse<CardApplicationDto>> createApplication(
            @Valid @RequestBody CardApplicationRequest request) {

        Long userId = userUtil.getCurrentUserId();
        String userName = userUtil.getCurrentUsername();
        log.info("User {} creates card application of type {}", userName, request.getCardType());

        CardApplicationDto result = cardApplicationService.createCardApplication(userId, request);

        return ResponseEntity.ok(ApiResponse.success("Card application submitted successfully", result));
    }


    @Operation(summary = "Cancel application",
            description = "Cancel application by user (only in PENDING status)")
    @PutMapping("/{id}/cancel")
    public ResponseEntity<ApiResponse<Void>> cancelApplication(
            @Parameter(description = "Application ID") @PathVariable Long id) {

        Long userId = userUtil.getCurrentUserId();
        String userName = userUtil.getCurrentUsername();

        log.info("User {} cancels application with ID: {}", userName, id);
        cardApplicationService.cancelCardApplication(id, userId);
        return ResponseEntity.ok(ApiResponse.success("Successfully cancelled card application!"));
    }


    @Operation(summary = "Approve application (admin)",
            description = "Approve application and create card")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Application approved, card created",
                    content = @Content(schema = @Schema(implementation = CardDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Application already processed")
    })
    @PostMapping("/{id}/approve")
    public ResponseEntity<ApiResponse<Void>> approveApplication(
            @Parameter(description = "Application ID") @PathVariable Long id) {

        log.info("Administrator approves application with ID: {}", id);
        cardApplicationService.approveCardApplication(id);
        return ResponseEntity.ok(ApiResponse.success("Application approved successfully!"));
    }

    @Operation(summary = "Reject application (admin)",
            description = "Reject application by administrator")
    @PostMapping("/{id}/reject")
    public ResponseEntity<ApiResponse<Void>> rejectApplication(
            @Parameter(description = "Application ID") @PathVariable Long id,
            @Parameter(description = "Rejection reason")
            @RequestParam(required = false) String reason) {

        log.info("Administrator rejects application with ID: {}, reason: {}", id, reason);
        cardApplicationService.rejectCardApplication(id, reason);
        return ResponseEntity.ok(ApiResponse.success("Application rejected."));
    }
}