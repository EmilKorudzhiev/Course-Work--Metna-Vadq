package dev.emilkorudzhiev.coursework.entities.location;

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
    private LocationType type;
    private Point coordinates;
    private String description;
}
