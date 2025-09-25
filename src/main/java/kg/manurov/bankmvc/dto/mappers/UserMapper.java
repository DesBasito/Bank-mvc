package kg.manurov.bankmvc.dto.mappers;

import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.users.SignUpRequest;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.entities.Role;
import kg.manurov.bankmvc.entities.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.List;

@Slf4j
@Component
@RequiredArgsConstructor
public class UserMapper {

    private final CardMapper cardMapper;
    private final PasswordEncoder encoder;

    public UserDto toDto(User user) {
        UserDto dto = getUserDto(user);

        if (user.getCards() != null && !user.getCards().isEmpty()) {
            List<CardDto> cardDtos = user.getCards().stream()
                    .map(cardMapper::toDto)
                    .toList();
            dto.setCards(cardDtos);
        }

        return dto;
    }

    public User toEntity(SignUpRequest request) {
        return User.builder()
                .firstName(request.getName())
                .lastName(request.getSurname())
                .middleName(request.getMiddleName())
                .phoneNumber(request.getPhoneNumber())
                .role(new Role().setId(1L))
                .password(encoder.encode(request.getPassword()))
                .enabled(true)
                .build();
    }

    private UserDto getUserDto(User user) {
        UserDto dto = new UserDto();
        dto.setId(user.getId());
        dto.setPhoneNumber(user.getPhoneNumber());
        dto.setFirstName(user.getFirstName());
        dto.setMiddleName(user.getMiddleName());
        dto.setLastName(user.getLastName());
        dto.setEnabled(user.getEnabled());
        return dto;
    }
}