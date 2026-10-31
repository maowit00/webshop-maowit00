package de.hsesslingen.webshopbackend.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
@Profile("dev")
public class DevJWTSecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity)
            throws Exception {
        return httpSecurity
                .authorizeHttpRequests(auth -> auth
                        .anyRequest().permitAll())
                .csrf((csrf) -> csrf.disable())
                .build();
    }
}
