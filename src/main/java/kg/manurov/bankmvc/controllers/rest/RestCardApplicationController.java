package kg.manurov.bankmvc.controllers.rest;

import kg.manurov.bankmvc.dto.ApiResponse;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.service.CardApplicationService;
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
@RequestMapping("/card-applications")
@SecurityRequirement(name = "Basic Authentication")
@RequiredArgsConstructor
@Tag(name = "Заявки на карты", description = "Управление заявками на создание карт")
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
    @PreAuthorize("hasRole('USER')")
    @PostMapping
    public ResponseEntity<ApiResponse<CardApplicationDto>> createApplication(
            @Valid @RequestBody CardApplicationRequest request) {

        Long userId = userUtil.getCurrentUserId();
        String userName = userUtil.getCurrentUsername();
        log.info("User {} creates card application of type {}", userName, request.getCardType());

        CardApplicationDto result = cardApplicationService.createCardApplication(userId, request);

        return ResponseEntity.ok(ApiResponse.success("Card application submitted successfully", result));
    }

//    @Operation(summary = "Получить мои заявки",
//            description = "Получение списка заявок текущего пользователя")
//    @GetMapping("/my")
//    @PreAuthorize("hasRole('USER')")
//    public ResponseEntity<Page<CardApplicationDto>> getMyApplications(
//            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC)
//            Pageable pageable) {
//
//        Long userId = userUtil.getCurrentUserId();
//        Page<CardApplicationDto> applications = cardApplicationService.getUserApplications(userId, pageable);
//        return ResponseEntity.ok(applications);
//    }

    @Operation(summary = "Отменить заявку",
            description = "Отмена заявки пользователем (только в статусе PENDING)")
    @PostMapping("/{id}/cancel")
    @PreAuthorize("hasRole('USER')")
    public ResponseEntity<CardApplicationDto> cancelApplication(
            @Parameter(description = "ID заявки") @PathVariable Long id) {

        Long userId = userUtil.getCurrentUserId();
        String userName = userUtil.getCurrentUsername();

        log.info("Пользователь {} отменяет заявку с ID: {}", userName, id);
        CardApplicationDto application = cardApplicationService.cancelCardApplication(id, userId);
        return ResponseEntity.ok(application);
    }

    // ======================================================================================================

    @Operation(summary = "Одобрить заявку (админ)",
            description = "Одобрение заявки и создание карты")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Заявка одобрена, карта создана",
                    content = @Content(schema = @Schema(implementation = CardDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Заявка уже обработана")
    })
    @PostMapping("/{id}/approve")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CardDto> approveApplication(
            @Parameter(description = "ID заявки") @PathVariable Long id) {

        log.info("Администратор одобряет заявку с ID: {}", id);
        CardDto card = cardApplicationService.approveCardApplication(id);
        return ResponseEntity.ok(card);
    }

    @Operation(summary = "Отклонить заявку (админ)",
            description = "Отклонение заявки администратором")
    @PostMapping("/{id}/reject")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<CardApplicationDto> rejectApplication(
            @Parameter(description = "ID заявки") @PathVariable Long id,
            @Parameter(description = "Причина отклонения")
            @RequestParam(required = false) String reason) {

        log.info("Администратор отклоняет заявку с ID: {}, причина: {}", id, reason);
        CardApplicationDto application = cardApplicationService.rejectCardApplication(id, reason);
        return ResponseEntity.ok(application);
    }
}