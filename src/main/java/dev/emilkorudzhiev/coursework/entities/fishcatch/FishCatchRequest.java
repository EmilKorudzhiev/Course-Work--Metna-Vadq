package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FishCatchRequest {
    private Float latitude;
    private Float longitude;
    private String text;
}
