
package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.sql.Timestamp;


@Getter
@Setter
@NoArgsConstructor
public class PartialFishCatchDto {

    private Long id;
    private Timestamp date;
    private Double latitude;
    private Double longitude;
    private String text;

    public PartialFishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getCoordinates().getCoordinate().getY();
        this.longitude = fishCatch.getCoordinates().getCoordinate().getX();
        this.text = fishCatch.getText();
    }

}
