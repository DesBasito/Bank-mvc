package kg.manurov.bankmvc.config;

import kg.manurov.bankmvc.handlers.RoleBasedAuthenticationSuccessHandler;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
//https://attractor-school.com/courses/java/
//Epam
public class SecurityConfig {
    @Bean
    public AuthenticationSuccessHandler authenticationSuccessHandler() {
        return new RoleBasedAuthenticationSuccessHandler();
    }
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.ALWAYS))
                .httpBasic(Customizer.withDefaults())
                .formLogin(form -> form
                        .loginPage("/auth/login")
                        .loginProcessingUrl("/login")
                        .successHandler(authenticationSuccessHandler())
                        .failureUrl("/login?error=true")
                        .permitAll())
                .logout(logout -> logout
                        .logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
                        .permitAll())
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(authorize -> authorize
                        // Public endpoints - no authentication required
                        .requestMatchers(HttpMethod.GET, "/auth/register").permitAll()
                        .requestMatchers(HttpMethod.POST, "/auth/register").permitAll()
                        .requestMatchers("/swagger-ui/**", "/swagger-resources/*", "/v3/api-docs/**").permitAll()
                        .requestMatchers("/css/**", "/js/**", "/images/**", "/favicon.ico").permitAll()
                        .requestMatchers("/error").permitAll()


                        // Card Application endpoints
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-applications").hasAuthority("ROLE_USER")
                        .requestMatchers(HttpMethod.PUT, "/api/v1/card-applications/*/cancel").hasAuthority("ROLE_USER")
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-applications/*/approve").hasAuthority("ROLE_ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-applications/*/reject").hasAuthority("ROLE_ADMIN")

                        // Card endpoints
                        .requestMatchers(HttpMethod.PUT, "/api/v1/cards/*/toggle").hasAuthority("ROLE_ADMIN")

                        // Card Block Request endpoints
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-block-requests").hasAuthority("ROLE_USER")
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-block-requests/*/approve").hasAuthority("ROLE_ADMIN")
                        .requestMatchers(HttpMethod.POST, "/api/v1/card-block-requests/*/reject").hasAuthority("ROLE_ADMIN")

                        // Transaction endpoints
                        .requestMatchers(HttpMethod.POST, "/api/v1/transactions/transfer").hasAuthority("ROLE_USER")
                        .requestMatchers(HttpMethod.PUT, "/api/v1/transactions/*/refund").hasAuthority("ROLE_ADMIN")

                        // User Management endpoints (Admin only)
                        .requestMatchers(HttpMethod.POST, "/api/v1/users/*/toggle-status").hasAuthority("ROLE_ADMIN")
                        .requestMatchers(HttpMethod.DELETE, "/api/v1/users/*").hasAuthority("ROLE_ADMIN")

                        // User web pages - only USER role
                        .requestMatchers("/card-applications/my").hasAuthority("ROLE_USER")
                        .requestMatchers("/transactions/transfer").hasAuthority("ROLE_USER")
                        .requestMatchers("/transactions/my").hasAuthority("ROLE_USER")
                        .requestMatchers("/profile").hasAuthority("ROLE_USER")
                        .requestMatchers("/profile/**").hasAuthority("ROLE_USER")

                        // Admin-only web pages
                        .requestMatchers("/card-applications/admin/**").hasAuthority("ROLE_ADMIN")
                        .requestMatchers("/transactions/all").hasAuthority("ROLE_ADMIN")
                        .requestMatchers("/admin/**").hasAuthority("ROLE_ADMIN")
                        .requestMatchers("/users").hasAuthority("ROLE_ADMIN")
                        .requestMatchers("/users/**").hasAuthority("ROLE_ADMIN")
                        .requestMatchers("/cards/all").hasAuthority("ROLE_ADMIN")

                        // Cards with custom authorization (owner or admin)
                        .requestMatchers("/cards/*").authenticated()
                        .requestMatchers("/users/1").denyAll()
                        .anyRequest().authenticated());
        return http.build();
    }
}
