package kg.manurov.bankmvc.dto.mappers;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardStatus;
import kg.manurov.bankmvc.enums.CardType;
import kg.manurov.bankmvc.enums.EnumInterface;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.ZoneId;

@Slf4j
@Component
public class CardMapper {
    @Value("${app.expiry_date}")
    private Integer expiryDate;
    
    public CardDto toDto(Card card) {
        ZoneId zoneId = ZoneId.systemDefault();
        CardDto dto = new CardDto();
        dto.setId(card.getId());
        dto.setCardNumber(card.getCardNumber());

        dto.setOwnerName(String.format("%s %s %s",
                card.getOwner().getFirstName(),
                card.getOwner().getLastName(),
                card.getOwner().getMiddleName()));
        dto.setOwnerId(card.getOwner().getId());
        dto.setExpiryDate(card.getExpiryDate());
        dto.setStatus(card.getStatus());
        dto.setType(card.getType());
        dto.setBalance(card.getBalance());
        dto.setCreatedAt(LocalDate.ofInstant(card.getCreatedAt(), zoneId));
        dto.setUpdatedAt(LocalDate.ofInstant(card.getUpdatedAt(), zoneId));

        return dto;
    }

    public Card createEntity(User owner, String encryptedCardNumber, String cardType) {
        return new Card().setCardNumber(encryptedCardNumber)
        .setOwner(owner)
        .setType(cardType)
        .setExpiryDate(LocalDate.now().plusYears(this.expiryDate))
        .setStatus(CardStatus.ACTIVE.name())
        .setBalance(BigDecimal.ZERO);
    }
}