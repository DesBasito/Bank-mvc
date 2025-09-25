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
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.dto.transactions.TransferRequest;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/transactions")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Transactions", description = "Operations with transfers between cards")
public class RestTransactionController {

    private final TransactionService transactionService;
    private final AuthenticatedUserUtil userUtil;

    @Operation(summary = "Transfer between own cards",
            description = "Transfer funds between current user's cards")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Transfer completed successfully",
                    content = @Content(schema = @Schema(implementation = TransactionDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Invalid transfer data"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "Card does not belong to user")
    })
    @PostMapping("/transfer")
    @PreAuthorize("hasRole('ROLE_USER')")
    public ResponseEntity<ApiResponse<Void>> transferBetweenMyCards(
            @Valid @RequestBody TransferRequest request) {

        String userName = userUtil.getCurrentUsername();
        log.info("User {} initiates transfer from card {} to card {} for amount {}",
                userName, request.getFromCardId(), request.getToCardId(), request.getAmount());
        Long id = transactionService.transferBetweenUserCards(request);
        return ResponseEntity.ok(ApiResponse.success("Transfer completed successfully. Transaction ID: " + id));
    }


    @Operation(summary = "Refund transaction by ID")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Transaction rolled back successfully!",
                    content = @Content(schema = @Schema(implementation = TransactionDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "Transaction not found!"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "Access denied for this transaction!")
    })
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    @PutMapping("/{id}/refund")
    public ResponseEntity<ApiResponse<Void>> toggleTransaction(
            @Parameter(description = "Transaction ID") @PathVariable Long id) {
        transactionService.refundTransaction(id);
        return ResponseEntity.ok(ApiResponse.success("Transaction refund successfully!"));
    }
}