package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.aws.s3.S3Buckets;
import dev.emilkorudzhiev.coursework.aws.s3.S3Service;
import dev.emilkorudzhiev.coursework.exceptions.EmailTakenException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
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

    @Value("${cloud.aws.s3.max-file-size}")
    private int maxImageSize;

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

    @Transactional
    public void uploadUserProfilePicture(MultipartFile file) {
        Optional<User> user = getCurrentUser();
        Long userId = user.get().getId();
        UUID imageId = UUID.randomUUID();
        // TODO check file extension
        if (file.getSize() < maxImageSize) {
            try {
                s3Service.putObject(
                        s3Buckets.getUsers(),
                        "profile-images/%s/%s".formatted(userId, imageId),
                        file.getBytes()
                );
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            userRepository.updateUserByProfilePicture(imageId, userId);
        } else {
            throw new RuntimeException("Image size is too large.");
        }
    }

    public byte[] getUserProfilePicture() {
        Optional<User> user = getCurrentUser();
        Long userId = user.get().getId();
        UUID imageId = user.get().getProfilePicture();

        // TODO make good exceptions
        if(imageId == null) {
            throw new RuntimeException("No picture found for user.");
        }

        byte[] picture = s3Service.getObject(
                s3Buckets.getUsers(),
                "profile-images/%s/%s".formatted(userId, imageId)
        );
        return picture;
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
