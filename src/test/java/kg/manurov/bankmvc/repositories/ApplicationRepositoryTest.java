package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.CardApplication;
import kg.manurov.bankmvc.entities.Role;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.enums.CardType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.test.context.ActiveProfiles;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@DataJpaTest
@ActiveProfiles("test")
@DisplayName("Card Application Repository JPA Tests")
//https://www.baeldung.com/junit-datajpatest-repository
public class ApplicationRepositoryTest {

    @Autowired
    private TestEntityManager entityManager;

    @Autowired
    private CardApplicationRepository cardApplicationRepository;

    private User testUser1;
    private User testUser2;
    private Role userRole;
    private CardApplication pendingApplication;
    private CardApplication approvedApplication;
    private CardApplication rejectedApplication;

    @BeforeEach
    void setUp() {
        userRole = new Role();
        userRole.setName("USER");
        userRole.setDescription("Default user role");
        entityManager.persist(userRole);

        testUser1 = User.builder()
                .firstName("John")
                .lastName("Doe")
                .phoneNumber("+996700123456")
                .password("password123")
                .enabled(true)
                .role(userRole)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
        entityManager.persist(testUser1);

        testUser2 = User.builder()
                .firstName("Jane")
                .lastName("Smith")
                .phoneNumber("+996700654321")
                .password("password456")
                .enabled(true)
                .role(userRole)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();
        entityManager.persist(testUser2);

        pendingApplication = CardApplication.builder()
                .user(testUser1)
                .cardType(CardType.DEBIT.name())
                .comment("Main salary card")
                .status(CardRequestStatus.PENDING.name())
                .createdAt(Instant.now().minusSeconds(3600))
                .build();
        entityManager.persist(pendingApplication);

        approvedApplication = CardApplication.builder()
                .user(testUser1)
                .cardType(CardType.CREDIT.name())
                .comment("Credit card for purchases")
                .status(CardRequestStatus.APPROVED.name())
                .createdAt(Instant.now().minusSeconds(7200))
                .processedAt(Instant.now().minusSeconds(3600))
                .build();
        entityManager.persist(approvedApplication);

        rejectedApplication = CardApplication.builder()
                .user(testUser2)
                .cardType(CardType.VIRTUAL.name())
                .comment("Virtual card for online shopping")
                .status(CardRequestStatus.REJECTED.name())
                .createdAt(Instant.now().minusSeconds(10800))
                .processedAt(Instant.now().minusSeconds(7200))
                .build();
        entityManager.persist(rejectedApplication);

        entityManager.flush();
        entityManager.clear();
    }

    @Test
    @DisplayName("Should save and find card application by ID")
    void testSaveAndFindById() {
        CardApplication newApplication = CardApplication.builder()
                .user(testUser2)
                .cardType(CardType.PREPAID.name())
                .comment("Prepaid card for travel")
                .status(CardRequestStatus.PENDING.name())
                .createdAt(Instant.now())
                .build();

        CardApplication savedCard = cardApplicationRepository.save(newApplication);
        assertThat(savedCard.getId()).isNotNull();

        Optional<CardApplication> found = cardApplicationRepository.findById(savedCard.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getCardType()).isEqualTo(CardType.PREPAID.name());
        assertThat(found.get().getComment()).isEqualTo("Prepaid card for travel");
        assertThat(found.get().getUser().getId()).isEqualTo(testUser2.getId());
    }

    @Test
    @DisplayName("Should find all applications with pagination")
    void testFindAllWithPagination() {
        Pageable pageable = PageRequest.of(0, 2, Sort.by("createdAt").descending());

        var page = cardApplicationRepository.findAll(pageable);

        assertThat(page).isNotNull();
        assertThat(page.getTotalElements()).isEqualTo(3);
        assertThat(page.getContent()).hasSize(2);
        assertThat(page.getContent().get(0).getId()).isEqualTo(pendingApplication.getId());
        assertThat(page.getContent().get(1).getId()).isEqualTo(approvedApplication.getId());
    }

    @Test
    @DisplayName("Should count applications correctly")
    void testCount() {
        long count = cardApplicationRepository.count();
        assertThat(count).isEqualTo(3);
    }

    @Test
    @DisplayName("Should delete application")
    void testDelete() {
        Long applicationId = pendingApplication.getId();

        cardApplicationRepository.deleteById(applicationId);

        Optional<CardApplication> deleted = cardApplicationRepository.findById(applicationId);
        assertThat(deleted).isEmpty();
        assertThat(cardApplicationRepository.count()).isEqualTo(2);
    }

    @Test
    @DisplayName("Should update application status")
    void testUpdateApplicationStatus() {
        pendingApplication.setStatus(CardRequestStatus.APPROVED.name());
        pendingApplication.setProcessedAt(Instant.now());

        CardApplication updated = cardApplicationRepository.save(pendingApplication);

        assertThat(updated.getStatus()).isEqualTo(CardRequestStatus.APPROVED.name());
        assertThat(updated.getProcessedAt()).isNotNull();
    }

    @Test
    @DisplayName("Should find applications using JPA Specification - by status")
    void testFindByStatusUsingSpecification() {
        Specification<CardApplication> spec = (root, query, criteriaBuilder) ->
                criteriaBuilder.equal(root.get("status"), CardRequestStatus.PENDING.name());

        List<CardApplication> pendingApps = cardApplicationRepository.findAll(spec);

        assertThat(pendingApps).hasSize(1);
        assertThat(pendingApps.get(0).getStatus()).isEqualTo(CardRequestStatus.PENDING.name());
        assertThat(pendingApps.get(0).getId()).isEqualTo(pendingApplication.getId());
    }

    @Test
    @DisplayName("Should find applications using JPA Specification - by user")
    void testFindByUserUsingSpecification() {
        Specification<CardApplication> spec = (root, query, criteriaBuilder) ->
                criteriaBuilder.equal(root.get("user").get("id"), testUser1.getId());

        List<CardApplication> user1Apps = cardApplicationRepository.findAll(spec);

        assertThat(user1Apps).hasSize(2);
        assertThat(user1Apps).allMatch(app -> app.getUser().getId().equals(testUser1.getId()));
    }

    @Test
    @DisplayName("Should find applications using JPA Specification - by card type")
    void testFindByCardTypeUsingSpecification() {
        Specification<CardApplication> spec = (root, query, criteriaBuilder) ->
                criteriaBuilder.equal(root.get("cardType"), CardType.DEBIT.name());

        List<CardApplication> debitApps = cardApplicationRepository.findAll(spec);

        assertThat(debitApps).hasSize(1);
        assertThat(debitApps.get(0).getCardType()).isEqualTo(CardType.DEBIT.name());
    }

    @Test
    @DisplayName("Should find applications using complex JPA Specification")
    void testComplexSpecification() {
        Specification<CardApplication> spec = (root, query, criteriaBuilder) ->
                criteriaBuilder.and(
                        criteriaBuilder.equal(root.get("status"), CardRequestStatus.PENDING.name()),
                        criteriaBuilder.equal(root.get("user").get("id"), testUser1.getId())
                );

        List<CardApplication> result = cardApplicationRepository.findAll(spec);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getStatus()).isEqualTo(CardRequestStatus.PENDING.name());
        assertThat(result.get(0).getUser().getId()).isEqualTo(testUser1.getId());
    }

    @Test
    @DisplayName("Should find applications using specification with pagination and sorting")
    void testSpecificationWithPaginationAndSorting() {
        Specification<CardApplication> spec = (root, query, criteriaBuilder) ->
                criteriaBuilder.equal(root.get("user").get("id"), testUser1.getId());

        Pageable pageable = PageRequest.of(0, 10, Sort.by("createdAt").descending());
        var page = cardApplicationRepository.findAll(spec, pageable);

        assertThat(page.getTotalElements()).isEqualTo(2);
        assertThat(page.getContent()).hasSize(2);

        assertThat(page.getContent().get(0).getCreatedAt())
                .isAfter(page.getContent().get(1).getCreatedAt());
    }

    @Test
    @DisplayName("Should check if application exists by ID")
    void testExistsById() {
        boolean exists = cardApplicationRepository.existsById(pendingApplication.getId());
        assertThat(exists).isTrue();

        boolean notExists = cardApplicationRepository.existsById(999L);
        assertThat(notExists).isFalse();
    }

    @Test
    @DisplayName("Should find applications by multiple IDs")
    void testFindAllById() {
        List<Long> ids = List.of(pendingApplication.getId(), approvedApplication.getId());

        List<CardApplication> applications = cardApplicationRepository.findAllById(ids);

        assertThat(applications).hasSize(2);
        assertThat(applications)
                .extracting(CardApplication::getId)
                .containsExactlyInAnyOrder(pendingApplication.getId(), approvedApplication.getId());
    }

    @Test
    @DisplayName("Should handle batch operations")
    void testBatchOperations() {
        CardApplication app1 = CardApplication.builder()
                .user(testUser2)
                .cardType(CardType.DEBIT.name())
                .comment("Batch test 1")
                .status(CardRequestStatus.PENDING.name())
                .createdAt(Instant.now())
                .build();

        CardApplication app2 = CardApplication.builder()
                .user(testUser2)
                .cardType(CardType.CREDIT.name())
                .comment("Batch test 2")
                .status(CardRequestStatus.PENDING.name())
                .createdAt(Instant.now())
                .build();

        List<CardApplication> applications = List.of(app1, app2);

        List<CardApplication> saved = cardApplicationRepository.saveAll(applications);

        assertThat(saved).hasSize(2);
        assertThat(saved).allMatch(app -> app.getId() != null);

        assertThat(cardApplicationRepository.count()).isEqualTo(5);
    }

    @Test
    @DisplayName("Should handle null values correctly")
    void testNullValues() {
        CardApplication applicationWithNulls = CardApplication.builder()
                .user(testUser1)
                .cardType(CardType.VIRTUAL.name())
                .comment(null)
                .status(CardRequestStatus.PENDING.name())
                .createdAt(Instant.now())
                .processedAt(null)
                .build();

        CardApplication saved = cardApplicationRepository.save(applicationWithNulls);

        assertThat(saved.getId()).isNotNull();
        assertThat(saved.getComment()).isNull();
        assertThat(saved.getProcessedAt()).isNull();

        Optional<CardApplication> found = cardApplicationRepository.findById(saved.getId());
        assertThat(found).isPresent();
        assertThat(found.get().getComment()).isNull();
        assertThat(found.get().getProcessedAt()).isNull();
    }

    @Test
    @DisplayName("Should maintain referential integrity with User")
    void testReferentialIntegrity() {
        CardApplication application = cardApplicationRepository.findById(pendingApplication.getId()).orElseThrow();

        assertThat(application.getUser()).isNotNull();
        assertThat(application.getUser().getId()).isEqualTo(testUser1.getId());
        assertThat(application.getUser().getFirstName()).isEqualTo("John");
        assertThat(application.getUser().getLastName()).isEqualTo("Doe");
    }
}