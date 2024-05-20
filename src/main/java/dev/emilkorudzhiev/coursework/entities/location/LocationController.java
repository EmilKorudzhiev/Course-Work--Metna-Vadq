package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatchController;
import dev.emilkorudzhiev.coursework.entities.fishcatch.requests.SearchRadiusRequest;
import dev.emilkorudzhiev.coursework.entities.location.requests.LocationRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "api/v1/location")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class LocationController {

    private final LocationService locationService;

    @GetMapping()
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<FullLocationDto>> getLocations(
            @RequestParam(name = "page-size", defaultValue = "20", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber
    ) {
        Optional<List<FullLocationDto>> list = locationService.getLocations(pageSize, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("{id}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FullLocationDto> getLocation(
            @PathVariable Long id
    ) {
        Optional<FullLocationDto> location = locationService.getLocation(id);
        return location.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("find-in-radius")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<MarkerLocationDto>> getLocationsInRadius(
            @RequestBody SearchRadiusRequest request
    ) {
        Optional<List<MarkerLocationDto>> list = locationService.getLocationsInRadius(request);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> postLocation(
            @RequestPart LocationRequest request,
            @RequestPart MultipartFile image
    ) {
        locationService.postLocation(request, image);
        return ResponseEntity.noContent().build();
    }


}
