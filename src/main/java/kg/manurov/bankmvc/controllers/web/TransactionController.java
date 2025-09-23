package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/transactions")
@RequiredArgsConstructor
public class TransactionController {
    private final TransactionService transactionService;
    private final AuthenticatedUserUtil userUtil;

    @GetMapping("/my")
    public String getMyTransactions(
            @RequestParam(required = false) Long cardId,
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Long userId = userUtil.getCurrentUserId();
        Page<TransactionDto> transactions = transactionService.getUserTransactions(userId, cardId, pageable);
        model.addAttribute(transactions);
        return "user/userTransactionHistory";
    }

    @GetMapping("/all")
    public String getAllTransactions(
            @PageableDefault(size = 20, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {
        Page<TransactionDto> transactions = transactionService.getAllTransactions(pageable);
        model.addAttribute(transactions);
        return "admin/adminTransaction";
    }
}
