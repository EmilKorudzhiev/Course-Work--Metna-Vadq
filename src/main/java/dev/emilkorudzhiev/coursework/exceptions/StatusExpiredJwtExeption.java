package dev.emilkorudzhiev.coursework.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "JWT expired")
public class StatusExpiredJwtExeption extends RuntimeException{
    public StatusExpiredJwtExeption() {
        super("JWT expired");
    }
}
