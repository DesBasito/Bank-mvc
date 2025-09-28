package kg.manurov.bankmvc.controllers.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Slf4j
@Controller
//https://www.baeldung.com/spring-boot-custom-error-page
public class CustomErrorController implements ErrorController {

    @RequestMapping("/error")
    public String handleError(HttpServletRequest request, Model model) {
        Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        int statusCode = status != null ? Integer.parseInt(status.toString()) : 500;

        Throwable exception = (Throwable) request.getAttribute(RequestDispatcher.ERROR_EXCEPTION);
        if (exception == null) {
            exception = (Throwable) request.getAttribute("javax.servlet.error.exception");
        }

        String requestUri = (String) request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI);
        if (requestUri == null) {
            requestUri = request.getRequestURI();
        }

        log.error("Error {} occurred at {}: {}",
                statusCode, requestUri,
                exception != null ? exception.getMessage() : "No exception details");

        model.addAttribute("status", statusCode);
        model.addAttribute("details", request);

        if (statusCode == 404) {
            model.addAttribute("reason", "Not Found");
            model.addAttribute("message", "The requested page could not be found");
            model.addAttribute("description", "The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.");
        } else if (statusCode == 500) {
            model.addAttribute("reason", "Internal Server Error");
            model.addAttribute("message", "An internal server error occurred");
            model.addAttribute("description", "Please try again later or contact support if the problem persists.");
        } else if (statusCode >= 400 && statusCode < 500) {
            model.addAttribute("reason", "Client Error");
            model.addAttribute("message", "There was a problem with your request");
            model.addAttribute("description", "Please check your request and try again.");
        } else {
            model.addAttribute("reason", "Server Error");
            model.addAttribute("message", "An unexpected error occurred");
            model.addAttribute("description", "Please try again later or contact support if the problem persists.");
        }

        // GlobalExceptionHandler handle it
        if (exception instanceof AccessDeniedException) {
            throw (AccessDeniedException) exception;
        }

        return "exceptions/error";
    }
}
