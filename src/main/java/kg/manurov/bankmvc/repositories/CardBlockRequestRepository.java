package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.CardBlockRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CardBlockRequestRepository extends JpaRepository<CardBlockRequest, Long> {

    Page<CardBlockRequest> findByUserId(Long userId, Pageable pageable);

    Page<CardBlockRequest> findByStatus(String status, Pageable pageable);

    List<CardBlockRequest> findByCardIdAndStatus(Long id, String name);
}