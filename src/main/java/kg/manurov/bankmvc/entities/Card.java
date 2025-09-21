package kg.manurov.bankmvc.entities;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.Accessors;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
@FieldDefaults(level = AccessLevel.PRIVATE)
@Table(name = "cards")
@EntityListeners(AuditingEntityListener.class)
public class Card {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    Long id;

    @Column(name = "card_number", nullable = false)
    String cardNumber;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "owner_id", nullable = false)
    User owner;

    @Column(name = "expiry_date", nullable = false)
    LocalDate expiryDate;

    @Column(name = "type")
    private String type;

    @ColumnDefault("'ACTIVE'")
    @Column(name = "status", nullable = false, length = 20)
    String status;

    @ColumnDefault("0.0")
    @Column(name = "balance", nullable = false, precision = 19, scale = 2)
    BigDecimal balance;

    @ColumnDefault("now()")
    @Column(name = "created_at", nullable = false)
    @CreatedDate
    Instant createdAt;

    @ColumnDefault("now()")
    @Column(name = "updated_at")
    @LastModifiedDate
    Instant updatedAt;

}