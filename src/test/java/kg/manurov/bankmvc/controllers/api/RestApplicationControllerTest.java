package kg.manurov.bankmvc.controllers.api;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.persistence.EntityManager;
import kg.manurov.bankmvc.custom.WithMockCustomUser;
import kg.manurov.bankmvc.dto.cardApplication.CardApplicationRequest;
import kg.manurov.bankmvc.entities.CardApplication;
import kg.manurov.bankmvc.entities.Role;
import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.enums.CardRequestStatus;
import kg.manurov.bankmvc.enums.CardType;
import kg.manurov.bankmvc.repositories.CardApplicationRepository;
import kg.manurov.bankmvc.repositories.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;

import static org.hamcrest.Matchers.is;
import static org.hamcrest.Matchers.notNullValue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureMockMvc
@Transactional
class RestApplicationControllerTest {

    @Autowired
    private UserRepository userRepository;
    @Autowired
    private CardApplicationRepository cardApplicationRepository;
    @Autowired
    private EntityManager entityManager;
    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private ObjectMapper objectMapper;

    private CardApplicationRequest request;
    private User testUser;
    private Role userRole;
    private CardApplication testApplication;

    @BeforeEach
    void setup(){
        cardApplicationRepository.deleteAll();
        userRole = new Role();
        userRole.setName("USER");
        userRole.setDescription("Default user role");
        entityManager.persist(userRole);
        entityManager.flush();


        testUser = new User();
        testUser.setFirstName("Dominic");
        testUser.setLastName("Dekoko");
        testUser.setPhoneNumber("+7(700)9999991");
        testUser.setPassword("password");
        testUser.setRole(userRole);
        testUser = userRepository.save(testUser);

        request = new CardApplicationRequest();
        request.setCardType(CardType.DEBIT.name());
        request.setComment("please!");
    }

    @Test
    @WithMockCustomUser()
    void createApplicationTest() throws Exception {
        request.setCardType(CardType.DEBIT.name());
        String requestJson = objectMapper.writeValueAsString(request);

        mockMvc.perform(post("/api/v1/card-applications")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.message", is("Card application submitted successfully")))
                .andExpect(jsonPath("$.data", notNullValue()))
                .andExpect(jsonPath("$.data.cardType", is("DEBIT")))
                .andExpect(jsonPath("$.data.status", is("PENDING")));
    }

    @Test
    @WithMockCustomUser
    void createApplicationTest_WithCreditCard() throws Exception {
        request.setCardType(CardType.CREDIT.name());
        String requestJson = objectMapper.writeValueAsString(request);

        mockMvc.perform(post("/api/v1/card-applications")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isOk())
                .andExpect(content().contentTypeCompatibleWith(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.data.cardType", is(request.getCardType())));
    }

    @Test
    void createApplicationTest_Unauthorized() throws Exception {
        CardApplicationRequest request = new CardApplicationRequest();
        request.setCardType(CardType.DEBIT.name());
        String requestJson = objectMapper.writeValueAsString(request);

        mockMvc.perform(post("/api/v1/card-applications")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @WithMockCustomUser
    void createApplicationTest_InvalidRequest() throws Exception {
        CardApplicationRequest request2 = new CardApplicationRequest();
        String requestJson = objectMapper.writeValueAsString(request2);

        mockMvc.perform(post("/api/v1/card-applications")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isBadRequest());
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void approveApplicationTest() throws Exception {
        createApplication();

        mockMvc.perform(post("/api/v1/card-applications/" + testApplication.getId() + "/approve")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.message", is("Application approved successfully!")));
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    void rejectApplicationTest() throws Exception {
        createApplication();

        mockMvc.perform(post("/api/v1/card-applications/" + testApplication.getId() + "/reject")
                        .param("reason", "Invalid documentation")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success", is(true)))
                .andExpect(jsonPath("$.message", is("Application rejected.")));
    }

    private void createApplication(){
        testApplication = new CardApplication();
        testApplication.setCreatedAt(Instant.now());
        testApplication.setUser(testUser);
        testApplication.setStatus(CardRequestStatus.PENDING.name());
        testApplication.setCardType(CardType.VIRTUAL.name());

        testApplication = cardApplicationRepository.save(testApplication);
        entityManager.flush();
    }
}