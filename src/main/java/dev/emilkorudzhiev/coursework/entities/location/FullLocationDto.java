package dev.emilkorudzhiev.coursework.entities.location;

import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.enums.LocationType;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
public class FullLocationDto {

    private Long id;
    private LocationType type;
    private double latitude;
    private double longitude;
    private String description;
    private UUID locationImageId;
    private boolean approved;
    private PartialUserDto user;
    private Timestamp date;

    public FullLocationDto(Location location) {
        this.id = location.getId();
        this.type = location.getType();
        this.latitude = location.getCoordinates().getCoordinate().getY();
        this.longitude = location.getCoordinates().getCoordinate().getX();
        this.description = location.getDescription();
        this.locationImageId = location.getLocationImageId();
        this.approved = location.isApproved();
        this.user = new PartialUserDto(location.getUser());
        this.date = location.getDate();
    }
}
