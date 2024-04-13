package dev.emilkorudzhiev.coursework.entities.comment;

import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CommentRepository extends JpaRepository<Comment,Long> {

    @Query("SELECT c FROM Comment c WHERE c.fishCatch.id = :postId ORDER BY c.date DESC")
    Optional<List<Comment>> findCommentsByFishCatchId(Long postId, Pageable pageable);
}
