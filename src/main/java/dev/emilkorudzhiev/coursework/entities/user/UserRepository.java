package dev.emilkorudzhiev.coursework.entities.user;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    @Query("SELECT u FROM User u WHERE u.email = :email")
    Optional<User> findUserByEmail(String email);

    @Modifying
    @Query("UPDATE User u SET u.profileImage = :profilePictureId WHERE u.id = :userId")
    void updateUserByProfilePicture(UUID profilePictureId, Long userId);

    @Query("SELECT u.followers FROM User u WHERE u.id = :userId")
    Optional<List<User>> findUserFollowersByUserId(Long userId, PageRequest pageRequest);

    @Query("SELECT u.following FROM User u WHERE u.id = :userId")
    Optional<List<User>> findUserFollowingByUserId(Long userId, PageRequest pageRequest);
}
