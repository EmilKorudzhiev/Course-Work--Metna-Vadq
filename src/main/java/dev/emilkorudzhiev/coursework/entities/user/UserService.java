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
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*;

@Service
@RequiredArgsConstructor
public class UserService {

    @Value("${cloud.aws.s3.max-file-size}")
    private int maxImageSize;

    @Value("${app.constants.users.likes-page-size}")
    private int pageSize;

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



    public Optional<PartialUserDto> getSelf() {
        return getCurrentUser().map(PartialUserDto::new);
    }

    public Optional<PartialUserDto> getUser(Long userId) {
        Optional<User> optionalUser = userRepository.findById(userId);
        return optionalUser.map(PartialUserDto::new);
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
    public void uploadUserProfileImage(MultipartFile image) {
        Optional<User> user = getCurrentUser();
        Long userId = user.get().getId();
        UUID imageId = UUID.randomUUID();

        if(image.isEmpty())
            throw new RuntimeException("No image attached.");
        if(!Set.of("image/png","image/jpeg").contains(image.getContentType()))
            throw new RuntimeException("File format not supported.");
        if (image.getSize() > maxImageSize)
            throw new RuntimeException("Image size is too large.");

        try {
            s3Service.putObject(
                    s3Buckets.getUsers(),
                    "profile-images/%s/%s".formatted(userId, imageId),
                    image.getBytes()
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        userRepository.updateUserByProfilePicture(imageId, userId);
    }

    public byte[] getUserProfileImage() {
        Optional<User> user = getCurrentUser();
        Long userId = user.get().getId();
        UUID imageId = user.get().getProfileImage();

        // TODO make good exceptions
        if(imageId == null) {
            throw new RuntimeException("No picture found for user.");
        }

        return s3Service.getObject(
                s3Buckets.getUsers(),
                "profile-images/%s/%s".formatted(userId, imageId)
        );
    }

    public String getUserProfileImageUrl() {
        Optional<User> user = getCurrentUser();
        String imageId = user.get().getProfileImage().toString();

        // TODO make good exceptions
        if(imageId == null) {
            throw new RuntimeException("No picture found for user.");
        }

        return imageId;
    }

    public Optional<List<PartialFishCatchDto>> getUserLikesById(Long userId, Integer pageNumber) {
        return fishCatchRepository.findLikedFishCatchesByUserId(userId, PageRequest.of(pageNumber, pageSize))
                .map(catches -> catches.stream().map(PartialFishCatchDto::new).toList());
    }

    public void likeFishCatch(Long fishCatchId) {
        User user = getCurrentUser().get();
        Optional<FishCatch> fishCatch = fishCatchRepository.findById(fishCatchId);

        if (fishCatch.isEmpty()) {
            throw new RuntimeException("Fish catch not found.");
        }

        if (user.getLikedFishCatches().contains(fishCatch.get())) {
            user.getLikedFishCatches().remove(fishCatch.get());
            userRepository.save(user);
            return;
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
