package kg.manurov.bankmvc.custom;

import org.springframework.security.test.context.support.WithSecurityContext;

import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
//https://docs.spring.io/spring-security/reference/servlet/test/method.html

@Retention(RetentionPolicy.RUNTIME)
@WithSecurityContext(factory = WithMockCustomUserSecurityContextFactory.class)
public @interface WithMockCustomUser {
    String phoneNumber() default "+7(700)9999991";
    String firstName() default "Dominic";
    String lastName() default "Dekoko";
    String role() default "USER";
}