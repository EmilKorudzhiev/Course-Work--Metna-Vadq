package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;


import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.OffsetDateTime;
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

    public void addNewFishCatch(FishCatchRequest request){
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        Long userId = userRepository.findUserByEmail(username).get().getId();
        FishCatch fishCatch = FishCatch
                .builder()
                .latitude(request.getLatitude())
                .longitude(request.getLongitude())
                .text(request.getText())
                .date(OffsetDateTime.now().toZonedDateTime().toOffsetDateTime())
                .userId(userId)
                .build();
        fishCatchRepository.save(fishCatch);
    }

}
