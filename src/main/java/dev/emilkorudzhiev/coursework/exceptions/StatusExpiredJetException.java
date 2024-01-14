package dev.emilkorudzhiev.coursework.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(code = HttpStatus.UNAUTHORIZED, reason = "JWT expired")
public class StatusExpiredJetException extends RuntimeException{
    public StatusExpiredJetException() {
        super("JWT expired");
    }
}
