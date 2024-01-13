package dev.emilkorudzhiev.coursework.entities.fishcatch;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FishCatchRequest {
    private double latitude;
    private double longitude;
    private String text;
}
