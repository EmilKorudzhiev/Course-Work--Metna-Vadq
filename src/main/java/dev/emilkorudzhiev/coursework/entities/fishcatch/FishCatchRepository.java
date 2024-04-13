package dev.emilkorudzhiev.coursework.entities.fishcatch;

import io.micrometer.observation.ObservationFilter;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;

@Repository
public interface FishCatchRepository extends JpaRepository<FishCatch, Long> {

    @Query("SELECT fc FROM FishCatch fc WHERE fc.user.id = :userId")
    Optional<List<FishCatch>> findFishCatchesByUserId(Long userId, PageRequest of);

    @Query("SELECT fc FROM FishCatch fc JOIN fc.likes u WHERE u.id = :userId")
    Optional<List<FishCatch>> findLikedFishCatchesByUserId(Long userId, Pageable pageable);

    @Query("SELECT fc FROM FishCatch fc")
    Optional<List<FishCatch>> findFishCatchPageable(Pageable pageable);

    @Query("SELECT DISTINCT fc FROM User u " +
            "JOIN u.likedFishCatches ulfc " +
            "JOIN ulfc.likes lfc " +
            "JOIN lfc.likedFishCatches fc " +
            "WHERE u.id = :userId " +
            "AND fc NOT IN (SELECT ulfc FROM User u " +
            "JOIN u.likedFishCatches ulfc " +
            "WHERE u.id = :userId)")
    Optional<List<FishCatch>> findFishCatchPageableFeed(PageRequest of);

    @Query(
            value = "SELECT * FROM fish_catch WHERE ST_DWithin(coordinates, ST_GeomFromText('POINT(' || :longitude || ' ' || :latitude || ')', 4326), :distanceMeters);",
            nativeQuery = true
    )
    Optional<List<FishCatch>> findFishCatchesInRadius(@Param("latitude") Double latitude,@Param("longitude") Double longitude, @Param("distanceMeters") Long distanceMeters);
}
