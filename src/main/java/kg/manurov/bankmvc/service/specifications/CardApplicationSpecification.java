// CarSpecification.java
package kg.manurov.bankmvc.service.specifications;

import jakarta.persistence.criteria.Predicate;
import kg.manurov.bankmvc.entities.CardApplication;
import lombok.experimental.UtilityClass;
import org.springframework.data.jpa.domain.Specification;

import java.util.ArrayList;
import java.util.List;

@UtilityClass
public class CardApplicationSpecification {
    public static Specification<CardApplication> createSpecification(String status) {
        return (root, query, criteriaBuilder) -> {
            List<Predicate> predicates = new ArrayList<>();

            // Filter for the status (accurate coincidence)
            if (status != null && !status.trim().isEmpty()) {
                predicates.add(criteriaBuilder.like(
                        criteriaBuilder.lower(root.get("status")),
                        "%" + status.toUpperCase() + "%"
                ));
            }

            return criteriaBuilder.and(predicates.toArray(new Predicate[0]));
        };

    }
    public static Specification<CardApplication> createSpecificationByUserId(Long id) {
        return (root, query, cb) ->
                cb.equal(root.get("user").get("id"), id);
    }
}