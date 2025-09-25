package kg.manurov.bankmvc.repositories;

import kg.manurov.bankmvc.entities.CardApplication;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;

@Repository
public interface CardApplicationRepository extends JpaRepository<CardApplication, Long>, JpaSpecificationExecutor<CardApplication> {
}