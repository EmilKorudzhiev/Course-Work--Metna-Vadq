package dev.emilkorudzhiev.coursework.entities.user;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class PartialUserDto {
    private Long id;
    private String firstName;
    private String lastName;

    public PartialUserDto(User user) {
        this.id = user.getId();
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();

    }

}
