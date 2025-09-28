package kg.manurov.bankmvc.aspects;

import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.util.EncryptionUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
@RequiredArgsConstructor
//Epam
public class CardEncryptionAspect {
    private final EncryptionUtil encryptionUtil;

    @Before("execution(* kg.manurov.bankmvc.repositories.*.save(..)) && args(card)")
    public void encryptCardNumberBeforeSave(JoinPoint joinPoint, Card card) {
        log.debug("Encrypting card number before saving card with ID: {}", card.getId());

        String cardNumber = card.getCardNumber();
        if (cardNumber != null && !isAlreadyEncrypted(cardNumber)) {
            String encryptedCardNumber = encryptionUtil.encryptCardNumber(cardNumber);
            card.setCardNumber(encryptedCardNumber);
            log.debug("Card number encrypted for card with ID: {}", card.getId());
        } else {
            log.debug("Card number is already encrypted or null for card with ID: {}", card.getId());
        }
    }

    private boolean isAlreadyEncrypted(String cardNumber) {
        return !cardNumber.matches("\\d+");
    }
}
