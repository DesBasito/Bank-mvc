
package kg.manurov.bankmvc.service;

import kg.manurov.bankmvc.dto.cardApplication.CardApplicationDto;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.dto.cards.CardDto;
import kg.manurov.bankmvc.dto.mappers.CardApplicationMapper;
import kg.manurov.bankmvc.entities.CardApplication;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.repositories.CardApplicationRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import kg.manurov.bankmvc.service.specifications.CardApplicationSpecification;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.*;
import org.springframework.data.jpa.domain.Specification;

import java.time.Instant;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CardApplicationService Tests")
class CardApplicationServiceTest {

    @Mock
    private CardApplicationRepository cardApplicationRepository;

    @Mock
    private CardApplicationMapper cardApplicationMapper;

    @Mock
    private UserRepository userRepository;

    @Mock
    private CardService cardService;

    @InjectMocks
    private CardApplicationService cardApplicationService;

    private User testUser;
    private CardApplication testApplication;
    private CardApplicationDto testApplicationDto;
    private CardApplicationRequest testRequest;
    private CardDto testCardDto;

    @BeforeEach
    void setUp() {
        testUser = new User();
        testUser.setId(1L);
        testUser.setFirstName("John");
        testUser.setLastName("Doe");
        testUser.setPhoneNumber("+996700123456");

        testApplication = new CardApplication();
        testApplication.setId(1L);
        testApplication.setUser(testUser);
        testApplication.setCardType("VISA");
        testApplication.setStatus(CardRequestStatus.PENDING.name());
        testApplication.setCreatedAt(Instant.now());

        testApplicationDto = new CardApplicationDto();
        testApplicationDto.setId(1L);
        testApplicationDto.setUserName("John Doe");
        testApplicationDto.setCardType("VISA");
        testApplicationDto.setStatus(CardRequestStatus.PENDING.name());


        testCardDto = new CardDto();
        testCardDto.setId(1L);
        testCardDto.setType("VISA");
        testCardDto.setOwnerName("John Doe");
    }


    @Test
    @DisplayName("Should create card application successfully")
    void createCardApplication_ShouldCreateApplication_WhenValidInput() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(testUser));
        when(cardApplicationMapper.toEntity(testUser, testRequest)).thenReturn(testApplication);
        when(cardApplicationRepository.save(any(CardApplication.class))).thenReturn(testApplication);
        when(cardApplicationMapper.mapToDto(testApplication)).thenReturn(testApplicationDto);

        CardApplicationDto result = cardApplicationService.createCardApplication(1L, testRequest);

        assertNotNull(result);
        assertEquals(testApplicationDto.getCardType(), result.getCardType());
        verify(userRepository, times(1)).findById(1L);
        verify(cardApplicationRepository, times(1)).save(any(CardApplication.class));
    }

    @Test
    @DisplayName("Should throw exception when user not found for application creation")
    void createCardApplication_ShouldThrowException_WhenUserNotFound() {
        when(userRepository.findById(anyLong())).thenReturn(Optional.empty());

        assertThrows(NoSuchElementException.class,
                () -> cardApplicationService.createCardApplication(999L, testRequest));
        verify(userRepository, times(1)).findById(999L);
        verify(cardApplicationRepository, never()).save(any(CardApplication.class));
    }

    @Test
    @DisplayName("Should approve card application successfully")
    void approveCardApplication_ShouldApproveAndCreateCard_WhenApplicationPending() {
        when(cardApplicationRepository.findById(1L)).thenReturn(Optional.of(testApplication));
        when(cardService.createCard(testUser.getId(), testApplication.getCardType())).thenReturn(testCardDto);
        when(cardApplicationRepository.save(any(CardApplication.class))).thenReturn(testApplication);

        cardApplicationService.approveCardApplication(1L);

        assertEquals(CardRequestStatus.APPROVED.name(), testApplication.getStatus());
        verify(cardApplicationRepository, times(1)).findById(1L);
        verify(cardService, times(1)).createCard(testUser.getId(), testApplication.getCardType());
        verify(cardApplicationRepository, times(1)).save(testApplication);
    }

    @Test
    @DisplayName("Should throw exception when approving non-pending application")
    void approveCardApplication_ShouldThrowException_WhenApplicationNotPending() {
        testApplication.setStatus(CardRequestStatus.APPROVED.name());
        when(cardApplicationRepository.findById(1L)).thenReturn(Optional.of(testApplication));

        assertThrows(IllegalArgumentException.class,
                () -> cardApplicationService.approveCardApplication(1L));
        verify(cardApplicationRepository, times(1)).findById(1L);
        verify(cardService, never()).createCard(anyLong(), anyString());
    }

    @Test
    @DisplayName("Should reject card application successfully")
    void rejectCardApplication_ShouldRejectApplication_WhenApplicationPending() {
        String rejectionReason = "Insufficient documents";
        when(cardApplicationRepository.findById(1L)).thenReturn(Optional.of(testApplication));
        when(cardApplicationRepository.save(any(CardApplication.class))).thenReturn(testApplication);

        cardApplicationService.rejectCardApplication(1L, rejectionReason);

        assertEquals(CardRequestStatus.REJECTED.name(), testApplication.getStatus());
        assertEquals("Rejection reason: "+rejectionReason, testApplication.getComment());
        verify(cardApplicationRepository, times(1)).findById(1L);
        verify(cardApplicationRepository, times(1)).save(testApplication);
    }

    @Test
    @DisplayName("Should get user applications with pagination")
    void getUserApplications_ShouldReturnApplications_WhenUserHasApplications() {
        Pageable pageable = PageRequest.of(0, 10);
        List<CardApplication> applications = List.of(testApplication);
        Page<CardApplication> applicationPage = new PageImpl<>(applications, pageable, applications.size());

        when(cardApplicationRepository.findAll(any(Specification.class), eq(pageable))).thenReturn(applicationPage);
        when(cardApplicationMapper.mapToDto(testApplication)).thenReturn(testApplicationDto);

        Page<CardApplicationDto> result = cardApplicationService.getUserApplications(1L, pageable);

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.getTotalElements());
        verify(cardApplicationRepository, times(1)).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("Should get all applications with status filter")
    void getAllApplications_ShouldReturnFilteredApplications_WhenStatusProvided() {
        String status = "PENDING";
        Pageable pageable = PageRequest.of(0, 10);
        List<CardApplication> applications = List.of(testApplication);
        Page<CardApplication> applicationPage = new PageImpl<>(applications, pageable, applications.size());

        when(cardApplicationRepository.findAll(any(Specification.class), eq(pageable))).thenReturn(applicationPage);
        when(cardApplicationMapper.mapToDto(testApplication)).thenReturn(testApplicationDto);

        Page<CardApplicationDto> result = cardApplicationService.getAllApplications(status, pageable);

        assertNotNull(result);
        assertFalse(result.isEmpty());
        assertEquals(1, result.getTotalElements());
        verify(cardApplicationRepository, times(1)).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("Should throw exception when application not found")
    void approveCardApplication_ShouldThrowException_WhenApplicationNotFound() {
        when(cardApplicationRepository.findById(anyLong())).thenReturn(Optional.empty());

        assertThrows(NoSuchElementException.class,
                () -> cardApplicationService.approveCardApplication(999L));
        verify(cardApplicationRepository, times(1)).findById(999L);
    }
}