package kg.manurov.bankmvc.controllers.mvc;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureMockMvc
//https://www.baeldung.com/spring-boot-testing
class ApplicationControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @WithMockUser("ADMIN")
    void testCardApplicationAdminPage() throws Exception {
        mockMvc.perform(get("/card-applications/admin/all"))
                .andExpect(status().isOk())
                .andExpect(view().name("admin/adminCardApplication"))
                .andExpect(model().attributeExists("applications"))
                .andExpect(model().attributeExists("blockRequests"));
    }

    @Test
    @WithMockUser("USER")
    void testCardApplicationUserPage() throws Exception {
        mockMvc.perform(get("/card-applications/my"))
                .andExpect(status().isOk())
                .andExpect(view().name("user/userApplicationPage"))
                .andExpect(model().attributeExists("applications"))
                .andExpect(model().attributeExists("blockRequests"))
                .andExpect(model().attributeDoesNotExist("status"));
    }
}
