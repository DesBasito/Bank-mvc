package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.CardBlockRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CardBlockRequestRepository extends JpaRepository<CardBlockRequest, Long> {

    Page<CardBlockRequest> findByUserId(Long userId, Pageable pageable);

    Page<CardBlockRequest> findByStatus(String status, Pageable pageable);

    @Query("SELECT CASE WHEN COUNT(r) > 0 THEN true ELSE false END FROM CardBlockRequest r " +
           "WHERE r.card.id = :cardId AND r.status = 'PENDING'")
    boolean existsPendingRequestForCard(@Param("cardId") Long cardId);
}