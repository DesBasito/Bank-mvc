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
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.NoSuchElementException;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class CardApplicationService {
    private final CardApplicationRepository cardApplicationRepository;
    private final CardApplicationMapper mapper;
    private final UserRepository userRepository;
    private final CardService cardService;


    public CardApplicationDto createCardApplication(Long userId, CardApplicationRequest request) {
        log.info("Creating card application for user with ID: {}", userId);

        User user = userRepository.findById(userId)
                .orElseThrow(() -> new NoSuchElementException("User not found"));
        CardApplication application = mapper.toEntity(user, request);
        CardApplication savedApplication = cardApplicationRepository.save(application);

        log.info("Card application created with ID: {}", savedApplication.getId());

        return mapper.mapToDto(savedApplication);
    }

    public void approveCardApplication(Long applicationId) {
        log.info("Approving card application with ID: {}", applicationId);

        CardApplication application = cardApplicationRepository.findById(applicationId)
                .orElseThrow(() -> new NoSuchElementException("Application not found"));

        if (!CardRequestStatus.PENDING.name().equals(application.getStatus())) {
            throw new IllegalArgumentException("Application has already been processed");
        }

        CardDto savedCard = cardService.createCard(application.getUser().getId(), application.getCardType());


        application.setStatus(CardRequestStatus.APPROVED.name());
        application.setProcessedAt(Instant.now());
        cardApplicationRepository.save(application);

        log.info("Application approved, card created with ID: {}", savedCard.getId());
    }

    public void rejectCardApplication(Long applicationId, String reason) {
        log.info("Rejecting card application with ID: {}, reason: {}", applicationId, reason);

        CardApplication application = cardApplicationRepository.findById(applicationId)
                .orElseThrow(() -> new NoSuchElementException("Application not found"));

        if (!CardRequestStatus.PENDING.name().equals(application.getStatus())) {
            throw new IllegalArgumentException("Application has already been processed");
        }

        application.setStatus(CardRequestStatus.REJECTED.name());
        application.setProcessedAt(Instant.now());
        if (reason != null) {
            application.setComment(application.getComment() != null ?
                    application.getComment() + " | "
                    : "Rejection reason: " + reason);
        }

        cardApplicationRepository.save(application);

        log.info("Application rejected");
    }


    public void cancelCardApplication(Long applicationId, Long userId) {
        log.info("Canceling card application with ID: {} by user with ID: {}", applicationId, userId);

        CardApplication application = cardApplicationRepository.findById(applicationId)
                .orElseThrow(() -> new NoSuchElementException("Application not found"));

        if (!application.getUser().getId().equals(userId)) {
            throw new IllegalArgumentException("No access to this application");
        }
        if (!CardRequestStatus.PENDING.name().equals(application.getStatus())) {
            throw new IllegalArgumentException("Only applications with 'Pending' status can be cancelled");
        }
        application.setStatus(CardRequestStatus.CANCELLED.name());
        application.setProcessedAt(Instant.now());

        cardApplicationRepository.save(application);

        log.info("Application cancelled by user");
    }


    @Transactional(readOnly = true)
    public Page<CardApplicationDto> getUserApplications(Long userId, Pageable pageable) {
        Specification<CardApplication> cardApplicationSpecification = CardApplicationSpecification.createSpecificationByUserId(userId);
        return cardApplicationRepository.findAll(cardApplicationSpecification, pageable)
                .map(mapper::mapToDto);
    }


    @Transactional(readOnly = true)
    public Page<CardApplicationDto> getAllApplications(String status, Pageable pageable) {
        Specification<CardApplication> cardApplicationSpecification = CardApplicationSpecification.createSpecification(status);
        return cardApplicationRepository.findAll(cardApplicationSpecification, pageable)
                .map(mapper::mapToDto);
    }
}