package dev.emilkorudzhiev.coursework.user;

import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping(path = "api/v1/user")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class UserController {

    private final UserService userService;

    @GetMapping(path = "/self")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<User> getSelf() {
        Optional<User> user = userService.getSelf();
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping(path = "{userId}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<User> getUser(@PathVariable("userId") Long userId) {
        Optional<User> user = userService.getUser(userId);
        return user.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<User>> getUsers() {
        return ResponseEntity.ok(userService.getUsers());
    }

//todo fix this
    @DeleteMapping(path = "{userId}")
    @PreAuthorize("hasAnyAuthority('admin:delete', 'user:delete')")
    public ResponseEntity<Void> deleteUser(@PathVariable("userId") Long userId) {
        boolean deleted = userService.deleteUser(userId);
        return deleted ?
                ResponseEntity.noContent().build()
                : ResponseEntity.notFound().build();
    }

//todo fix this
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
