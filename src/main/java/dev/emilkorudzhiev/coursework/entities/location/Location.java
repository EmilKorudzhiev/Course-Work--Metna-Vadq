package dev.emilkorudzhiev.coursework.entities.location;


import dev.emilkorudzhiev.coursework.enums.LocationType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.locationtech.jts.geom.Point;

import static jakarta.persistence.EnumType.STRING;
import static jakarta.persistence.GenerationType.SEQUENCE;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
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
            name = "coordinates",
            columnDefinition = "geography(Point,4326)",
            nullable = false
    )
    private Point coordinates;

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

}
