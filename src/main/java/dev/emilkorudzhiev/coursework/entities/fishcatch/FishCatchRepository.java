package dev.emilkorudzhiev.coursework.entities.fishcatch;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface FishCatchRepository extends JpaRepository<FishCatch, Long> {

}
