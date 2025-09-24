package kg.manurov.bankmvc.dto.users;

import kg.manurov.bankmvc.dto.cards.CardDto;
import jakarta.validation.constraints.NotNull;
import lombok.*;
import lombok.experimental.FieldDefaults;

import java.util.List;

@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@Getter@Setter
@AllArgsConstructor
@NoArgsConstructor
public class UserDto {
    Long id;
    @NotNull
    String phoneNumber;
    @NotNull
    String firstName;
    @NotNull
    String middleName;
    @NotNull
    String lastName;
    Boolean enabled;
    List<CardDto> cards;

    public String getFullName(){
        return String.format("%s %s %s%n", firstName, middleName != null ? middleName : "", lastName);
    }
}