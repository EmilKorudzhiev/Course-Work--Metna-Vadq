package dev.emilkorudzhiev.coursework.entities.user;

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

    @GetMapping
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FullUserDto> getSelf() {
        Optional<FullUserDto> user = userService.getSelf();
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping(path = "{userId}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FullUserDto> getUser(@PathVariable("userId") Long userId) {
        Optional<FullUserDto> user = userService.getUser(userId);
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping(path = "/all")
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
            value = "/profile-image",
            consumes = MediaType.MULTIPART_FORM_DATA_VALUE
    )
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> uploadUserProfileImage(
            @RequestParam("file")MultipartFile file
            ) {
        userService.uploadUserProfilePicture(file);
        return ResponseEntity.ok().build();
    }

    @GetMapping("/profile-image")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<byte[]> getUserProfileImage() {
        byte[] image = userService.getUserProfilePicture();
        return ResponseEntity.ok(image);
    }





//todo fix this make admin only
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
