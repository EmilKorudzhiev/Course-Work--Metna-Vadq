package dev.emilkorudzhiev.coursework.user;

import dev.emilkorudzhiev.coursework.comment.Comment;
import dev.emilkorudzhiev.coursework.fishcatch.FishCatch;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;
import java.util.Optional;

@Configuration
public class UserConfig {

    @Bean
    CommandLineRunner commandLineRunner(
            UserRepository userRepository
    ){
        return args -> {

            Comment comment1 = new Comment(
                    "suglasen",
                    LocalDate.of(2001, Month.DECEMBER, 31)
            );

            FishCatch fishCatch1 = new FishCatch(
                    LocalDate.of(2000, Month.DECEMBER, 31),
                    1.0F,
                    0.05F,
                    "vij kva qka riba",
                    List.of(comment1)
            );
            FishCatch fishCatch2 = new FishCatch(
                    LocalDate.of(2550, Month.JANUARY, 18),
                    1.0F,
                    0.05F,
                    "vij kva qka riba bratochka"
            );

            User ivan = new User(
                    "Ivan",
                    "Ivanov",
                    "Ivan@gmail.com"
            );

            User gosho = new User(
                    "Gosho",
                    "Goshev",
                    "Gosho@gmail.com",
                    List.of(fishCatch1,fishCatch2)
            );

            userRepository.saveAll(
                    List.of(ivan,gosho)
            );


        };
    }
}
