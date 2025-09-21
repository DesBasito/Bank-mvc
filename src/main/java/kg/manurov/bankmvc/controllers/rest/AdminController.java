package kg.manurov.bankmvc.controllers.rest;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
@SecurityRequirement(name = "Basic Authentication")
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "Управление пользователями", description = "Административные операции с пользователями")
public class AdminController {
    private final UserService userService;


    @Operation(summary = "Заблокировать/разблокировать пользователя",
            description = "Изменение статуса активности пользователя")
    @PostMapping("/{id}/toggle-status")
    public ResponseEntity<String> toggleUserStatus(
            @Parameter(description = "ID пользователя") @PathVariable Long id) {

        UserDto user = userService.toggleUserStatus(id);
        String message = user.getIsActive() ? "Пользователь активирован: " + user.getFullName() : "Пользователь " + user.getFullName() + " заблокирован";
        return ResponseEntity.ok(message);
    }


    @Operation(summary = "Удалить пользователя",
            description = "Удаление пользователя из системы")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Пользователь удален"),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "400",
                    description = "Нельзя удалить пользователя с активными картами")
    })
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteUser(
            @Parameter(description = "ID пользователя") @PathVariable Long id) {
        userService.deleteUser(id);
        return ResponseEntity.ok("Пользователь удален");
    }
}