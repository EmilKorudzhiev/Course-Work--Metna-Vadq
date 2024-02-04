package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.aws.s3.S3Buckets;
import dev.emilkorudzhiev.coursework.aws.s3.S3Service;
import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import dev.emilkorudzhiev.coursework.entities.user.UserService;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;


import java.io.IOException;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class FishCatchService {

    @Value("${cloud.aws.s3.max-file-size}")
    private int maxImageSize;

    private final FishCatchRepository fishCatchRepository;
    private final UserRepository userRepository;
    private final UserService userService;
    private final S3Service s3Service;
    private final S3Buckets s3Buckets;

    // TODO : make recommendation algorithm
    public Optional<List<FullFishCatchDto>> getFishCatches(Integer pageSize, Integer pageNumber) {
        return Optional.of(fishCatchRepository
                .findFishCatchPageable(PageRequest.of(pageNumber, pageSize))
                .stream().map(FullFishCatchDto::new).toList());
    }

    public Optional<FullFishCatchDto> getFishCatchById(Long fishCatchId) {
        return fishCatchRepository.findById(fishCatchId).map(FullFishCatchDto::new);
    }

    // TODO : make date search too
    public Optional<List<FullFishCatchDto>> getFishCatchesInRadius(SearchRadiusRequest request) {
        Optional<List<FishCatch>> fishCatches =  fishCatchRepository.findFishCatchesInRadius(request.getLatitude(), request.getLongitude(), request.getDistance());
        return fishCatches.map(catches -> catches.stream().map(FullFishCatchDto::new).toList());
    }

    public void postFishCatch(FishCatchRequest request, MultipartFile image){
        User user = userService.getCurrentUser().get();
        UUID imageId = UUID.randomUUID();

        if(image.isEmpty())
            throw new RuntimeException("No file attached.");
        if(!Set.of("image/png","image/jpeg").contains(image.getContentType()))
            throw new RuntimeException("File format not supported.");
        if (image.getSize() > maxImageSize)
            throw new RuntimeException("Image size is too large.");

        try {
            FishCatch fishCatch = FishCatch
                    .builder()
                    .coordinates(new GeometryFactory().createPoint(new Coordinate(request.getLongitude(), request.getLatitude())))
                    .text(request.getText())
                    .fishCatchImage(imageId)
                    .date(Timestamp.from(Instant.now()))
                    .user(user)
                    .build();
            Long fishCatchId = fishCatchRepository.save(fishCatch).getId();
            s3Service.putObject(
                    s3Buckets.getFishCatches(),
                    "fish-catches/%s/%s".formatted(fishCatchId, imageId),
                    image.getBytes()
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
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
