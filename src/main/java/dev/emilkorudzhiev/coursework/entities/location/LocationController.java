package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatchController;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "api/v1/locations")
@RequiredArgsConstructor
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class LocationController {

    private FishCatchController locationService;

//    @PostMapping
//    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
//    public ResponseEntity<Void> postLocation(
//            @RequestBody LocationRequest request
//    ) {
//        locationService.postLocation(request);
//        return ResponseEntity.noContent().build();
//    }

}
