package kg.manurov.bankmvc.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
//https://attractor-school.com/courses/java/
public class SwagConfig {
    @Value("${server.port:8080}")
    private String serverPort;

    @Value("${app.rest_path}")
    private String contextPath;

    @Bean
    public OpenAPI customOpenAPI() {
        return new OpenAPI()
                .info(getApiInfo())
                .servers(getServers())
                .addSecurityItem(new SecurityRequirement().addList("Basic Authentication"))
                .components(new Components()
                        .addSecuritySchemes("Basic Authentication", createBasicAuthScheme()));
    }

    private Info getApiInfo() {
        return new Info()
                .title("Bank Card Management System API")
                .description("""
                        REST API for bank card management with features:
                        
                        - User authentication and authorization
                        - Card management (creation, viewing, blocking...)
                        - Transfers between cards
                        - System administration
                        
                        **User Roles:**
                        - USER: basic operations with own cards
                        - ADMIN: full system access
                        
                        **Security:**
                        - Basic Authentication (username/password)
                        - Card number encryption
                        - Sensitive data masking
                        """)
                .version("1.0.0")
                .contact(new Contact()
                        .name("Abu")
                        .email("out1of1mind1exception@gmail.com")
                        .url("https://github.com/DesBasito"));
    }

    private List<Server> getServers() {
        return List.of(
                new Server()
                        .url("http://localhost:" + this.serverPort + this.contextPath)
                        .description("Local development server"));
    }

    private SecurityScheme createBasicAuthScheme() {
        return new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("basic")
                .description("Basic Authentication");
    }
}
