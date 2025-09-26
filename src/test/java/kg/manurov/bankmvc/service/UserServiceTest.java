package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.mappers.UserMapper;
import kg.manurov.bankmvc.dto.users.SignUpRequest;
import kg.manurov.bankmvc.dto.users.UserDto;
import kg.manurov.bankmvc.entities.Role;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.repositories.CardRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.*;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("UserService Tests")
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CardRepository cardRepository;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private UserService userService;

    private User testUser;
    private UserDto testUserDto;
    private SignUpRequest signUpRequest;
    private Role userRole;

    @BeforeEach
    void setUp() {
        userRole = new Role();
        userRole.setId(2L);
        userRole.setName("USER");

        testUser = new User();
        testUser.setId(1L);
        testUser.setPhoneNumber("+996700123456");
        testUser.setEnabled(true);
        testUser.setRole(userRole);

        testUserDto = new UserDto();
        testUserDto.setId(1L);
        testUserDto.setPhoneNumber("+996700123456");
        testUserDto.setEnabled(true);

        signUpRequest = new SignUpRequest();
        signUpRequest.setPhoneNumber("+996700123456");
        signUpRequest.setPassword("password123");
    }

    @Test
    @DisplayName("Should create user successfully")
    void create_ShouldCreateUser_WhenValidRequest() {
        when(userMapper.toEntity(signUpRequest)).thenReturn(testUser);
        when(userRepository.save(any(User.class))).thenReturn(testUser);

        User result = userService.create(signUpRequest);

        assertNotNull(result);
        assertEquals(testUser.getFullName(), result.getFullName());
        assertEquals(testUser.getPhoneNumber(), result.getPhoneNumber());
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    @DisplayName("Should get all users with pagination")
    void getAllUsers_ShouldReturnPagedUsers_WhenUsersExist() {
        Pageable pageable = PageRequest.of(0, 10);
        List<User> users = List.of(testUser);
        Page<User> userPage = new PageImpl<>(users, pageable, users.size());

        when(userRepository.findAll(pageable)).thenReturn(userPage);
        when(userMapper.toDto(testUser)).thenReturn(testUserDto);

        Page<UserDto> result = userService.getAllUsers(pageable);

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.getTotalElements());
        verify(userRepository, times(1)).findAll(pageable);
    }

    @Test
    @DisplayName("Should get user by ID successfully")
    void getUserById_ShouldReturnUser_WhenUserExists() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        when(userMapper.toDto(testUser)).thenReturn(testUserDto);

        UserDto result = userService.getUserById(1L);

        assertNotNull(result);
        assertEquals(testUserDto.getFullName(), result.getFullName());
        assertEquals(testUserDto.getPhoneNumber(), result.getPhoneNumber());
        verify(userRepository, times(1)).findById(1L);
    }

    @Test
    @DisplayName("Should throw exception when user not found by ID")
    void getUserById_ShouldThrowException_WhenUserNotExists() {
        when(userRepository.findById(anyLong())).thenReturn(Optional.empty());

        assertThrows(NoSuchElementException.class, () -> userService.getUserById(999L));
        verify(userRepository, times(1)).findById(999L);
    }

    @Test
    @DisplayName("Should toggle user status successfully")
    void toggleUserStatus_ShouldChangeStatus_WhenUserExists() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        when(userRepository.save(any(User.class))).thenReturn(testUser);
        when(userMapper.toDto(testUser)).thenReturn(testUserDto);

        boolean originalStatus = testUser.getEnabled();

        UserDto result = userService.toggleUserStatus(1L);

        assertNotNull(result);
        assertEquals(!originalStatus, testUser.getEnabled());
        verify(userRepository, times(1)).findById(1L);
        verify(userRepository, times(1)).save(testUser);
    }

    @Test
    @DisplayName("Should load user by username successfully")
    void loadUserByUsername_ShouldReturnUserDetails_WhenUserExists() {
        when(userRepository.findByPhoneNumber(testUser.getPhoneNumber())).thenReturn(Optional.of(testUser));

        UserDetails result = userService.loadUserByUsername(testUser.getPhoneNumber());

        assertNotNull(result);
        assertEquals(testUser.getPhoneNumber(), result.getUsername());
        verify(userRepository, times(1)).findByPhoneNumber(testUser.getPhoneNumber());
    }

    @Test
    @DisplayName("Should throw exception when user not found by phone number")
    void loadUserByUsername_ShouldThrowException_WhenUserNotExists() {
        String phoneNumber = "+996700999999";
        when(userRepository.findByPhoneNumber(phoneNumber)).thenReturn(Optional.empty());

        assertThrows(UsernameNotFoundException.class, () -> userService.loadUserByUsername(phoneNumber));
        verify(userRepository, times(1)).findByPhoneNumber(phoneNumber);
    }
}