package kg.manurov.bankmvc.entities;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.Instant;

@Getter
@Setter
@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@Table(name = "card_block_requests")
@EntityListeners(AuditingEntityListener.class)
public class CardBlockRequest {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "card_id", nullable = false)
    private Card card;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "user_id", nullable = false)
    @CreatedBy
    private User user;

    @Column(name = "reason", nullable = false, length = 500)
    private String reason;

    @Column(name = "admin_comment", length = 500)
    private String adminComment;

    @ColumnDefault("now()")
    @Column(name = "created_at", nullable = false)
    @CreatedDate
    private Instant createdAt;

    @LastModifiedDate
    @Column(name = "processed_at")
    private Instant processedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "processed_by_admin_id")
    @LastModifiedBy
    private User processedByAdmin;

    @ColumnDefault("'PENDING'")
    @Column(name = "status")
    private String status;
}