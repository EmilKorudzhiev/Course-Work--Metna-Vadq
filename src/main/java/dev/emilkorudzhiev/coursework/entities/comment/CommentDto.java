package dev.emilkorudzhiev.coursework.entities.comment;

import dev.emilkorudzhiev.coursework.entities.user.PartialUserDto;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.OffsetDateTime;


@Getter
@Setter
@NoArgsConstructor
public class CommentDto {

    private Long id;
    private Long fishCatchId;
    private String text;
    private OffsetDateTime date;
    private PartialUserDto user;

    public CommentDto(Comment comment) {
        this.id = comment.getId();
        this.text = comment.getText();
        this.date = comment.getDate();
        this.user = new PartialUserDto(comment.getUser());
        this.fishCatchId = comment.getFishCatch().getId();
    }
}
