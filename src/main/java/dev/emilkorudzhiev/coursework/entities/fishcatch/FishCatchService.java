package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.locationtech.jts.geom.Point;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;


import java.sql.Timestamp;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class FishCatchService {


    private final FishCatchRepository fishCatchRepository;
    private final UserRepository userRepository;

    public Optional<FishCatchDto> getFishClassById(Long fishCatchId) {
        return fishCatchRepository.findById(fishCatchId).map(FishCatchDto::new);
    }

    public void postFishCatch(FishCatchRequest request){
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findUserByEmail(username).get();
        FishCatch fishCatch = FishCatch
                .builder()
                .coordinates(new GeometryFactory().createPoint(new Coordinate(request.getLatitude(), request.getLongitude())))
                .text(request.getText())
                .date(Timestamp.from(Instant.now()))
                .user(user)
                .build();
        fishCatchRepository.save(fishCatch);
    }

    public boolean deleteFishCatch(Long fishCatchId) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Optional<User> user = userRepository.findUserByEmail(username);
        Optional<FishCatch> fishCatch = fishCatchRepository.findById(fishCatchId);
        if (!user.get().getId().equals(fishCatch.get().getUser().getId()) || fishCatchId.describeConstable().isEmpty()) {
            return false;
        }else {
            fishCatchRepository.deleteById(fishCatchId);
            return true;
        }
    }
}
