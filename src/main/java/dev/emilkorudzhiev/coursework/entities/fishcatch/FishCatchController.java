package dev.emilkorudzhiev.coursework.entities.fishcatch;


import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;


@RestController
@RequiredArgsConstructor
@RequestMapping(path = "api/v1/fish-catch")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class FishCatchController {

    private final FishCatchService fishCatchService;

    @GetMapping("{fishCatchId}")
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<FishCatchDto> getFishCatch(@PathVariable("fishCatchId") Long fishCatchId) {
        Optional<FishCatchDto> fishCatch = fishCatchService.getFishClassById(fishCatchId);
        return fishCatch.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> newFishCatch(
            @RequestBody FishCatchRequest request
    ) {
        fishCatchService.addNewFishCatch(request);
        return ResponseEntity.noContent().build();
    }



}
