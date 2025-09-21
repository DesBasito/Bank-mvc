package kg.manurov.bankmvc.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CardStatus implements EnumInterface{
    ACTIVE("активна 🫶🏿"), BLOCKED("заблокирована 🤡"), EXPIRED("прокис 🤢");

    private final String description;
}
