
package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;
import java.util.UUID;


@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PartialFishCatchDto {

    private Long id;
    private Timestamp date;
    private Double latitude;
    private Double longitude;
    private UUID fishCatchImage;

    public PartialFishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getCoordinates().getCoordinate().getY();
        this.longitude = fishCatch.getCoordinates().getCoordinate().getX();
        this.fishCatchImage = fishCatch.getFishCatchImage();
    }
}
