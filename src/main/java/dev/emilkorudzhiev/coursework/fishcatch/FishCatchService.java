package dev.emilkorudzhiev.coursework.fishcatch;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FishCatchService {


    private final FishCatchRepository fishCatchRepository;

    @Autowired
    public FishCatchService(FishCatchRepository fishCatchRepository) {
        this.fishCatchRepository = fishCatchRepository;
    }

    public void addNewFishCatch(FishCatch fishCatch){
        fishCatchRepository.save(fishCatch);
    }

}
