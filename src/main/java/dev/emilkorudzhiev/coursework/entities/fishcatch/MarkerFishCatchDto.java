package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class MarkerFishCatchDto {
        private Long id;
        private Double latitude;
        private Double longitude;

        public MarkerFishCatchDto(FishCatch fishCatch) {
            this.id = fishCatch.getId();
            this.latitude = fishCatch.getCoordinates().getCoordinate().getY();
            this.longitude = fishCatch.getCoordinates().getCoordinate().getX();
        }
}
