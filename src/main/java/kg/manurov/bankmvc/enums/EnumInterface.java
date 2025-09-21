package kg.manurov.bankmvc.enums;

public interface EnumInterface {
    static <E extends Enum<E> & EnumInterface> Boolean isExists(Class<E> enumClass,String value) {
        for (E type : enumClass.getEnumConstants()) {
            if (type.name().equalsIgnoreCase(value.strip())) {
                return true;
            }
        }
        return false;
    }

    static  <E extends Enum<E> & EnumInterface> String getEnumDescription(Class<E> enumClass) {
        StringBuilder str = new StringBuilder();
        str.append("The wrong type is indicated. Indicate one of: ");
        for (E enumValue : enumClass.getEnumConstants()) {
            str.append(String.format("-> %s",enumValue.name()));
        }
        return str.toString();
    }
}