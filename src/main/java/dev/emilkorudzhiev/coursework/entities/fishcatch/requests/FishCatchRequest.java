package dev.emilkorudzhiev.coursework.entities.fishcatch.requests;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FishCatchRequest {
    private double latitude;
    private double longitude;
    private String text;
}
