package dev.emilkorudzhiev.coursework.entities.fishcatch;


import dev.emilkorudzhiev.coursework.entities.comment.Comment;
import dev.emilkorudzhiev.coursework.entities.user.User;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import java.sql.Timestamp;
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
    private Timestamp date;

    @Column(
            name = "coordinates",
            columnDefinition = "geography(Point,4326)",
            nullable = false
    )
    private Point coordinates;

    @Column(
            name = "text",
            nullable = false
    )
    private String text;

    @ManyToOne
    @JoinColumn(
            name = "user_id",
            referencedColumnName = "id",
            nullable = false,
            updatable = false
    )
    private User user;

    @OneToMany(
            mappedBy = "fishCatch",
            cascade=CascadeType.ALL
    )
    private List<Comment> comments;

    @ManyToMany(cascade = CascadeType.ALL, mappedBy = "likedFishCatches")
    private List<User> likes;

}
