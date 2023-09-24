package dev.emilkorudzhiev.coursework.fishcatch;


import dev.emilkorudzhiev.coursework.comment.Comment;
import jakarta.persistence.*;

import java.time.LocalDate;
import java.util.List;


import static jakarta.persistence.GenerationType.SEQUENCE;

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
    private LocalDate date;

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

    public FishCatch() {
    }

    public FishCatch(Long id,
                     LocalDate date,
                     Float latitude,
                     Float longitude,
                     String text) {
        this.id = id;
        this.date = date;
        this.latitude = latitude;
        this.longitude = longitude;
        this.text = text;
    }

    public FishCatch(LocalDate date,
                     Float latitude,
                     Float longitude,
                     String text) {
        this.date = date;
        this.latitude = latitude;
        this.longitude = longitude;
        this.text = text;
    }

    public FishCatch(LocalDate date,
                     Float latitude,
                     Float longitude,
                     String text,
                     List<Comment> comments) {
        this.date = date;
        this.latitude = latitude;
        this.longitude = longitude;
        this.text = text;
        this.comments = comments;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public Float getLatitude() {
        return latitude;
    }

    public void setLatitude(Float latitude) {
        this.latitude = latitude;
    }

    public Float getLongitude() {
        return longitude;
    }

    public void setLongitude(Float longitude) {
        this.longitude = longitude;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        this.text = text;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    @Override
    public String toString() {
        return "FishCatch{" +
                "id=" + id +
                ", date=" + date +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", text='" + text + '\'' +
                ", userId=" + userId +
                '}';
    }
}
