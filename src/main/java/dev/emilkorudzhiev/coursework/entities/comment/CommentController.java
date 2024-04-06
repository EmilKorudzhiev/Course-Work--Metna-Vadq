package dev.emilkorudzhiev.coursework.entities.comment;

import dev.emilkorudzhiev.coursework.entities.comment.requests.CommentRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "api/v1/comment")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class CommentController {

    private final CommentService commentService;

    @PostMapping
    @PreAuthorize("hasAnyAuthority('admin:create', 'user:create')")
    public ResponseEntity<Void> postComment(
            @RequestBody CommentRequest request
    ){
        boolean posted = commentService.postComment(request);
        return posted ?
                ResponseEntity.noContent().build() :
                ResponseEntity.notFound().build();
    }

}
