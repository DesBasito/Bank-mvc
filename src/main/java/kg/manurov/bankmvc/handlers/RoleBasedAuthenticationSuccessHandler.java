package kg.manurov.bankmvc.handlers;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import java.io.IOException;
import java.util.Collection;

@Slf4j
public class RoleBasedAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    private static final String USER_TARGET_URL = "/profile";
    private static final String ADMIN_TARGET_URL = "/cards/all";

    @Override
    public void onAuthenticationSuccess(
            HttpServletRequest request,
            HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {

        String targetUrl = determineTargetUrl(authentication);

        log.info("User {} successfully authenticated, redirecting to: {}",
                authentication.getName(), targetUrl);

        if (response.isCommitted()) {
            log.warn("Response has already been committed. Unable to redirect to {}", targetUrl);
            return;
        }

        response.sendRedirect(targetUrl);
    }

    protected String determineTargetUrl(Authentication authentication) {
        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();

        for (GrantedAuthority authority : authorities) {
            String role = authority.getAuthority();
            log.debug("Checking authority: {}", role);

            switch (role) {
                case "ROLE_ADMIN":
                case "ADMIN":
                    log.info("Redirecting admin user to: {}", ADMIN_TARGET_URL);
                    return ADMIN_TARGET_URL;

                case "ROLE_USER":
                case "USER":
                    log.info("Redirecting regular user to: {}", USER_TARGET_URL);
                    return USER_TARGET_URL;

                default:
                    log.debug("Unknown role: {}, will check next authority", role);
                    break;
            }
        }

        log.error("CRITICAL: No valid role found for user: {}. Authorities: {}",
                authentication.getName(), authorities);
        throw new IllegalStateException("User has no valid role assigned: " + authentication.getName());
    }
}