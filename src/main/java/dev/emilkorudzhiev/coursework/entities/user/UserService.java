package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.exceptions.EmailTakenException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public Optional<UserDto> getSelf() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Optional<User> userOptional = userRepository.findUserByEmail(username);
        return userOptional.map(UserDto::new);
    }

    public Optional<UserDto> getUser(Long userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        return optionalUser.map(UserDto::new);
    }

    public List<UserDto> getUsers() {
        List<User> userList = userRepository.findAll();
        return userList.stream().map(UserDto::new).toList();
    }

    public boolean deleteSelf() {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Optional<User> userOptional = userRepository.findUserByEmail(username);
        if (userOptional.isPresent()) {
            userRepository.deleteById(userOptional.get().getId());
            return true;
        } else {
            return false;
        }
    }





    public boolean deleteUser(Long userId) {
        Optional<User> userOptional = userRepository.findById(userId);
        if (userOptional.isPresent()) {
            userRepository.deleteById(userId);
            return true;
        } else {
            return false;
        }
    }

    @Transactional
    public boolean updateUser(Long userId,
                           String firstName,
                           String lastName,
                           String email) {
        boolean updated = false;

        Optional<User> userOptional = userRepository.findById(userId);

        User user;
        if (userOptional.isPresent()) {
            user = userOptional.get();
        } else {
            return updated;
        }

        if (email != null &&
                !email.isEmpty() &&
                !Objects.equals(user.getEmail(), email)) {
            userOptional = userRepository.findUserByEmail(email);
            if (userOptional.isPresent()) {
                throw new EmailTakenException("email taken");
            }
            user.setEmail(email);
            updated = true;
        }

        if (firstName != null &&
                !firstName.isEmpty() &&
                !Objects.equals(user.getFirstName(), firstName)) {
            user.setFirstName(firstName);
            updated = true;
        }

        if (lastName != null &&
                !lastName.isEmpty() &&
                !Objects.equals(user.getLastName(), lastName)) {
            user.setLastName(lastName);
            updated = true;
        }

        return updated;
    }
}
