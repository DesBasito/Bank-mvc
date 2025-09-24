package kg.manurov.bankmvc.controllers.rest;

import kg.manurov.bankmvc.dto.ApiResponse;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestCreateDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.service.CardBlockRequestService;
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/card-block-requests")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Запросы на блокировку карт", description = "Управление запросами на блокировку банковских карт")
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

    @Operation(summary = "Получить мои запросы на блокировку",
            description = "Получение списка запросов на блокировку текущего пользователя")
    @GetMapping("/my")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<Page<CardBlockRequestDto>> getMyBlockRequests(
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable) {

        Long userId = userUtil.getCurrentUserId();
        Page<CardBlockRequestDto> blockRequests = cardBlockRequestService.getUserBlockRequests(userId, pageable);
        return ResponseEntity.ok(blockRequests);
    }

    @Operation(summary = "Отменить запрос на блокировку",
            description = "Отмена запроса на блокировку пользователем (только в статусе PENDING)")
    @PostMapping("/{id}/cancel")
    @PreAuthorize("@authenticatedUserUtil.isCardOwner(#id, authentication.name)")
    public ResponseEntity<HttpStatus> cancelBlockRequest(
            @Parameter(description = "ID запроса на блокировку") @PathVariable Long id) {

        String userName = userUtil.getCurrentUsername();
        log.info("Пользователь {} отменяет запрос на блокировку с ID: {}", userName, id);
        cardBlockRequestService.cancelBlockRequest(id);
        return ResponseEntity.ok().body(HttpStatus.OK);
    }

    @Operation(summary = "Получить запрос на блокировку по ID",
            description = "Получение подробной информации о запросе на блокировку")
    @GetMapping("/{id}")
    @PreAuthorize("@authenticatedUserUtil.isCardOwner(#id, authentication.name) or hasRole('ADMIN')")
    public ResponseEntity<CardBlockRequestDto> getBlockRequest(
            @Parameter(description = "ID запроса на блокировку") @PathVariable Long id) {
        CardBlockRequestDto blockRequest = cardBlockRequestService.getBlockRequestById(id);

        return ResponseEntity.ok(blockRequest);
    }


    // ================================================================

    @Operation(summary = "Получить все запросы на блокировку (админ)",
            description = "Получение всех запросов на блокировку в системе (только для администраторов)")
    @GetMapping("/admin/all")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<Page<CardBlockRequestDto>> getAllBlockRequests(
            @Parameter(description = "Статус запроса")
            @RequestParam(required = false) String status,
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable) {

        Page<CardBlockRequestDto> blockRequests;

        if (status != null) {
            blockRequests = cardBlockRequestService.getBlockRequestsByStatus(status, pageable);
        } else {
            blockRequests = cardBlockRequestService.getAllBlockRequests(pageable);
        }

        return ResponseEntity.ok(blockRequests);
    }

    @Operation(summary = "Одобрить запрос на блокировку (админ)",
            description = "Одобрение запроса на блокировку и блокировка карты")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Запрос одобрен, карта заблокирована",
                    content = @Content(schema = @Schema(implementation = CardBlockRequestDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Запрос уже обработан")
    })
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CardBlockRequestDto> approveBlockRequest(
            @Parameter(description = "ID запроса на блокировку") @PathVariable Long id,
            @Parameter(description = "Комментарий администратора")
            @RequestParam(required = false) String adminComment) {

        log.info("Администратор одобряет запрос на блокировку с ID: {}", id);
        CardBlockRequestDto blockRequest = cardBlockRequestService.approveBlockRequest(id, adminComment);
        return ResponseEntity.ok(blockRequest);
    }

    @Operation(summary = "Отклонить запрос на блокировку (админ)",
            description = "Отклонение запроса на блокировку администратором")
    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CardBlockRequestDto> rejectBlockRequest(
            @Parameter(description = "ID запроса на блокировку") @PathVariable Long id,
            @Parameter(description = "Комментарий администратора (причина отклонения)")
            @RequestParam(required = false) String adminComment) {

        log.info("Администратор отклоняет запрос на блокировку с ID: {}, причина: {}", id, adminComment);
        CardBlockRequestDto blockRequest = cardBlockRequestService.rejectBlockRequest(id, adminComment);
        return ResponseEntity.ok(blockRequest);
    }
}