package kg.manurov.bankmvc.controllers.web;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "Управление пользователями", description = "Административные операции с пользователями")
public class AdminController {
    private final UserService userService;

    @Operation(summary = "Админская страница всех пользователей",
            description = "Получение списка всех пользователей с пагинацией")
    @GetMapping
    public String getAllUsers(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Page<UserDto> users = userService.getAllUsers(pageable);
        model.addAttribute("users", users);
        return "admin/adminUsersList";
    }

    @Operation(summary = "Получить страницу пользователя по ID",
            description = "Получение подробной информации о пользователе")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Информация о пользователе получена",
                    content = @Content(schema = @Schema(implementation = UserDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "Пользователь не найден")
    })
    @GetMapping("/{id}")
    public String getUser(
            @Parameter(description = "ID пользователя") @PathVariable Long id, Model model) {
        UserDto user = userService.getUserById(id);
        model.addAttribute("user", user);
        return "userDetails";
    }

}
