package dev.emilkorudzhiev.coursework.entities.fishcatch;

import dev.emilkorudzhiev.coursework.entities.comment.Comment;
import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import lombok.*;

import java.time.OffsetDateTime;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
public class FishCatchDto {

    private Long id;
    private OffsetDateTime date;
    private Float latitude;
    private Float longitude;
    private String text;
    private PartialUserDto user;
    private List<Comment> comments;

    public FishCatchDto(FishCatch fishCatch) {
        this.id = fishCatch.getId();
        this.date = fishCatch.getDate();
        this.latitude = fishCatch.getLatitude();
        this.longitude = fishCatch.getLongitude();
        this.text = fishCatch.getText();
        this.user = new PartialUserDto(fishCatch.getUser());
        this.comments = fishCatch.getComments();
    }
}
