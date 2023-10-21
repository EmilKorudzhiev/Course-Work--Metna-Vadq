package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.auth.AuthenticationService;
import dev.emilkorudzhiev.coursework.auth.RegisterRequest;
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
            System.out.println("Admin token: " + authenticationService.registerWithRole(admin).getToken());


            var user = RegisterRequest.builder()
                    .firstName("User")
                    .lastName("User")
                    .email("User@abv.bg")
                    .password("1234")
                    .role(Role.USER)
                    .build();
            System.out.println("User token: " + authenticationService.registerWithRole(user).getToken());

        };
    }
}
