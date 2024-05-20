package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.entities.fishcatch.PartialFishCatchDto;
import jakarta.servlet.http.Part;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(path = "api/v1/user")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class UserController {

    private final UserService userService;

    @GetMapping()
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<PartialUserDto> getUser(
            @RequestParam(value = "userId", required = false) Long userId
    ) {
        Optional<PartialUserDto> user;
        if (userId == null) user = userService.getSelf();
        else user = userService.getUser(userId);
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping(path = "all")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<FullUserDto>> getUsers() {
        return ResponseEntity.ok(userService.getUsers());
    }

    @DeleteMapping
    @PreAuthorize("hasAnyAuthority('admin:delete', 'user:delete')")
    public ResponseEntity<Void> deleteSelf() {
        boolean deleted = userService.deleteSelf();
        return deleted ?
                ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

    @PostMapping(
            value = "profile-image",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> uploadUserProfileImage(
            @RequestParam("file")MultipartFile file
            ) {
        userService.uploadUserProfileImage(file);
        return ResponseEntity.ok().build();
    }

    @GetMapping("profile-image")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<byte[]> getUserProfileImage() {
        byte[] image = userService.getUserProfileImage();
        return ResponseEntity.ok(image);
    }

    @GetMapping("profile-image/url")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<String> getUserProfileImageUrl() {
        String image = userService.getUserProfileImageUrl();
        return ResponseEntity.ok(image);
    }

    @GetMapping("like/fish-catch")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<PartialFishCatchDto>> getUserLikesById(
            @RequestParam(name = "userId") Long userId,
            @RequestParam(name = "page", defaultValue = "0") Integer pageNumber
    ) {
        Optional<List<PartialFishCatchDto>> list = userService.getUserLikesById(userId, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("like/fish-catch/{fishCatchId}")
    @PreAuthorize("hasAnyAuthority('admin:update', 'user:update')")
    public ResponseEntity<Void> userLikeFishCatch(
            @PathVariable("fishCatchId") Long fishCatchId
    ) {
        userService.likeFishCatch(fishCatchId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("following")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<PartialUserDto>> getUserFollowing(
            @RequestParam(name = "userId", required = false) Long userId,
            @RequestParam(name = "page", defaultValue = "0") Integer pageNumber
    ) {
        Optional<List<PartialUserDto>> list = userService.getUserFollowing(userId, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("followers")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<PartialUserDto>> getUserFollowers(
            @RequestParam(name = "userId", required = false) Long userId,
            @RequestParam(name = "page", defaultValue = "0") Integer pageNumber
    ) {
        Optional<List<PartialUserDto>> list = userService.getUserFollowers(userId, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PutMapping("follow/{userId}")
    @PreAuthorize("hasAnyAuthority('admin:update', 'user:update')")
    public ResponseEntity<Void> userFollow(
            @PathVariable("userId") Long userId
    ) {
        userService.followUser(userId);
        return ResponseEntity.noContent().build();
    }

//todo fix this and make admin can delete anyone
    @DeleteMapping(path = "{userId}")
    @PreAuthorize("hasAnyAuthority('admin:delete', 'user:delete')")
    public ResponseEntity<Void> deleteUser(@PathVariable("userId") Long userId) {
        boolean deleted = userService.deleteUser(userId);
        return deleted ?
                ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

//todo fix this edit self
    @PutMapping(path = "{userId}")
    @PreAuthorize("hasAnyAuthority('admin:update, user:update')")
    public ResponseEntity<Void> updateUser(
            @PathVariable("userId") Long userId,
            @RequestParam(required = false) String firstName,
            @RequestParam(required = false) String lastName,
            @RequestParam(required = false) String email) {
        boolean updated = userService.updateUser(userId, firstName, lastName, email);
        return updated ?
                ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }
}
