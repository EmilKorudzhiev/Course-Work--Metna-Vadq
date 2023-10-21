package dev.emilkorudzhiev.coursework.entities.fishcatch;


import dev.emilkorudzhiev.coursework.entities.comment.Comment;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;
import java.time.OffsetDateTime;
import java.util.List;


import static jakarta.persistence.GenerationType.SEQUENCE;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "FishCatch")
@Table(name = "fish_catch")
public class FishCatch {

    @Id
    @SequenceGenerator(
            name = "fish_catch_sequence",
            sequenceName = "fish_catch_sequence",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = SEQUENCE,
            generator = "fish_catch_sequence"
    )
    @Column(
            name = "id",
            updatable = false
    )
    private Long id;

    @Column(
            name = "date",
            nullable = false
    )
    private OffsetDateTime date;

    @Column(
            name = "latitude",
            nullable = false
    )
    private Float latitude;

    @Column(
            name = "longitude",
            nullable = false
    )
    private Float longitude;

    @Column(
            name = "text",
            nullable = false
    )
    private String text;

    @Column(
            name = "user_id"
    )
    private Long userId;

    @OneToMany(
            cascade = CascadeType.ALL
    )
    @JoinColumn(
            name = "fish_catch_id",
            referencedColumnName = "id"
    )
    private List<Comment> comments;

}
