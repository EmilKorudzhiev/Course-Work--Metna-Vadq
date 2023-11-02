package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.comment.CommentDto;
import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import lombok.*;
import org.locationtech.jts.geom.Coordinate;

import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class FishCatchDto {

    private Long id;
    private Timestamp date;
    private double latitude;
    private double longitude;
    private String text;
    private PartialUserDto user;
    private List<CommentDto> comments;

    public FishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getCoordinates().getCoordinate().getX();
        this.longitude = fishCatch.getCoordinates().getCoordinate().getY();
        this.text = fishCatch.getText();
        this.user = new PartialUserDto(fishCatch.getUser());
        this.comments = fishCatch.getComments().stream().map(CommentDto::new).toList();
    }
}
