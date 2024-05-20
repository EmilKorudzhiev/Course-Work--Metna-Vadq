package dev.emilkorudzhiev.coursework.entities.user;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.UUID;


@Getter
@Setter
@NoArgsConstructor
public class PartialUserDto {
    private Long id;
    private String firstName;
    private String lastName;
    private UUID profilePicture;
    private boolean followingHim;
    private int followersCount;
    private int catchCount;

    public PartialUserDto(User user) {
        this.id = user.getId();
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.profilePicture = user.getProfileImage();
        this.followersCount = user.getFollowers().size();
        this.catchCount = user.getFishCatches().size();
    }

}
