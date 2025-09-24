package kg.manurov.bankmvc.controllers.web;

import jakarta.validation.Valid;
import kg.manurov.bankmvc.dto.users.SignUpRequest;
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
public class AuthController {
    private final UserService userService;

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }


    @GetMapping("/register")
    public String create(Model model) {
        SignUpRequest signUpRequest = new SignUpRequest();
        model.addAttribute("signUpRequest", signUpRequest);
        return "auth/register";
    }


    @PostMapping("/register")
    public String create(@Valid SignUpRequest signUpRequest, BindingResult bindingResult, Model model) {
        if (bindingResult.hasErrors()) {
            model.addAttribute("signUpRequest", signUpRequest);
            return "auth/register";
        }
        userService.create(signUpRequest);
        return "redirect:/auth/login";
    }
}
