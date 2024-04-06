package dev.emilkorudzhiev.coursework.enums;


import lombok.Getter;

@Getter
public enum LocationType {
    STORE("store"),
    FISHING_PLACE("fishing_place"),
    EVENT("event");

    private final String type;

    LocationType(String type) {
        this.type = type;
    }

}
