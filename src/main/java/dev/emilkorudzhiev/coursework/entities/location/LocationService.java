package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.aws.s3.S3Buckets;
import dev.emilkorudzhiev.coursework.aws.s3.S3Service;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatch;
import dev.emilkorudzhiev.coursework.entities.fishcatch.MarkerFishCatchDto;
import dev.emilkorudzhiev.coursework.entities.fishcatch.requests.SearchRadiusRequest;
import dev.emilkorudzhiev.coursework.entities.location.requests.LocationRequest;
import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserService;
import dev.emilkorudzhiev.coursework.enums.LocationType;
import lombok.RequiredArgsConstructor;
import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.GeometryFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class LocationService {

    @Value("${cloud.aws.s3.max-file-size}")
    private int maxImageSize;

    private final LocationRepository locationRepository;
    private final UserService userService;
    private final S3Service s3Service;
    private final S3Buckets s3Buckets;

    public Optional<List<FullLocationDto>> getLocations(Integer pageSize, Integer pageNumber) {
        return locationRepository
                .findLocationPageable(PageRequest.of(pageNumber, pageSize))
                .map(locations -> locations.stream().map(FullLocationDto::new).toList());
    }

    public Optional<List<MarkerLocationDto>> getLocationsInRadius(SearchRadiusRequest request) {
        Optional<List<Location>> locationsInRadius =  locationRepository.findLocationsInRadius(request.getLatitude(), request.getLongitude(), request.getDistance());
        return locationsInRadius.map(locations -> locations.stream().map(MarkerLocationDto::new).toList());
    }

    public void postLocation(LocationRequest request, MultipartFile image) {
        User user = userService.getCurrentUser().get();
        UUID imageId = UUID.randomUUID();

        if(image.isEmpty())
            throw new RuntimeException("No file attached.");
        if(!Set.of("image/png","image/jpeg").contains(image.getContentType()))
            throw new RuntimeException("File format not supported.");
        if (image.getSize() > maxImageSize)
            throw new RuntimeException("Image size is too large.");

        try {
            Location location = Location
                    .builder()
                    .type(LocationType.valueOf(request.getType().toUpperCase()))
                    .coordinates(new GeometryFactory().createPoint(new Coordinate(request.getLongitude(), request.getLatitude())))
                    .description(request.getDescription())
                    .locationImageId(imageId)
                    .user(user)
                    .build();
            Long locationId = locationRepository.save(location).getId();
            s3Service.putObject(
                    s3Buckets.getLocations(),
                    "locations/%s/%s".formatted(locationId, imageId),
                    image.getBytes()
            );
        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }

}
