package dev.emilkorudzhiev.coursework.location;


import dev.emilkorudzhiev.coursework.enums.LocationType;
import jakarta.persistence.*;

import static jakarta.persistence.EnumType.STRING;
import static jakarta.persistence.GenerationType.SEQUENCE;


@Entity(name = "Location")
@Table(name = "location")
public class Location {

    @Id
    @SequenceGenerator(
            name = "location_sequence",
            sequenceName = "location_sequence",
            allocationSize = 1
    )
    @GeneratedValue(
            strategy = SEQUENCE,
            generator = "location_sequence"
    )
    @Column(
            name = "id",
            updatable = false
    )
    private Long id;

    @Column(
            name = "type",
            nullable = false
    )
    @Enumerated(STRING)
    private LocationType type;

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
            name = "description",
            nullable = false
    )
    private String description;

    @Column(
            name = "approved",
            nullable = false
    )
    private boolean approved;

    public Location() {
    }


    public Location(LocationType type,
                    Float latitude,
                    Float longitude,
                    String description,
                    boolean approved) {
        this.type = type;
        this.latitude = latitude;
        this.longitude = longitude;
        this.description = description;
        this.approved = approved;
    }

    public Location(Long id,
                    LocationType type,
                    Float latitude,
                    Float longitude,
                    String description,
                    boolean approved) {
        this.id = id;
        this.type = type;
        this.latitude = latitude;
        this.longitude = longitude;
        this.description = description;
        this.approved = approved;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public LocationType getType() {
        return type;
    }

    public void setType(LocationType type) {
        this.type = type;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isApproved() {
        return approved;
    }

    public void setApproved(boolean approved) {
        this.approved = approved;
    }

    @Override
    public String toString() {
        return "Location{" +
                "id=" + id +
                ", type=" + type +
                ", latitude=" + latitude +
                ", longitude=" + longitude +
                ", description='" + description + '\'' +
                ", approved=" + approved +
                '}';
    }
}
