package kg.manurov.bankmvc.dto.mappers;

import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.entities.CardApplication;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import org.springframework.stereotype.Component;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

@Component
public class CardApplicationMapper {

    public CardApplicationDto mapToDto(CardApplication application) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd.MM.yyyy");

        return CardApplicationDto.builder()
                .id(application.getId())
                .userId(application.getUser().getId())
                .userName(String.format("%s %s %s",
                        application.getUser().getFirstName(),
                        application.getUser().getLastName(),
                        application.getUser().getMiddleName()))
                .cardType(application.getCardType())
                .comment(application.getComment())
                .status(application.getStatus())
                .createdAt(formatInstant(application.getCreatedAt(), formatter))
                .processedAt(formatInstant(application.getProcessedAt(), formatter))
                .build();
    }

    private String formatInstant(Instant instant, DateTimeFormatter formatter) {
        if (instant!=null) return instant.atZone(ZoneId.systemDefault()).format(formatter);
        else return "";
    }

    public CardApplication toEntity(User user, CardApplicationRequest request) {
        return CardApplication.builder()
                .user(user)
                .cardType(request.getCardType())
                .comment(request.getComment())
                .status(CardRequestStatus.PENDING.name())
                .build();
    }
}
