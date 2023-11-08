package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.comment.CommentDto;
import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import lombok.*;

import java.sql.Timestamp;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class FishCatchDto {

    private Long id;
    private Timestamp date;
    private Double latitude;
    private Double longitude;
    private String text;
    private PartialUserDto user;
    private List<CommentDto> comments;

    public FishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getCoordinates().getCoordinate().getY();
        this.longitude = fishCatch.getCoordinates().getCoordinate().getX();
        this.text = fishCatch.getText();
        this.user = new PartialUserDto(fishCatch.getUser());
        this.comments = fishCatch.getComments().stream().map(CommentDto::new).toList();
    }

}
