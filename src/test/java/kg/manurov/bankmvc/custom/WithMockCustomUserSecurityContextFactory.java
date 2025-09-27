package kg.manurov.bankmvc.custom;

import kg.manurov.bankmvc.entities.User;
import kg.manurov.bankmvc.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.test.context.support.WithSecurityContextFactory;

import java.util.List;

@RequiredArgsConstructor
public class WithMockCustomUserSecurityContextFactory implements WithSecurityContextFactory<WithMockCustomUser> {

    private final UserRepository userRepository;

    @Override
    public SecurityContext createSecurityContext(WithMockCustomUser customUser) {
        SecurityContext context = SecurityContextHolder.createEmptyContext();

        User user = userRepository.findByPhoneNumber(customUser.phoneNumber())
                .orElseGet(() -> userRepository.save(User.builder()
                        .phoneNumber(customUser.phoneNumber())
                        .firstName(customUser.firstName())
                        .lastName(customUser.lastName())
                        .password("password")
                        .enabled(true)
                        .build()));

        UsernamePasswordAuthenticationToken auth =
                new UsernamePasswordAuthenticationToken(
                        user,
                        "password",
                        List.of(new SimpleGrantedAuthority("ROLE_" + customUser.role()))
                );

        context.setAuthentication(auth);
        return context;
    }
}
