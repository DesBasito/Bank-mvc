package kg.manurov.bankmvc.controllers.web;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.math.BigDecimal;
import java.util.List;
import java.util.Objects;

@Slf4j
@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class UserController {
    private final CardService service;
    private final AuthenticatedUserUtil userUtil;
    private final TransactionService transactionService;
    private final CardService cardService;

    @GetMapping()
    @PreAuthorize("hasRole('ROLE_USER')")
    public String profile(Model model) {
        Long id = userUtil.getCurrentUserId();
        List<CardDto> cards = cardService.getUserCards(id);

        model.addAttribute("cards", cards);

        BigDecimal totalBalance = cards.stream()
                .map(CardDto::getBalance)
                .filter(Objects::nonNull)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        model.addAttribute("totalBalance", totalBalance);

        List<CardDto> activeCards = cards.stream()
                .filter(card -> CardStatus.ACTIVE.name().equals(card.getStatus()))
                .toList();
        model.addAttribute("activeCards", activeCards);

         int monthlyTransactions = transactionService.getMonthlyTransactionCount(id);
         model.addAttribute("monthlyTransactions", monthlyTransactions);

        return "user/profile";
    }
}
