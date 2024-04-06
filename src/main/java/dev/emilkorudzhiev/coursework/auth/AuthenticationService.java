package dev.emilkorudzhiev.coursework.auth;

import dev.emilkorudzhiev.coursework.auth.requests.AuthenticationRequest;
import dev.emilkorudzhiev.coursework.auth.requests.RegisterRequest;
import dev.emilkorudzhiev.coursework.enums.Role;
import dev.emilkorudzhiev.coursework.security.JwtService;
import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;


@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;


    public AuthenticationResponse register(RegisterRequest request) {
        var user = User.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail().toLowerCase())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(Role.USER)
                .build();
        userRepository.save(user);
        var jwtToken = jwtService.generateJwtToken(user);
        var validityOfJwtToken = jwtService.getExpirationTimeOfToken(jwtToken);

        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse
                .builder()
                .accessToken(jwtToken)
                .accessTokenValidity(validityOfJwtToken)
                .refreshToken(refreshToken)
                .build();
    }

    //For registering other roles
    public AuthenticationResponse registerWithRole(RegisterRequest request) {
        var user = User.builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail().toLowerCase())
                .password(passwordEncoder.encode(request.getPassword()))
                .role(request.getRole())
                .build();
        userRepository.save(user);
        var jwtToken = jwtService.generateJwtToken(user);
        var validityOfJwtToken = jwtService.getExpirationTimeOfToken(jwtToken);

        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse
                .builder()
                .accessToken(jwtToken)
                .accessTokenValidity(validityOfJwtToken)
                .refreshToken(refreshToken)
                .build();
    }


    public AuthenticationResponse authenticate(AuthenticationRequest request) {
        authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        request.getEmail().toLowerCase(),
                        request.getPassword()
                )
        );
        var user = userRepository.findUserByEmail(request.getEmail().toLowerCase())
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
        var jwtToken = jwtService.generateJwtToken(user);
        var validityOfJwtToken = jwtService.getExpirationTimeOfToken(jwtToken);

        var refreshToken = jwtService.generateRefreshToken(user);
        return AuthenticationResponse
                .builder()
                .accessToken(jwtToken)
                .accessTokenValidity(validityOfJwtToken)
                .refreshToken(refreshToken)
                .build();
    }

    public AuthenticationResponse refreshToken(HttpServletRequest request) {
        final String authHeader = request.getHeader("Authorization");
        final String refreshToken;
        final String username; //User Email in this case (var name is username for consistency)
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return null;
        }
        refreshToken = authHeader.substring(7);
        username = jwtService.extractUsername(refreshToken);
        if(username != null) {
            var userDetails = this.userRepository.findUserByEmail(username.toLowerCase())
                    .orElseThrow();
            if (jwtService.isJwtTokenValid(refreshToken, userDetails)) {
                var accessToken = jwtService.generateJwtToken(userDetails);
                var validityOfToken = jwtService.getExpirationTimeOfToken(accessToken);
                return AuthenticationResponse.builder()
                        .accessToken(accessToken)
                        .accessTokenValidity(validityOfToken)
                        .refreshToken(refreshToken)
                        .build();
            }
        }
        return null;
    }
}
