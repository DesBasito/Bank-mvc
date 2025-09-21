package kg.manurov.bankmvc.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum TransactionStatus implements EnumInterface{
    SUCCESS("Успешно"), CANCELLED("Отклонена самим заказчиком 💅🏿"), FAILED("Что то пошло не так 🤡."), REFUNDED("Возвращено"), PENDING("В ожидании");

    private final String description;
}
