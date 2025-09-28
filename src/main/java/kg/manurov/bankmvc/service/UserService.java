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
        log.info("Creating new user: {}", user.getFullName());
        return repository.save(user);
    }

    @Transactional(readOnly = true)
    public Page<UserDto> getAllUsers(Pageable pageable) {
        log.info("Getting all users, page: {}, size: {}",
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
        log.info("Finding user by ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User with ID " + id + " not found"));

        return userMapper.toDto(user);
    }

    @Transactional
    public UserDto toggleUserStatus(Long id) {
        log.info("Toggling status for user with ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User with ID " + id + " not found"));

        user.setEnabled(!user.getEnabled());

        User updatedUser = repository.save(user);
        log.info("User {} status changed to: {}",
                updatedUser.getFullName(), updatedUser.getEnabled() ? "active" : "blocked");

        return userMapper.toDto(updatedUser);
    }

    @Transactional
    public void deleteUser(Long id) {
        log.info("Deleting user with ID: {}", id);

        User user = repository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User with ID " + id + " not found"));

        boolean hasActiveCards = cardRepository.findActiveCardsByOwnerId(id).isEmpty();
        if (hasActiveCards) {
            throw new IllegalArgumentException("Cannot delete user with active cards");
        }

        repository.delete(user);
        log.info("User {} successfully deleted", user.getFullName());
    }

    @Override
    public UserDetails loadUserByUsername(String phoneNumber) throws UsernameNotFoundException {
        return repository.findByPhoneNumber(phoneNumber)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }
}