package kg.manurov.bankmvc.service.specifications;

import jakarta.persistence.criteria.Predicate;
import kg.manurov.bankmvc.entities.Card;
import kg.manurov.bankmvc.entities.CardApplication;
import lombok.experimental.UtilityClass;
import org.springframework.data.jpa.domain.Specification;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@UtilityClass
public class CardSpecification {
    public static Specification<Card> createSpecification(String status, BigDecimal balanceFrom, BigDecimal balanceTo) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter for the status (accurate coincidence)
            if (status != null) {
                predicates.add(criteriaBuilder.like(
                        criteriaBuilder.lower(root.get("status")),
                        "%" + status.toUpperCase() + "%"
                ));
            }

            if (balanceFrom != null && balanceTo == null) {
                predicates.add(criteriaBuilder.greaterThanOrEqualTo(root.get("balance"), balanceFrom));
            }

            if (balanceTo != null && balanceFrom == null) {
                predicates.add(criteriaBuilder.lessThanOrEqualTo(root.get("balance"), balanceTo));
            }

            if (balanceFrom != null && balanceTo != null) {
                predicates.add(criteriaBuilder.between(root.get("balance"), balanceFrom, balanceTo));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

    }

    public static Specification<CardApplication> createSpecificationByUserId(Long id) {
        return (root, query, cb) ->
                cb.equal(root.get("user").get("id"), id);
    }
}
