package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.enums.LocationType;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MarkerLocationDto {
    private Long id;
    private LocationType type;
    private Double latitude;
    private Double longitude;

    public MarkerLocationDto(Location location) {
        this.id = location.getId();
        this.type = location.getType();
        this.latitude = location.getCoordinates().getCoordinate().getY();
        this.longitude = location.getCoordinates().getCoordinate().getX();
    }
}
