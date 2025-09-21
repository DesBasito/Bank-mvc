package kg.manurov.bankmvc.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum CardRequestStatus implements EnumInterface{
    PENDING("В ожидании"), APPROVED("Подтверждена"), REJECTED("Отклонена 🖕🏿"), CANCELLED("Отклонена самим заказчиком 💅🏿");
    private final String description;
}
