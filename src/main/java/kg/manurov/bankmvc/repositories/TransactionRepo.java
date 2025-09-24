package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.Transaction;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.Instant;


@Repository
public interface TransactionRepo extends JpaRepository<Transaction, Long>, JpaSpecificationExecutor<Transaction> {

    @Query("SELECT t FROM Transaction t WHERE t.fromCard.id = :cardId OR t.toCard.id = :cardId ORDER BY t.createdAt DESC")
    Page<Transaction> findByCardId(@Param("cardId") Long cardId, Pageable pageable);

    @Query("""
        SELECT COUNT(distinct t)
        FROM Transaction t
        WHERE (t.fromCard.owner.id = :userId
           OR t.toCard.owner.id = :userId)""")
    int countTransactionsByUserId(@Param("userId") Long cardId);

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

    @Query("SELECT SUM(t.amount)" +
           "FROM Transaction t\n" +
           "WHERE (t.fromCard.owner.id = :userId OR t.toCard.owner.id = :userId)")
    BigDecimal getTotalAmountByUserId(Long userId);
}