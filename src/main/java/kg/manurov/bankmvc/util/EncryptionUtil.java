package kg.manurov.bankmvc.util;

import kg.manurov.bankmvc.repositories.CardRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

@Component
@RequiredArgsConstructor
@Slf4j
public class EncryptionUtil {

    private final CardRepository cardRepository;
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/CBC/PKCS5Padding";
    private static final int IV_LENGTH = 16;

    @Value("${app.encryption.key}")
    private String encryptionKey;

    public String encryptCardNumber(String cardNumber) {
        try {
            log.debug("Начинаем шифрование номера карты");

            SecretKey secretKey = generateKey();
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);

            byte[] iv = new byte[IV_LENGTH];
            new SecureRandom().nextBytes(iv);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            cipher.init(Cipher.ENCRYPT_MODE, secretKey, ivSpec);
            byte[] encryptedBytes = cipher.doFinal(cardNumber.getBytes(StandardCharsets.UTF_8));

            byte[] encryptedWithIv = new byte[IV_LENGTH + encryptedBytes.length];
            System.arraycopy(iv, 0, encryptedWithIv, 0, IV_LENGTH);
            System.arraycopy(encryptedBytes, 0, encryptedWithIv, IV_LENGTH, encryptedBytes.length);

            String result = Base64.getEncoder().encodeToString(encryptedWithIv);
            log.debug("Номер карты успешно зашифрован, длина результата: {}", result.length());

            return result;
        } catch (Exception e) {
            log.error("Ошибка при шифровании номера карты: {}", e.getMessage(), e);
            throw new RuntimeException("Ошибка при шифровании номера карты", e);
        }
    }

    public String decryptCardNumber(String encryptedCardNumber) {
        try {
            log.debug("Начинаем расшифровку номера карты");

            SecretKey secretKey = generateKey();
            Cipher cipher = Cipher.getInstance(TRANSFORMATION);

            byte[] encryptedWithIv = Base64.getDecoder().decode(encryptedCardNumber);

            if (encryptedWithIv.length < IV_LENGTH) {
                throw new IllegalArgumentException("Недостаточная длина зашифрованных данных");
            }

            byte[] iv = Arrays.copyOfRange(encryptedWithIv, 0, IV_LENGTH);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            byte[] encryptedBytes = Arrays.copyOfRange(encryptedWithIv, IV_LENGTH, encryptedWithIv.length);

            cipher.init(Cipher.DECRYPT_MODE, secretKey, ivSpec);
            byte[] decryptedBytes = cipher.doFinal(encryptedBytes);

            String result = new String(decryptedBytes, StandardCharsets.UTF_8);
            log.debug("Номер карты успешно расшифрован");

            return result;
        } catch (Exception e) {
            log.error("Ошибка при расшифровке номера карты: {}", e.getMessage(), e);
            throw new RuntimeException("Ошибка при расшифровке номера карты", e);
        }
    }

    public String maskCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 4) {
            return "****";
        }

        String cleanNumber = cardNumber.replaceAll("\\s", "");
        if (cleanNumber.length() < 4) {
            return "****";
        }

        String lastFour = cleanNumber.substring(cleanNumber.length() - 4);
        return "**** **** **** " + lastFour;
    }

    public String generateCardNumber() {
        SecureRandom random = new SecureRandom();
        String cardNumber;
        int attempts = 0;
        final int maxAttempts = 100; // Предотвращаем бесконечный цикл

        do {
            if (attempts++ > maxAttempts) {
                throw new RuntimeException("Не удалось сгенерировать уникальный номер карты за " + maxAttempts + " попыток");
            }

            StringBuilder cardNumberBuilder = new StringBuilder();
            cardNumberBuilder.append("4000");

            for (int i = 0; i < 8; i++) {
                cardNumberBuilder.append(random.nextInt(10));
            }

            for (int i = 0; i < 3; i++) {
                cardNumberBuilder.append(random.nextInt(10));
            }

            int checkDigit = calculateLuhnCheckDigit(cardNumberBuilder.toString());
            cardNumberBuilder.append(checkDigit);

            cardNumber = cardNumberBuilder.toString();

            if (!isValidCardNumber(cardNumber)) {
                log.debug("Сгенерированный номер карты невалидный, повторяем генерацию");
                continue;
            }

            String encryptedCardNumber = encryptCardNumber(cardNumber);

            if (!cardRepository.existsByCardNumber(encryptedCardNumber)) {
                log.debug("Сгенерирован уникальный номер карты за {} попыток", attempts);
                break;
            }

            log.debug("Сгенерированный номер карты уже существует, повторяем генерацию");

        } while (true);

        return cardNumber;
    }

    public boolean isValidCardNumber(String cardNumber) {
        if (cardNumber == null || cardNumber.length() < 13 || cardNumber.length() > 19) {
            return false;
        }

        String cleanNumber = cardNumber.replaceAll("\\s", "");

        if (!cleanNumber.matches("\\d+")) {
            return false;
        }

        return isLuhnValid(cleanNumber);
    }

    private SecretKey generateKey() {
        try {
            if (encryptionKey == null || encryptionKey.trim().isEmpty()) {
                throw new IllegalStateException("Ключ шифрования не настроен");
            }

            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] keyBytes = digest.digest(encryptionKey.getBytes(StandardCharsets.UTF_8));
            byte[] key = new byte[16];
            System.arraycopy(keyBytes, 0, key, 0, 16);

            return new SecretKeySpec(key, ALGORITHM);
        } catch (Exception e) {
            log.error("Ошибка при генерации ключа шифрования: {}", e.getMessage(), e);
            throw new RuntimeException("Ошибка при генерации ключа", e);
        }
    }

    private int calculateLuhnCheckDigit(String number) {
        int sum = 0;
        boolean alternate = true;

        sum = getSum(number, sum, alternate);

        return (10 - (sum % 10)) % 10;
    }

    private boolean isLuhnValid(String number) {
        int sum = 0;
        boolean alternate = false;

        sum = getSum(number, sum, alternate);

        return (sum % 10) == 0;
    }

    private int getSum(String number, int sum, boolean alternate) {
        for (int i = number.length() - 1; i >= 0; i--) {
            int digit = Character.getNumericValue(number.charAt(i));

            if (alternate) {
                digit *= 2;
                if (digit > 9) {
                    digit = (digit % 10) + 1;
                }
            }

            sum += digit;
            alternate = !alternate;
        }
        return sum;
    }
}