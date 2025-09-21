package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.exceptions.ErrorResponseBody;
import jakarta.validation.ConstraintViolation;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;

import java.util.*;

@Service
public class ErrorService {
    public ErrorResponseBody makeResponse(IllegalStateException e) {
        String message = Optional.ofNullable(e.getMessage())
                .orElse("Встречено недопустимое состояние");

        return ErrorResponseBody.builder()
                .title("Ошибка недопустимого состояния")
                .response(Map.of("errors", List.of(message)))
                .build();
    }


    public ErrorResponseBody makeResponse(IllegalArgumentException e) {
        String message = Optional.ofNullable(e.getMessage())
                .orElse("Предоставлен недопустимый аргумент");

        return ErrorResponseBody.builder()
                .title("Ошибка недопустимого аргумента")
                .response(Map.of("errors", List.of(message)))
                .build();
    }

    public ErrorResponseBody makeResponse(DataIntegrityViolationException e) {
        String rootMessage = Optional.ofNullable(e.getRootCause())
                .map(Throwable::getMessage)
                .orElse(e.getMessage());

        String userFriendlyMessage = parseSqlMessage(rootMessage);

        return ErrorResponseBody.builder()
                .title("Ошибка ограничения целостности данных")
                .response(Map.of("errors", List.of(userFriendlyMessage)))
                .build();
    }
    private String parseSqlMessage(String sqlMessage) {
        if (sqlMessage == null) return "Неизвестная ошибка базы данных";

        if (sqlMessage.contains("violates not-null constraint")) {
            String column = extractColumn(sqlMessage);
            return "Поле \"" + column + "\" не может быть пустым.";
        }

        if (sqlMessage.contains("duplicate key")) {
            return "Нарушено ограничение уникальности. Такая запись уже существует.";
        }

        return sqlMessage;
    }

    private String extractColumn(String msg) {
        int colIndex = msg.indexOf("column \"");
        if (colIndex >= 0) {
            int start = colIndex + 8;
            int end = msg.indexOf("\"", start);
            return msg.substring(start, end);
        }
        return "неизвестное поле";
    }


    public ErrorResponseBody makeResponse(Exception e) {
        String message = e.getMessage();
        return ErrorResponseBody.builder()
                .title(message)
                .response(Map.of("errors", List.of(message)))
                .build();
    }

    public ErrorResponseBody makeResponse(BindingResult bindingResult) {
        Map<String, List<String>> reasons = new HashMap<>();
        bindingResult.getFieldErrors().stream()
                .filter(error -> error.getDefaultMessage() != null)
                .forEach(err -> {
                    if (!reasons.containsKey(err.getField())) {
                        reasons.put(err.getField(), new ArrayList<>());
                    }
                    reasons.get(err.getField()).add(err.getDefaultMessage());
                });
        return ErrorResponseBody.builder()
                .title("Ошибка валидации")
                .response(reasons)
                .build();
    }

    public ErrorResponseBody makeResponse(Set<ConstraintViolation<?>> constraintViolations) {
        Map<String, List<String>> reasons = new HashMap<>();
        constraintViolations.forEach(violation -> {
            String fieldName = violation.getPropertyPath().toString();
            String errorMessage = violation.getMessage();
            reasons.computeIfAbsent(fieldName, k -> new ArrayList<>()).add(errorMessage);
        });

        return ErrorResponseBody.builder()
                .title("Ошибка валидации")
                .response(reasons)
                .build();
    }
}
