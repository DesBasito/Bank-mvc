package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.service.CardService;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Slf4j
@Controller
@RequestMapping("/cards")
@RequiredArgsConstructor
public class CardController {
    private final AuthenticatedUserUtil userUtil;
    private final CardService cardService;

    @PreAuthorize("hasRole('USER')")
    public String getMyCards(
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {
        Long userId = userUtil.getCurrentUserId();
        Page<CardDto> cards = cardService.getUserCards(userId, pageable);
        model.addAttribute("cards", cards);
        return "user/profile";
    }


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
        model.addAttribute("card", card);
        return "cardDetails";
    }

}
