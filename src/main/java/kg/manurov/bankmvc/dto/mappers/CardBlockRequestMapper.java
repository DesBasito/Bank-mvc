package kg.manurov.bankmvc.dto.mappers;

import kg.manurov.bankmvc.dto.cards.CardBlockRequestCreateDto;
import kg.manurov.bankmvc.dto.cards.CardBlockRequestDto;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.CardBlockRequest;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.enums.EnumInterface;
import org.springframework.stereotype.Component;

@Component
public class CardBlockRequestMapper {
    public CardBlockRequestDto mapToDto(CardBlockRequest request) {
        return CardBlockRequestDto.builder()
                .id(request.getId())
                .cardId(request.getCard().getId())
                .cardNumber(request.getCard().getCardNumber())
                .userId(request.getUser().getId())
                .userName(String.format("%s %s %s",
                        request.getUser().getFirstName(),
                        request.getUser().getLastName(),
                        request.getUser().getMiddleName()))
                .reason(request.getReason())
                .status(request.getStatus())
                .adminComment(request.getAdminComment())
                .createdAt(request.getCreatedAt())
                .processedAt(request.getProcessedAt())
                .build();
    }

    public CardBlockRequest toEntity(Card card, CardBlockRequestCreateDto request) {
        return CardBlockRequest.builder()
                .card(card)
                .reason(request.getReason())
                .status(CardRequestStatus.PENDING.name())
                .build();
    }
}