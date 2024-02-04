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

    // TODO : make recommendation algorithm
    @GetMapping()
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<FullFishCatchDto>> getFishCatches(
            @RequestParam(name = "page-size", defaultValue = "20", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber
    ) {
        Optional<List<FullFishCatchDto>> list = fishCatchService.getFishCatches(pageSize, pageNumber);
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
    public ResponseEntity<List<FullFishCatchDto>> getFishCatchesInRadius(
            @RequestBody SearchRadiusRequest request
    ) {
        Optional<List<FullFishCatchDto>> list = fishCatchService.getFishCatchesInRadius(request);
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
