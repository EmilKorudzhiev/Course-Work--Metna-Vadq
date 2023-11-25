package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.aws.s3.S3Buckets;
import dev.emilkorudzhiev.coursework.aws.s3.S3Service;
import dev.emilkorudzhiev.coursework.exceptions.EmailTakenException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final S3Service s3Service;
    private final S3Buckets s3Buckets;


    private Optional<User> getCurrentUser() {
        return userRepository.findUserByEmail(getCurrentUserEmail());
    }

    private String getCurrentUserEmail() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    private Long getCurrentUserId() {
        Optional<User> userOptional = userRepository.findUserByEmail(getCurrentUserEmail());
        return userOptional.get().getId();
    }



    public Optional<FullUserDto> getSelf() {
        return getCurrentUser().map(FullUserDto::new);
    }

    public Optional<FullUserDto> getUser(Long userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        return optionalUser.map(FullUserDto::new);
    }

    public List<FullUserDto> getUsers() {
        List<User> userList = userRepository.findAll();
        return userList.stream().map(FullUserDto::new).toList();
    }

    public boolean deleteSelf() {
        Optional<User> user = getCurrentUser();
        if (user.isPresent()) {
            userRepository.deleteById(user.get().getId());
            return true;
        } else {
            return false;
        }
    }


    public void uploadUserProfilePicture(MultipartFile file) {
        Optional<User> user = getCurrentUser();
        String userId = user.get().getId().toString();
        String imageId = UUID.randomUUID().toString();
        try {
            s3Service.putObject(
                  s3Buckets.getUsers(),
                    "profile-images/%s/%s".formatted(userId, imageId),
                    file.getBytes()
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        //save to DB
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
