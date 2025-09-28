package kg.manurov.bankmvc.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.config.annotation.PathMatchConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableScheduling
@EnableJpaAuditing
//https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-config/path-matching.html
public class AppConfig implements WebMvcConfigurer {
    @Value("${app.rest_path}")
    private String restPath;
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    public void configurePathMatch(PathMatchConfigurer configurer) {
        configurer.addPathPrefix(restPath,
                c -> c.isAnnotationPresent(RestController.class)
                     && !isSwaggerController(c));
    }

    private boolean isSwaggerController(Class<?> controllerClass) {
        String packageName = controllerClass.getPackage().getName();

        return packageName.startsWith("org.springdoc")
               || packageName.startsWith("org.springframework.boot.actuate")
               || controllerClass.getSimpleName().contains("OpenApi")
               || controllerClass.getSimpleName().contains("ApiDocs");
    }
}
