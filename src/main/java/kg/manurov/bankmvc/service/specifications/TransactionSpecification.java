package kg.manurov.bankmvc.service.specifications;

import jakarta.persistence.criteria.Predicate;
import kg.manurov.bankmvc.entities.Transaction;
import lombok.experimental.UtilityClass;
import org.springframework.data.jpa.domain.Specification;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

@UtilityClass
public class TransactionSpecification{
    public static Specification<Transaction> createSpecification(Long userId,Instant from, Instant to, Long selectedCardId) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (selectedCardId != null) {
                Predicate fromCard = criteriaBuilder.equal(root.get("fromCard").get("id"), selectedCardId);
                Predicate toCard = criteriaBuilder.equal(root.get("toCard").get("id"), selectedCardId);
                predicates.add(criteriaBuilder.or(fromCard, toCard));
            }

            if (userId != null) {
                Predicate fromCard = criteriaBuilder.equal(root.get("fromCard").get("owner").get("id"), userId);
                Predicate toCard = criteriaBuilder.equal(root.get("toCard").get("owner").get("id"), userId);
                predicates.add(criteriaBuilder.or(fromCard, toCard));
            }


            if (from != null && to == null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("createdAt"), from));
            }

            if (from == null && to != null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("createdAt"), to));
            }

            if (from != null && to != null) {
                predicates.add(criteriaBuilder.between(root.get("createdAt"), from, to));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

    }

}
