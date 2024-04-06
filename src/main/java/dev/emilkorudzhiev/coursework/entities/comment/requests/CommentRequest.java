package dev.emilkorudzhiev.coursework.entities.comment.requests;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommentRequest {
    @JsonProperty("fish-catch-id")
    private Long fishCatchId;
    private String text;
}
