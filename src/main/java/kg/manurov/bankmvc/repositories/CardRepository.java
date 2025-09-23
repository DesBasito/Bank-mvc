package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.Card;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
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

    Optional<Card> findByCardNumber(String cardNumber);
    boolean existsByCardNumber(String cardNumber);
    Page<Card> findByOwnerId(Long ownerId, Pageable pageable);

    @Query("SELECT c FROM Card c WHERE c.owner.id = :ownerId AND c.status = 'ACTIVE'")
    List<Card> findActiveCardsByOwnerId(@Param("ownerId") Long ownerId);

    @Query("SELECT c FROM Card c WHERE c.expiryDate < :currentDate")
    List<Card> findExpiredCards(@Param("currentDate") LocalDate currentDate);

    @Query("SELECT c FROM Card c WHERE " +
           "LOWER(c.owner.middleName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(c.owner.firstName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(c.owner.lastName) LIKE LOWER(CONCAT('%', :search, '%'))")
    Page<Card> findByOwnerNameContaining(@Param("search") String search, Pageable pageable);
}