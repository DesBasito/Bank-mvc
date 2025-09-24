package kg.manurov.bankmvc.controllers.web;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("/transactions")
@RequiredArgsConstructor
public class TransactionController {
    private final TransactionService transactionService;
    private final CardService cardService;
    private final AuthenticatedUserUtil userUtil;

    @GetMapping("/all")
    @PreAuthorize("hasRole(ROLE_ADMIN)")
    public String getAllTransactions(
            @PageableDefault(size = 2, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {
        Page<TransactionDto> transactions = transactionService.getAllTransactions(pageable);
        model.addAttribute("transactions",transactions);
        return "admin/adminTransaction";
    }

    @GetMapping("/transfer")
    @PreAuthorize("hasRole(ROLE_USER)")
    public String getTransferPage(Model model) {
        Long userId = userUtil.getCurrentUserId();
        List<CardDto> cards = cardService.getUserCards(userId);
        model.addAttribute("cards",cards);
        return "user/userTransferPage";
    }

    @GetMapping("/my")
    @PreAuthorize("hasRole(ROLE_USER)")
    public String getMyTransactions(
            @PageableDefault(size = 2, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model,
            @RequestParam(required = false, name = "dateFrom") LocalDate dateFrom,
            @RequestParam(required = false, name = "dateTo") LocalDate dateTo,
            @RequestParam(required = false, name = "cardId") Long selectedCardId
            ) {
        Long userId = userUtil.getCurrentUserId();
        Page<TransactionDto> transactions = transactionService.getTransactionByUserId(pageable, userId, dateFrom, dateTo, selectedCardId);
        List<CardDto> cards = cardService.getUserCards(userId);
        int monthlyTrans = transactionService.getMonthlyTransactionByUserId(userId);
        BigDecimal totAmount = transactionService.getTotTransAmount(userId);
        model.addAttribute("transactions", transactions);
        model.addAttribute("monthlyTransactions", monthlyTrans);
        model.addAttribute("totalAmount", totAmount);
        model.addAttribute("cardId", selectedCardId);
        model.addAttribute("userCards", cards);
        model.addAttribute("dateFrom", dateFrom);
        model.addAttribute("dateTo", dateTo);
        return "user/userTransactionHistory";
    }


}
