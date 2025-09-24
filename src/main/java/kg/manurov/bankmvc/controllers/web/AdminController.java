package kg.manurov.bankmvc.controllers.web;


import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.service.TransactionService;
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

import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {
    private final UserService userService;
    private final TransactionService transactionService;

    @GetMapping
    public String getAllUsers(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Page<UserDto> users = userService.getAllUsers(pageable);
        model.addAttribute("users", users);
        return "admin/adminUsersList";
    }

    @GetMapping("/{id}")
    public String getUser(
            @Parameter(description = "ID пользователя") @PathVariable Long id, Model model) {
        UserDto user = userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("cards", user.getCards());

        BigDecimal totalBalance = user.getCards().stream()
                .map(CardDto::getBalance)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        model.addAttribute("totalBalance", totalBalance);

        List<CardDto> activeCards = user.getCards().stream()
                .filter(card -> CardStatus.ACTIVE.name().equals(card.getStatus()))
                .collect(Collectors.toList());
        model.addAttribute("activeCards", activeCards);

        int monthlyTransactions = transactionService.getMonthlyTransactionCount(id);
        model.addAttribute("monthlyTransactions", monthlyTransactions);
        return "admin/userDetails";
    }

}
