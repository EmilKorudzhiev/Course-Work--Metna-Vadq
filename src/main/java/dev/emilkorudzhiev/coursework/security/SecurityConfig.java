package dev.emilkorudzhiev.coursework.security;

import dev.emilkorudzhiev.coursework.enums.Role;
import dev.emilkorudzhiev.coursework.exceptions.ExceptionHandlerFilter;
import jakarta.servlet.Filter;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.ExceptionTranslationFilter;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import static dev.emilkorudzhiev.coursework.enums.Permission.*;
import static dev.emilkorudzhiev.coursework.enums.Role.ADMIN;
import static dev.emilkorudzhiev.coursework.enums.Role.USER;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthFilter;
    private final ExceptionHandlerFilter exceptionHandlerFilter;
    private final AuthenticationProvider authenticationProvider;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {

        http.csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(request -> request.requestMatchers("/api/v1/auth/**", "/api/v1/admin/login").permitAll()

//                                .requestMatchers("/api/v1/admin/**").hasAnyRole(ADMIN.name())
//                                .requestMatchers(HttpMethod.GET, "/api/v1/admin/**").hasAnyAuthority(ADMIN_READ.name())
//                                .requestMatchers(HttpMethod.POST, "/api/v1/admin/**").hasAnyAuthority(ADMIN_CREATE.name())
//                                .requestMatchers(HttpMethod.PUT, "/api/v1/admin/**").hasAnyAuthority(ADMIN_UPDATE.name())
//                                .requestMatchers(HttpMethod.DELETE, "/api/v1/admin/**").hasAnyAuthority(ADMIN_DELETE.name())

//                                .requestMatchers("/api/v1/user/**").hasAnyRole(ADMIN.name() ,USER.name())
//                                .requestMatchers(HttpMethod.GET, "/api/v1/user/**").hasAnyAuthority(ADMIN_READ.name(), USER_READ.name())
//                                .requestMatchers(HttpMethod.POST, "/api/v1/user/**").hasAnyAuthority(ADMIN_CREATE.name(), USER_CREATE.name())
//                                .requestMatchers(HttpMethod.PUT, "/api/v1/user/**").hasAnyAuthority(ADMIN_UPDATE.name(), USER_UPDATE.name())
//                                .requestMatchers(HttpMethod.DELETE, "/api/v1/user/**").hasAnyAuthority(ADMIN_DELETE.name(), USER_DELETE.name())

                        .anyRequest()
                        .authenticated())
                .sessionManagement(manager -> manager.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authenticationProvider(authenticationProvider)
                .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(exceptionHandlerFilter, jwtAuthFilter.getClass());



        return http.build();

    }
}
