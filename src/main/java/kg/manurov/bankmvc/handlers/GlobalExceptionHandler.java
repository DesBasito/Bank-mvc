package kg.manurov.bankmvc.handlers;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;

import java.util.NoSuchElementException;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {


    @ExceptionHandler(NoSuchElementException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public String handleNoSuchElementException(NoSuchElementException e, Model model, HttpServletRequest request) {
        log.error("Resource not found: {}", e.getMessage());

        model.addAttribute("status", HttpStatus.NOT_FOUND.value());
        model.addAttribute("reason", "Not Found");
        model.addAttribute("message", e.getMessage());
        model.addAttribute("description", "The requested resource could not be found.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }

    @ExceptionHandler(AccessDeniedException.class)
    @ResponseStatus(HttpStatus.FORBIDDEN)
    public String handleAccessDeniedException(AccessDeniedException e, Model model, HttpServletRequest request) {
        log.warn("Access denied for user attempting to access: {} - {}",
                request.getRequestURI(), e.getMessage());

        model.addAttribute("status", HttpStatus.FORBIDDEN.value());
        model.addAttribute("reason", "Access Denied");
        model.addAttribute("message", "You don't have permission to access this resource");
        model.addAttribute("description", "This page requires administrator privileges. Please contact your system administrator if you believe this is an error.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }


    @ExceptionHandler(NullPointerException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleNullPointerException(NullPointerException e, Model model, HttpServletRequest request) {
        log.error("Null pointer exception: {}", e.getMessage(), e);

        model.addAttribute("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
        model.addAttribute("reason", "Internal Server Error");
        model.addAttribute("message", "An internal error occurred while processing your request");
        model.addAttribute("description", "Please try again later or contact support if the problem persists.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public String handleIllegalArgumentException(IllegalArgumentException ex, Model model, HttpServletRequest request) {
        log.error("Illegal argument exception: {}", ex.getMessage());

        model.addAttribute("status", HttpStatus.CONFLICT.value());
        model.addAttribute("reason", "Conflict");
        model.addAttribute("message", ex.getMessage());
        model.addAttribute("description", "The request could not be processed due to a conflict with the current state.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }


    @ExceptionHandler(IllegalStateException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public String handleIllegalStateException(IllegalStateException ex, Model model, HttpServletRequest request) {
        log.error("Illegal state exception: {}", ex.getMessage());

        model.addAttribute("status", HttpStatus.BAD_REQUEST.value());
        model.addAttribute("reason", "Bad Request");
        model.addAttribute("message", ex.getMessage());
        model.addAttribute("description", "The request could not be processed due to invalid state.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }

    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public String handleGenericException(Exception e, Model model, HttpServletRequest request) {
        log.error("Unexpected exception: {} - {}", e.getClass().getSimpleName(), e.getMessage(), e);

        model.addAttribute("status", HttpStatus.INTERNAL_SERVER_ERROR.value());
        model.addAttribute("reason", "Internal Server Error");
        model.addAttribute("message", "An unexpected error occurred");
        model.addAttribute("description", "Please try again later or contact support if the problem persists.");
        model.addAttribute("details", request);

        return "exceptions/error";
    }
}