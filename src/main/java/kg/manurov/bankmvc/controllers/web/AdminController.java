package kg.manurov.bankmvc.controllers.web;


import io.swagger.v3.oas.annotations.Parameter;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Slf4j
@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
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
            @Parameter(description = "User ID") @PathVariable Long id, Model model) {
        UserDto user = userService.getUserById(id);
        model.addAttribute("user", user);
        model.addAttribute("cards", user.getCards());

        List<CardDto> activeCards = new ArrayList<>();
        BigDecimal totalBalance = new BigDecimal(0);

        if (user.getCards() != null && !user.getCards().isEmpty()) {
            totalBalance = user.getCards().stream()
                    .map(CardDto::getBalance)
                    .filter(Objects::nonNull)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            activeCards = user.getCards().stream()
                    .filter(card -> CardStatus.ACTIVE.name().equals(card.getStatus()))
                    .toList();
        }

        model.addAttribute("totalBalance", totalBalance);
        model.addAttribute("activeCards", activeCards);

        int monthlyTransactions = transactionService.getMonthlyTransactionCount(id);
        model.addAttribute("monthlyTransactions", monthlyTransactions);
        return "admin/userDetails";
    }

}
