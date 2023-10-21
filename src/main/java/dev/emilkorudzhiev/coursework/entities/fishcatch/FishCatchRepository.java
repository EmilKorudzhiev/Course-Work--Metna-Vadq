package dev.emilkorudzhiev.coursework.entities.fishcatch;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FishCatchRepository extends JpaRepository<FishCatch, Long> {

}
