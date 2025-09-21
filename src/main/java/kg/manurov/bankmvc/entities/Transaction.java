package kg.manurov.bankmvc.entities;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.Instant;

@Getter
@Setter
@Entity
@FieldDefaults(level = AccessLevel.PRIVATE)
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "transactions")
@EntityListeners(AuditingEntityListener.class)
public class Transaction {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "from_card_id", nullable = false)
    Card fromCard;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "to_card_id", nullable = false)
    Card toCard;

    @Column(name = "amount", nullable = false, precision = 19, scale = 2)
    BigDecimal amount;

    @Column(name = "description", length = 500)
    String description;

    @ColumnDefault("'PENDING'")
    @Column(name = "status", nullable = false, length = 20)
    String status;

    @ColumnDefault("now()")
    @Column(name = "created_at", nullable = false)
    @CreatedDate
    Instant createdAt;

    @Column(name = "processed_at")
    @LastModifiedDate
    Instant processedAt;

    @Column(name = "error_message", length = 1000)
    String errorMessage;

}