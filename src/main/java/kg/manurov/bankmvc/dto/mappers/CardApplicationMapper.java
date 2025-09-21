package kg.manurov.bankmvc.dto.mappers;

import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.entities.CardApplication;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.enums.CardType;
import kg.manurov.bankmvc.enums.EnumInterface;
import org.springframework.stereotype.Component;

@Component
public class CardApplicationMapper {

    public CardApplicationDto mapToDto(CardApplication application) {
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
                .createdAt(application.getCreatedAt())
                .processedAt(application.getProcessedAt())
                .build();
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
