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
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class FishCatchService {


    private final FishCatchRepository fishCatchRepository;
    private final UserRepository userRepository;

    public Optional<FishCatchDto> getFishCatchById(Long fishCatchId) {
        return fishCatchRepository.findById(fishCatchId).map(FishCatchDto::new);
    }

    public Optional<List<FishCatchDto>> getFishCatchesInRadius(SearchRadiusRequest request) {
        Optional<List<FishCatch>> fishCatches =  fishCatchRepository.findFishCatchesInRadius(request.getLatitude(), request.getLongitude(), request.getDistance());
        return fishCatches.map(catches -> catches.stream().map(FishCatchDto::new).collect(Collectors.toList()));
    }

    public void postFishCatch(FishCatchRequest request){
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findUserByEmail(username).get();
        FishCatch fishCatch = FishCatch
                .builder()
                .coordinates(new GeometryFactory().createPoint(new Coordinate(request.getLongitude(), request.getLatitude())))
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
