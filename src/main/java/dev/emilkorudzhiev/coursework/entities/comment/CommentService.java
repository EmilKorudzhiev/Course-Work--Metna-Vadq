package dev.emilkorudzhiev.coursework.entities.comment;

import dev.emilkorudzhiev.coursework.entities.comment.requests.CommentRequest;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatch;
import dev.emilkorudzhiev.coursework.entities.fishcatch.FishCatchRepository;
import dev.emilkorudzhiev.coursework.entities.user.User;
import dev.emilkorudzhiev.coursework.entities.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class CommentService {

    private final CommentRepository commentRepository;
    private final UserRepository userRepository;
    private final FishCatchRepository fishCatchRepository;

    public Optional<List<CommentDto>> getComments(Long postId ,Integer pageSize, Integer pageNumber) {
        return commentRepository.findCommentsByFishCatchId(postId, PageRequest.of(pageNumber, pageSize))
                .map(comments -> comments.stream().map(CommentDto::new).toList());
    }

    public boolean postComment(CommentRequest request) {
        String username = SecurityContextHolder.getContext().getAuthentication().getName();
        User user = userRepository.findUserByEmail(username).get();
        Optional<FishCatch> fishCatch = fishCatchRepository.findById(request.getFishCatchId());
        if(fishCatch.isPresent()) {
            Comment comment = Comment
                    .builder()
                    .text(request.getText())
                    .date(OffsetDateTime.now().toZonedDateTime().toOffsetDateTime())
                    .user(user)
                    .fishCatch(fishCatch.get())
                    .build();
            commentRepository.save(comment);
            return true;
        }else{
            return false;
        }

    }


}
