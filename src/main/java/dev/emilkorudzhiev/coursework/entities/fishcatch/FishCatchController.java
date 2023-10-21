package dev.emilkorudzhiev.coursework.entities.fishcatch;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "api/v1/fish-catch")
public class FishCatchController {

    private final FishCatchService fishCatchService;

    @Autowired
    public FishCatchController(FishCatchService fishCatchService){
        this.fishCatchService = fishCatchService;
    }

}
