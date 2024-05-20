package dev.emilkorudzhiev.coursework.auth;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

import java.sql.Timestamp;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthenticationResponse {
    @JsonProperty("access_token")
    private String accessToken;

    @JsonProperty("access_token_validity")
    private Date accessTokenValidity;

    @JsonProperty("refresh_token")
    private String refreshToken;

    @JsonProperty("is_admin")
    private boolean isAdmin;

}
