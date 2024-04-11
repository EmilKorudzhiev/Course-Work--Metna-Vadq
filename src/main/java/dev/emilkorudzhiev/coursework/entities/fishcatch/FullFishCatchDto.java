package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.comment.CommentDto;
import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import lombok.*;

import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@NoArgsConstructor
public class FullFishCatchDto {

    private Long id;
    private Timestamp date;
    private Double latitude;
    private Double longitude;
    private String text;
    private UUID fishCatchImage;
    private PartialUserDto user;
    private boolean isLiked;

    public FullFishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getCoordinates().getCoordinate().getY();
        this.longitude = fishCatch.getCoordinates().getCoordinate().getX();
        this.text = fishCatch.getText();
        this.fishCatchImage = fishCatch.getFishCatchImage();
        this.user = new PartialUserDto(fishCatch.getUser());
    }

}
