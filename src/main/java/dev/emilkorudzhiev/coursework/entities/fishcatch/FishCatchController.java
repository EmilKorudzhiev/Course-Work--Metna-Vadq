package dev.emilkorudzhiev.coursework.entities.fishcatch;


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
@RequestMapping(path = "api/v1/fish-catch")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class FishCatchController {

    private final FishCatchService fishCatchService;

    //GET CATCHES WITHOUT RECOMMENDATION ALGORITHM (ONLY FOR TESTING PURPOSES)
    @GetMapping()
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<? extends List<?>> getFishCatches(
            @RequestParam(name = "page-size", defaultValue = "20", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber
    ) {
        Optional<List<FullFishCatchDto>> list = fishCatchService.getFishCatches(pageSize, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // TODO : make recommendation algorithm
    @GetMapping("feed")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<FullFishCatchDto>> getFishCatchesFeed(
            @RequestParam(name = "page-size", defaultValue = "20", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber
    ) {
        Optional<List<FullFishCatchDto>> list = fishCatchService.getFishCatchesFeed(pageSize, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("user")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<PartialFishCatchDto>> getUserFishCatches(
            @RequestParam(name = "page-size", defaultValue = "15", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber,
            @RequestParam(name = "user-id", required = false) Long userId
    ) {
        Optional<List<PartialFishCatchDto>> list = fishCatchService.getUserFishCatches(pageSize, pageNumber, userId);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("{fishCatchId}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FullFishCatchDto> getFishCatchById(
            @PathVariable("fishCatchId") Long fishCatchId
    ) {
        Optional<FullFishCatchDto> fishCatch = fishCatchService.getFishCatchById(fishCatchId);
        return fishCatch.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    // TODO : make it better for map showcase
    // TODO : make date search too
    @GetMapping("find-in-radius")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<MarkerFishCatchDto>> getFishCatchMarkersInRadius(
            @RequestBody SearchRadiusRequest request
    ) {
        Optional<List<MarkerFishCatchDto>> list = fishCatchService.getFishCatchMarkersInRadius(request);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }


    // TODO : get posts for feed with pagination


    @PostMapping(consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> postFishCatch(
            @RequestPart FishCatchRequest request,
            @RequestPart MultipartFile image
    ) {
        fishCatchService.postFishCatch(request, image);
        return ResponseEntity.noContent().build();
    }

    @DeleteMapping("{fishCatchId}")
    @PreAuthorize("hasAnyAuthority('admin:delete', 'user:delete')")
    public ResponseEntity<Void> deleteFishCatch(
            @PathVariable("fishCatchId") Long fishCatchId
    ) {
        boolean deleted = fishCatchService.deleteFishCatch(fishCatchId);
        return deleted ?
                ResponseEntity.noContent().build() :
                ResponseEntity.notFound().build();
    }

}
