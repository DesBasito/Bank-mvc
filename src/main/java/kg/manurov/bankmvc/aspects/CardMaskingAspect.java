package kg.manurov.bankmvc.aspects;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.transactions.TransactionDto;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import kg.manurov.bankmvc.util.EncryptionUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect
@Component
@RequiredArgsConstructor
@Slf4j
//Epam
public class CardMaskingAspect {
    private final EncryptionUtil encryptionUtil;
    private final AuthenticatedUserUtil userUtil;

    @AfterReturning(
            pointcut = "execution(* kg.manurov.bankmvc.dto.mappers.CardMapper.toDto*(..)) ||"+
                       "execution(* kg.manurov.bankmvc.dto.mappers.CardBlockRequestMapper.toDto*(..)) ||"+
                       "execution(* kg.manurov.bankmvc.dto.mappers.TransactionMapper.toDto*(..))",
            returning = "result")
    public void maskSingleCardDto(Object result) {
        if (result instanceof CardDto cardDto) {
            maskCardDto(cardDto);
        }else if (result instanceof  TransactionDto transactionDto){
            maskTransactionDto(transactionDto);
        }
    }

    private void maskCardDto(CardDto cardDto) {
        try {
            String currentUsername = userUtil.getCurrentUsername();
            boolean isAdmin = userUtil.isCurrentUserAdmin();
            boolean isOwner = userUtil.isCardOwner(cardDto.getOwnerId(), currentUsername);

            log.debug("Маскирование карты ID: {}, пользователь: {}, админ: {}, владелец: {}",
                    cardDto.getId(), currentUsername, isAdmin, isOwner);
            String maskedNumber;
            if (!isAlreadyDecrypted(cardDto.getCardNumber())) {
                cardDto.setCardNumber(encryptionUtil.decryptCardNumber(cardDto.getCardNumber()));
            }
            if (isOwner) {
                maskedNumber = cardDto.getCardNumber();
            } else {
                maskedNumber = encryptionUtil.maskCardNumber(cardDto.getCardNumber());
            }

            cardDto.setCardNumber(maskedNumber);

        } catch (Exception e) {
            log.warn("Ошибка при маскировании номера карты: {}", e.getMessage());
            cardDto.setCardNumber("****");
        }
    }

    private void maskTransactionDto(TransactionDto transactionDto) {
        try {
            String currentUsername = userUtil.getCurrentUsername();
            boolean isAdmin = userUtil.isCurrentUserAdmin();
            boolean isOwner = userUtil.isCardOwner(transactionDto.getToCardId(), currentUsername);

            log.debug("Маскирование номера карты в транзакции ID: {} , пользователь: {}, админ: {}, владелец: {}",
                    transactionDto.getId(), currentUsername, isAdmin, isOwner);

            if (isAdmin) {
                transactionDto.setFromCardNumber(encryptionUtil.maskCardNumber(transactionDto.getFromCardNumber()));
                transactionDto.setToCardNumber(encryptionUtil.maskCardNumber(transactionDto.getToCardNumber()));
            }

        } catch (Exception e) {
            log.warn("Ошибка при маскировании номера карты: {}", e.getMessage());
            transactionDto.setFromCardNumber("****");
            transactionDto.setToCardNumber("****");
        }
    }

    private boolean isAlreadyDecrypted(String cardNumber) {
        return cardNumber.matches("\\d{13,19}");
    }
}