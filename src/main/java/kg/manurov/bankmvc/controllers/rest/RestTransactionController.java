package kg.manurov.bankmvc.controllers.rest;

import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.dto.transactions.TransferRequest;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
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
@Tag(name = "Транзакции", description = "Операции с переводами между картами")
public class RestTransactionController {

    private final TransactionService transactionService;
    private final AuthenticatedUserUtil userUtil;

    @Operation(summary = "Перевод между своими картами",
            description = "Перевод средств между картами текущего пользователя")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Перевод успешно выполнен",
                    content = @Content(schema = @Schema(implementation = TransactionDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Некорректные данные для перевода"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "403",
                    description = "Карта не принадлежит пользователю")
    })
    @PostMapping("/transfer")
    public ResponseEntity<TransactionDto> transferBetweenMyCards(
            @Valid @RequestBody TransferRequest request) {

        String userName = userUtil.getCurrentUsername();
        log.info("Пользователь {} инициирует перевод с карты {} на карту {} на сумму {}",
                userName, request.getFromCardId(), request.getToCardId(), request.getAmount());
        TransactionDto transaction = transactionService.transferBetweenUserCards(request);
        return ResponseEntity.ok(transaction);
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
    @PutMapping("/{id}")
    public ResponseEntity<TransactionDto> toggleTransaction(
            @Parameter(description = "Transaction ID") @PathVariable Long id) {
        TransactionDto transaction = transactionService.refundTransaction(id);
        return ResponseEntity.ok(transaction);
    }
}