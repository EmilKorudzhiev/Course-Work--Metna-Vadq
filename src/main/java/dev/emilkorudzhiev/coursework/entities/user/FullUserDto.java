package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.enums.Role;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatch;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class FullUserDto {

    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private Role role;
    private List<FishCatch> fishCatches;


    public FullUserDto(User user) {
        this.id = user.getId();
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.email = user.getEmail();
        this.role = user.getRole();
        this.fishCatches = user.getFishCatches();
    }

}
