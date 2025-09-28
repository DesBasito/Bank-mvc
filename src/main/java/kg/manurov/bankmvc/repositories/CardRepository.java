package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.Card;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface CardRepository extends JpaRepository<Card, Long> , JpaSpecificationExecutor<Card> {
    boolean existsByCardNumber(String cardNumber);
    List<Card> findByOwnerId(Long ownerId);

    @Query("SELECT c FROM Card c WHERE c.owner.id = :ownerId AND c.status = 'ACTIVE'")
    List<Card> findActiveCardsByOwnerId(@Param("ownerId") Long ownerId);

    @Query("SELECT c FROM Card c WHERE c.expiryDate < :currentDate")
    List<Card> findExpiredCards(@Param("currentDate") LocalDate currentDate);
}