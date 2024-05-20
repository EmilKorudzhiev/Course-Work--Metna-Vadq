package dev.emilkorudzhiev.coursework.auth.requests;

import com.fasterxml.jackson.annotation.JsonProperty;
import dev.emilkorudzhiev.coursework.enums.Role;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RegisterRequest {

    @JsonProperty("first-name")
    private String firstName;

    @JsonProperty("last-name")
    private String lastName;

    @JsonProperty("email")
    private String email;

    @JsonProperty("password")
    private String password;
    private Role role;
}
