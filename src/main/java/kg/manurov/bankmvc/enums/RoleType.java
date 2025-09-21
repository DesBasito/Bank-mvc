package kg.manurov.bankmvc.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;
import java.util.Objects;

@Getter
@AllArgsConstructor
public enum RoleType implements EnumInterface{
    ADMIN("Админ",2L), USER("Простой смертный 💩", 1L);

    private final String description;
    private final Long id;

    public static RoleType getById(Long id) {
        return Arrays.stream(RoleType.values())
                .filter(roleType -> Objects.equals(roleType.getId(), id))
                .findFirst()
                .orElse(null);
    }

    public static Boolean existsById(Long id) {
        return getById(id) != null;
    }

}
