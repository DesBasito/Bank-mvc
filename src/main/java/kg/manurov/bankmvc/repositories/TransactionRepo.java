package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.Transaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;


@Repository
public interface TransactionRepo extends JpaRepository<Transaction, Long> {

    @Query("SELECT t FROM Transaction t WHERE t.fromCard.id = :cardId OR t.toCard.id = :cardId")
    Page<Transaction> findByCardId(@Param("cardId") Long cardId, Pageable pageable);

    @Query("SELECT t FROM Transaction t WHERE t.fromCard.owner.id = :userId OR t.toCard.owner.id = :userId")
    Page<Transaction> findByUserId(@Param("userId") Long userId, Pageable pageable);

    @Query("""
        SELECT COUNT(distinct t)
        FROM Transaction t
        WHERE t.fromCard.id = :cardId
           OR t.toCard.id = :cardId""")
    long countTransactionsByCardId(@Param("cardId") Long cardId);

    @Query("""
    SELECT COUNT(t)
    FROM Transaction t
    WHERE (t.fromCard.owner.id = :userId OR t.toCard.owner.id = :userId)
      AND t.createdAt BETWEEN :start AND :end
""")
    int countTransactionsByUserIdAndDateRange(
            @Param("userId") Long userId,
            @Param("start") Instant start,
            @Param("end") Instant end
    );
}