package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SearchRadiusRequest {
    private Double latitude;
    private Double longitude;
    private Long distance;
}
