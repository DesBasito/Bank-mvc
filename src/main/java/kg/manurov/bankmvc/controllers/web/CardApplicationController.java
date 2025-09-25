package kg.manurov.bankmvc.controllers.web;

import io.swagger.v3.oas.annotations.Parameter;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.service.CardApplicationService;
import kg.manurov.bankmvc.service.CardBlockRequestService;
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

@Slf4j
@Controller
@RequestMapping("/card-applications")
@RequiredArgsConstructor
public class CardApplicationController {
    private final CardApplicationService cardApplicationService;
    private final CardBlockRequestService blockRequestService;
    private final AuthenticatedUserUtil userUtil;

    @GetMapping("/my")
    @PreAuthorize("hasRole('USER')")
    public String getMyApplications(
            @PageableDefault(size = 2, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Long userId = userUtil.getCurrentUserId();
        Page<CardBlockRequestDto> blockRequests = blockRequestService.getUserBlockRequests(userId, pageable);
        Page<CardApplicationDto> applications = cardApplicationService.getUserApplications(userId, pageable);
        model.addAttribute("applications",applications);
        model.addAttribute("blockRequests",blockRequests);
        return "user/userApplicationPage";
    }

    @GetMapping("/admin/all")
    @PreAuthorize("hasRole('ADMIN')")
    public String getAllApplications(
            @RequestParam(required = false) String status,
            @PageableDefault(size = 2, sort = "createdAt", direction = Sort.Direction.DESC)
            Pageable pageable, Model model) {

        Page<CardApplicationDto> applications = cardApplicationService.getAllApplications(status, pageable);
        Page<CardBlockRequestDto> blockRequests = blockRequestService.getAllBlockRequests(pageable);

        model.addAttribute("applications", applications);
        model.addAttribute("blockRequests", blockRequests);
        model.addAttribute("status", status);

        return "admin/adminCardApplication";
    }

}
