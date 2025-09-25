package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.mappers.UserMapper;
import kg.manurov.bankmvc.dto.users.SignUpRequest;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserService implements UserDetailsService {
    private final UserRepository repository;
    private final CardRepository cardRepository;
    private final UserMapper userMapper;

    @Transactional
    public User create(SignUpRequest request) {
        User user = userMapper.toEntity(request);
        log.info("Создание нового пользователя: {}", user.getFullName());
        return repository.save(user);
    }

    @Transactional(readOnly = true)
    public Page<UserDto> getAllUsers(Pageable pageable) {
        log.info("Получение списка всех пользователей, страница: {}, размер: {}",
                pageable.getPageNumber(), pageable.getPageSize());

        Page<User> page = repository.findAll(pageable);

        List<UserDto> filtered = page.getContent().stream()
                .filter(u -> "USER".equals(u.getRole().getName()))
                .map(userMapper::toDto)
                .toList();

        return new PageImpl<>(filtered, pageable, filtered.size());
    }

    @Transactional(readOnly = true)
    public UserDto getUserById(Long id) {
        log.info("Поиск пользователя по ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Пользователь с ID " + id + " не найден"));

        return userMapper.toDto(user);
    }

    @Transactional
    public UserDto toggleUserStatus(Long id) {
        log.info("Изменение статуса пользователя с ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Пользователь с ID " + id + " не найден"));

        user.setEnabled(!user.getEnabled());

        User updatedUser = repository.save(user);
        log.info("Статус пользователя {} изменен на: {}",
                updatedUser.getFullName(), updatedUser.getEnabled() ? "активен" : "заблокирован");

        return userMapper.toDto(updatedUser);
    }

    @Transactional
    public void deleteUser(Long id) {
        log.info("Удаление пользователя с ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("Пользователь с ID " + id + " не найден"));

        boolean hasActiveCards = cardRepository.findActiveCardsByOwnerId(id).isEmpty();
        if (hasActiveCards) {
            throw new IllegalArgumentException("Нельзя удалить пользователя с активными картами");
        }

        repository.delete(user);
        log.info("Пользователь {} успешно удален", user.getFullName());
    }


    @Override
    public UserDetails loadUserByUsername(String phoneNumber) throws UsernameNotFoundException {
        return repository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new UsernameNotFoundException("Пользователь не найден"));
    }
}