package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.entities.fishcatch.PartialFishCatchDto;
import dev.emilkorudzhiev.coursework.enums.Role;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
public class FullUserDto {

    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private UUID profilePicture;
    private Role role;
    private List<PartialFishCatchDto> fishCatches;
    private int followersCount;
    private boolean followingHim;
    private int catchCount;

    public FullUserDto(User user) {
        this.id = user.getId();
        this.firstName = user.getFirstName();
        this.lastName = user.getLastName();
        this.email = user.getEmail();
        this.profilePicture = user.getProfileImage();
        this.role = user.getRole();
        this.fishCatches = user.getFishCatches().stream().map(PartialFishCatchDto::new).toList();
        this.followersCount = user.getFollowers().size();
        this.catchCount = user.getFishCatches().size();
    }

}
