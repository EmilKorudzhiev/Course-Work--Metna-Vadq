package dev.emilkorudzhiev.coursework.user;

import dev.emilkorudzhiev.coursework.comment.Comment;
import dev.emilkorudzhiev.coursework.fishcatch.FishCatch;
import jakarta.persistence.*;

import java.util.List;

import static jakarta.persistence.GenerationType.SEQUENCE;


@Entity(name = "User")
@Table(
        name = "user",
        uniqueConstraints = {
                @UniqueConstraint(name = "user_email_unique", columnNames = "email")
        }
)
public class User {

    @Id
    @SequenceGenerator(
            name = "user_sequence",
            sequenceName = "user_sequence",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = SEQUENCE,
            generator = "user_sequence"
    )
    @Column(
            name = "id",
            updatable = false
    )
    private Long id;

    @Column(
            name = "first_name",
            nullable = false
    )
    private String firstName;

    @Column(
            name = "last_name",
            nullable = false
    )
    private String lastName;

    @Column(
            name = "email",
            nullable = false
    )
    private String email;

    @OneToMany(
            cascade = CascadeType.ALL
    )
    @JoinColumn(
            name = "user_id",
            referencedColumnName = "id"
    )
    private List<FishCatch> fishCatches;

    @OneToMany(mappedBy = "user")
    private List<Comment> comments;

    public User() {
    }

    public User(String firstName,
                String lastName,
                String email) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
    }

    public User(String firstName,
                String lastName,
                String email,
                List<FishCatch> fishCatches) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.fishCatches = fishCatches;
    }

    public User(String firstName,
                String lastName,
                String email,
                List<FishCatch> fishCatches,
                List<Comment> comments) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.fishCatches = fishCatches;
        this.comments = comments;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public List<FishCatch> getFishCatches() {
        return fishCatches;
    }

    public void setFishCatches(List<FishCatch> fishCatches) {
        this.fishCatches = fishCatches;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", firstName='" + firstName + '\'' +
                ", lastName='" + lastName + '\'' +
                ", email='" + email + '\'' +
                '}';
    }
}
