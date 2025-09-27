package kg.manurov.bankmvc.components;

import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.util.AuthenticatedUserUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.AuditorAware;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.stereotype.Component;

import java.util.Optional;

@Component
@RequiredArgsConstructor
//https://www.baeldung.com/database-auditing-jpa
public class UserAuditorAwareImpl implements AuditorAware<User> {
    private final AuthenticatedUserUtil userUtil;

    @Override
    public Optional<User> getCurrentAuditor() {
        try {
            return Optional.of(userUtil.getCurrentUser());
        } catch (AccessDeniedException e) {
            return Optional.empty();
        }
    }
}
