package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import dev.emilkorudzhiev.coursework.entities.user.UserService;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
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
    private final UserService userService;

    public Optional<FullFishCatchDto> getFishCatchById(Long fishCatchId) {
        return fishCatchRepository.findById(fishCatchId).map(FullFishCatchDto::new);
    }

    public Optional<List<FullFishCatchDto>> getFishCatchesInRadius(SearchRadiusRequest request) {
        Optional<List<FishCatch>> fishCatches =  fishCatchRepository.findFishCatchesInRadius(request.getLatitude(), request.getLongitude(), request.getDistance());
        return fishCatches.map(catches -> catches.stream().map(FullFishCatchDto::new).collect(Collectors.toList()));
    }

    public void postFishCatch(FishCatchRequest request){
        User user = userService.getCurrentUser().get();
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
        User user = userService.getCurrentUser().get();
        Optional<FishCatch> fishCatch = fishCatchRepository.findById(fishCatchId);
        if (!user.getId().equals(fishCatch.get().getUser().getId())) {
            return false;
        }else {
            fishCatchRepository.deleteById(fishCatchId);
            return true;
        }
    }

}
