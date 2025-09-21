package kg.manurov.bankmvc.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CardType implements EnumInterface {
    DEBIT("Дебетовая карта"), CREDIT("Кредитная карта 🇮🇱"), VIRTUAL("Виртуальная карта 🔎"), PREPAID("какая то карта, фиг его 🤷🏿‍♂️");

    private String description;
}
