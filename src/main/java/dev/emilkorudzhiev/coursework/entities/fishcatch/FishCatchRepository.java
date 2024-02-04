package dev.emilkorudzhiev.coursework.entities.fishcatch;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface FishCatchRepository extends JpaRepository<FishCatch, Long> {

    @Query("SELECT fc FROM FishCatch fc JOIN fc.likes u WHERE u.id = :userId")
    List<FishCatch> findLikedFishCatchesByUserId(Long userId, Pageable pageable);

    @Query("SELECT fc FROM FishCatch fc")
    List<FishCatch> findFishCatchPageable(Pageable pageable);

    @Query(
            value = "SELECT * FROM fish_catch WHERE ST_DWithin(coordinates, ST_GeomFromText('POINT(' || :longitude || ' ' || :latitude || ')', 4326), :distanceMeters);",
            nativeQuery = true
    )
    Optional<List<FishCatch>> findFishCatchesInRadius(@Param("latitude") Double latitude,@Param("longitude") Double longitude, @Param("distanceMeters") Long distanceMeters);
}
