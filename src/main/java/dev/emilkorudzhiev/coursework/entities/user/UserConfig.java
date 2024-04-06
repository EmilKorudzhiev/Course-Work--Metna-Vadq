package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.auth.AuthenticationService;
import dev.emilkorudzhiev.coursework.auth.requests.RegisterRequest;
import dev.emilkorudzhiev.coursework.enums.Role;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class UserConfig {

    @Bean
    public CommandLineRunner commandLineRunner(
            AuthenticationService authenticationService
    ){
        return args -> {

            var admin = RegisterRequest.builder()
                    .firstName("Admin")
                    .lastName("Admin")
                    .email("Admin@abv.bg")
                    .password("1234")
                    .role(Role.ADMIN)
                    .build();
            var authAdmin = authenticationService.registerWithRole(admin);
            System.out.println("Admin access token: " + authAdmin.getAccessToken());
            System.out.println("Admin refresh token: " + authAdmin.getRefreshToken());


            var user = RegisterRequest.builder()
                    .firstName("User")
                    .lastName("User")
                    .email("User@abv.bg")
                    .password("1234")
                    .role(Role.USER)
                    .build();
            var authUser = authenticationService.registerWithRole(user);
            System.out.println("User access token: " + authUser.getAccessToken());
            System.out.println("User refresh token: " + authUser.getRefreshToken());

        };
    }
}
