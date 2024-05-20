package dev.emilkorudzhiev.coursework.entities.comment;

import dev.emilkorudzhiev.coursework.entities.comment.requests.CommentRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "api/v1/comment")
@PreAuthorize("hasAnyRole('ADMIN','USER')")
public class CommentController {

    private final CommentService commentService;

    @GetMapping()
    @PreAuthorize("hasAnyAuthority('admin:read', 'user:read')")
    public ResponseEntity<List<CommentDto>> getComments(
            @RequestParam(name = "post-id", required = true) Long postId,
            @RequestParam(name = "page-size", defaultValue = "20", required = false) Integer pageSize,
            @RequestParam(name = "page", defaultValue = "0", required = false) Integer pageNumber
    ) {
        Optional<List<CommentDto>> list = commentService.getComments(postId, pageSize, pageNumber);
        return list.map(ResponseEntity::ok).orElseGet(() -> ResponseEntity.notFound().build());
    }

    @PostMapping()
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
