package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatch;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LocationRepository extends JpaRepository<Location,Long> {

    @Query("SELECT l FROM Location l")
    Optional<List<Location>> findLocationPageable(Pageable pageable);

    @Query(
            value = "SELECT * FROM location WHERE ST_DWithin(coordinates, ST_GeomFromText('POINT(' || :longitude || ' ' || :latitude || ')', 4326), :distanceMeters);",
            nativeQuery = true
    )
    Optional<List<Location>> findLocationsInRadius(Double latitude, Double longitude, Long distanceMeters);

    @Query("SELECT l FROM Location l WHERE l.user.id = :userId")
    Optional<List<Location>> findLocationsByUserId(Long userId, PageRequest of);
}
