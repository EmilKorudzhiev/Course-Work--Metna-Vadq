package dev.emilkorudzhiev.coursework.entities.user;

import dev.emilkorudzhiev.coursework.aws.s3.S3Buckets;
import dev.emilkorudzhiev.coursework.aws.s3.S3Service;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatch;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatchRepository;
import dev.emilkorudzhiev.coursework.entities.fishcatch.PartialFishCatchDto;
import dev.emilkorudzhiev.coursework.exceptions.EmailTakenException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
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
    private final FishCatchRepository fishCatchRepository;
    private final S3Service s3Service;
    private final S3Buckets s3Buckets;


    public Optional<User> getCurrentUser() {
        return userRepository.findUserByEmail(getCurrentUserEmail());
    }

    public String getCurrentUserEmail() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    public Long getCurrentUserId() {
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
    public void uploadUserProfileImage(MultipartFile file) {
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

    public byte[] getUserProfileImage() {
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

    public String getUserProfileImageUrl() {
        Optional<User> user = getCurrentUser();
        String imageId = user.get().getProfilePicture().toString();

        // TODO make good exceptions
        if(imageId == null) {
            throw new RuntimeException("No picture found for user.");
        }

        return imageId;
    }

    public List<PartialFishCatchDto> getUserLikesById(Long userId, int pageNumber) {
        return fishCatchRepository.findLikedFishCatchesByUserId(userId, PageRequest.of(pageNumber, 2))
                .stream().map(PartialFishCatchDto::new).toList();
    }

    public void likeFishCatch(Long fishCatchId) {
        User user = getCurrentUser().get();
        Optional<FishCatch> fishCatch = fishCatchRepository.findById(fishCatchId);

        if(user.getLikedFishCatches()
                .stream()
                .anyMatch(fc -> fc.getId().equals(fishCatchId))) {
            throw new RuntimeException("Post already liked");
        }

        user.getLikedFishCatches().add(fishCatch.get());
        userRepository.save(user);
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
