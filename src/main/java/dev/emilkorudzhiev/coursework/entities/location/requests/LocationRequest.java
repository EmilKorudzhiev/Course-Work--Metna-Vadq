package dev.emilkorudzhiev.coursework.entities.location.requests;

import dev.emilkorudzhiev.coursework.enums.LocationType;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LocationRequest {
    private String type;
    private double latitude;
    private double longitude;
    private String description;
}
