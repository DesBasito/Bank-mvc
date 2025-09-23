package kg.manurov.bankmvc.handlers;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.util.NoSuchElementException;

@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {
    @ExceptionHandler(NoSuchElementException.class)
    public String noSuchElementException(NoSuchElementException e, Model model) {
        log.error(e.getMessage());
        model.addAttribute("status", HttpStatus.NOT_FOUND.value());
        model.addAttribute("reason", HttpStatus.NOT_FOUND.getReasonPhrase());
        model.addAttribute("message", e.getMessage());
        return "exceptions/error";
    }

        @ExceptionHandler(NullPointerException.class)
    public String nullPointerExceptions(NullPointerException e,Model model){
        log.error(e.getMessage());
            model.addAttribute("status", HttpStatus.NO_CONTENT.value());
            model.addAttribute("reason", HttpStatus.NO_CONTENT.getReasonPhrase());
            model.addAttribute("message", e.getMessage());
        return "exceptions/error";
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public String alreadyExistsException(IllegalArgumentException ex, Model model, HttpServletRequest request) {
        log.error(ex.getMessage());
        model.addAttribute("message", ex.getMessage());
        model.addAttribute("status", HttpStatus.CONFLICT.value());
        model.addAttribute("reason", HttpStatus.CONFLICT.getReasonPhrase());
        model.addAttribute("details",request);
        return "exceptions/error";
    }
}
