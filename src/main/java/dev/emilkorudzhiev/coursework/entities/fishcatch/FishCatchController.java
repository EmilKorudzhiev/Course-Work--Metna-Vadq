package dev.emilkorudzhiev.coursework.entities.fishcatch;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;


@RestController
@RequiredArgsConstructor
@RequestMapping(path = "api/v1/fish-catch")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class FishCatchController {

    private final FishCatchService fishCatchService;

    @GetMapping("{fishCatchId}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FishCatchDto> getFishCatch(
            @PathVariable("fishCatchId") Long fishCatchId
    ) {
        Optional<FishCatchDto> fishCatch = fishCatchService.getFishCatchById(fishCatchId);
        return fishCatch.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @GetMapping("find-in-radius")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<FishCatchDto>> getFishCatchesInRadius(
            @RequestBody SearchRadiusRequest request
    ) {
        Optional<List<FishCatchDto>> list = fishCatchService.getFishCatchesInRadius(request);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> postFishCatch(
            @RequestBody FishCatchRequest request
    ) {
        fishCatchService.postFishCatch(request);
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
                ResponseEntity.badRequest().build();
    }

}
