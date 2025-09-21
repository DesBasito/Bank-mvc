package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import kg.manurov.bankmvc.dto.users.SignUpRequest;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
@Tag(name = "Authentication")
public class AuthController {
    private final UserService userService;

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }


    @Operation(summary = "User registration")
    @ApiResponse(description = "Return registration page.")
    @GetMapping("/register")
    public String create(Model model) {
        SignUpRequest signUpRequest = new SignUpRequest();
        model.addAttribute("userCreationDto", signUpRequest);
        return "auth/register";
    }


    @Operation(summary = "User registration")
    @ApiResponses(value = {
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "200",
                    description = "Redirecting to profile",
                    content = @Content(schema = @Schema(implementation = UserDto.class))),
            @io.swagger.v3.oas.annotations.responses.ApiResponse(
                    responseCode = "404",
                    description = "Пользователь не найден")
    })
    @PostMapping("/register")
    public String create(@Valid SignUpRequest userCreationDto, BindingResult bindingResult, Model model, HttpServletRequest request) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("userCreationDto", userCreationDto);
            return "auth/register";
        }
        userService.create(userCreationDto);

        try {
            request.login(userCreationDto.getPhoneNumber(), userCreationDto.getPassword());
        } catch (ServletException e) {
            log.error("Error while login ", e);
            return "redirect:/login";
        }
        return "redirect:/";
    }
}
