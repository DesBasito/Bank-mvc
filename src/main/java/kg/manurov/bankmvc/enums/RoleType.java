package kg.manurov.bankmvc.enums;

import lombok.AllArgsConstructor;
import lombok.Getter;

import java.util.Arrays;
import java.util.Objects;


@AllArgsConstructor
public enum RoleType implements EnumInterface{
    ADMIN(2L), USER( 1L);
    private final Long id;

    public static RoleType getById(Long id) {
        return Arrays.stream(RoleType.values())
                .filter(roleType -> Objects.equals(roleType.id, id))
                .findFirst()
                .orElse(null);
    }

    public static Boolean existsById(Long id) {
        return getById(id) != null;
    }

}
