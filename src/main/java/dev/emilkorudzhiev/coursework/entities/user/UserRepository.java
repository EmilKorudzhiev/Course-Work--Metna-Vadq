package dev.emilkorudzhiev.coursework.entities.user;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {

    @Query("SELECT u FROM User u WHERE u.email = ?1")
    Optional<User> findUserByEmail(String email);

    @Modifying
    @Query("UPDATE User u SET u.profilePicture = ?1 WHERE u.id = ?2")
    int updateUserByProfilePicture(UUID profilePictureId, Long userId);

}
