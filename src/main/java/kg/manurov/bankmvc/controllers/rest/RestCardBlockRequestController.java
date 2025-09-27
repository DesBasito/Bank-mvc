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
import kg.manurov.bankmvc.dto.cards.CardBlockRequestCreateDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.service.CardBlockRequestService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/card-block-requests")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Card Block Requests", description = "Management of bank card block requests")
public class RestCardBlockRequestController {
    private final CardBlockRequestService cardBlockRequestService;
    private final AuthenticatedUserUtil userUtil;


    @Operation(summary = "Create card block request",
            description = "Creating a request to block own card by user")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Block request created successfully",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Invalid data or card is already blocked",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "No access to this card",
                    content = @Content(schema = @Schema(implementation = ApiResponse.class)))
    })
    @PostMapping
    public ResponseEntity<ApiResponse<CardBlockRequestDto>> createBlockRequest(
            @Valid @RequestBody CardBlockRequestCreateDto request) {
        String userName = userUtil.getCurrentUsername();
        log.info("User {} creates block request for card with ID: {}", userName, request.getCardId());

        CardBlockRequestDto blockRequest = cardBlockRequestService.createBlockRequest(request);

        return ResponseEntity.ok(ApiResponse.success("Block request submitted successfully", blockRequest));
    }

    @Operation(summary = "Cancel block request",
            description = "Cancel block request by user (only in PENDING status)")
    @PostMapping("/{id}/cancel")
    @PreAuthorize("@authenticatedUserUtil.isCardOwner(#id, authentication.name)")
    public ResponseEntity<ApiResponse<Void>> cancelBlockRequest(
            @Parameter(description = "Block request ID") @PathVariable Long id) {

        String userName = userUtil.getCurrentUsername();
        log.info("User {} cancels block request with ID: {}", userName, id);
        cardBlockRequestService.cancelBlockRequest(id);
        return ResponseEntity.ok().body(ApiResponse.success("block request cancelled"));
    }

    @Operation(summary = "Approve block request (admin)",
            description = "Approve block request and block the card")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Request approved, card blocked",
                    content = @Content(schema = @Schema(implementation = CardBlockRequestDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Request already processed")
    })
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<CardBlockRequestDto> approveBlockRequest(
            @Parameter(description = "Block request ID") @PathVariable Long id,
            @Parameter(description = "Administrator comment")
            @RequestParam(required = false) String adminComment) {

        log.info("Administrator approves block request with ID: {}", id);
        CardBlockRequestDto blockRequest = cardBlockRequestService.approveBlockRequest(id, adminComment);
        return ResponseEntity.ok(blockRequest);
    }

    @Operation(summary = "Reject block request (admin)",
            description = "Reject block request by administrator")
    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public ResponseEntity<ApiResponse<Void>> rejectBlockRequest(
            @Parameter(description = "Block request ID") @PathVariable Long id,
            @Parameter(description = "Administrator comment (rejection reason)")
            @RequestParam(required = false) String adminComment) {

        log.info("Administrator rejects block request with ID: {}, reason: {}", id, adminComment);
        cardBlockRequestService.rejectBlockRequest(id, adminComment);
        return ResponseEntity.ok(ApiResponse.success("block request rejected"));
    }
}