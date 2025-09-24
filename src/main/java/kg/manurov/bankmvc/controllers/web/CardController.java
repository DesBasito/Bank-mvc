package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Parameter;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.service.TransactionService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Slf4j
@Controller
@RequestMapping("/cards")
@RequiredArgsConstructor
public class CardController {
    private final CardService cardService;
    private final AuthenticatedUserUtil userUtil;
    private final TransactionService transactionService;


    @GetMapping("/all")
    @PreAuthorize("hasRole('ROLE_ADMIN')")
    public String getAllCards(
            @RequestParam(required = false, name = "balanceFrom") String balanceFrom,
            @RequestParam(required = false, name = "balanceTo") String balanceTo,
            @RequestParam(required = false, name = "status") String status,
            @RequestParam(required = false, defaultValue = "createdAt") String sort,
            @RequestParam(required = false, defaultValue = "0") Integer page,
            Model model
            ) {

        Page<CardDto> cards = cardService.getAllCards(balanceTo, balanceFrom, status, sort, page);
        model.addAttribute("cards", cards);
        model.addAttribute("balanceTo", balanceTo);
        model.addAttribute("balanceFrom", balanceFrom);
        model.addAttribute("status", status);
        model.addAttribute("sort", sort);
        return "admin/adminAllCards";
    }

    @GetMapping("/{id}")
    @PreAuthorize("@authenticatedUserUtil.isCardOwner(#id, authentication.name) or hasRole('ADMIN')")
    public String getCard(
            @Parameter(description = "ID карты") @PathVariable Long id,
            Model model) {
        CardDto card = cardService.getCardById(id);
        List<TransactionDto> transactions = transactionService.getTransactionsByCardId(id);
        boolean admin = userUtil.isCurrentUserAdmin();
        model.addAttribute("layout",admin ? "adminLayout" : "userLayout");
        model.addAttribute("card", card);
        model.addAttribute("transactions",transactions);
        if (admin) return "admin/cardDetails";
        else return "user/cardDetails";
    }

}
