package kg.manurov.bankmvc.entities;

import jakarta.persistence.*;
import lombok.*;
import lombok.experimental.FieldDefaults;
import org.hibernate.annotations.BatchSize;
import org.hibernate.annotations.ColumnDefault;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.Instant;
import java.util.Collection;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

@Getter
@Setter
@Entity
@Builder
@AllArgsConstructor
@NoArgsConstructor
@FieldDefaults(level = AccessLevel.PRIVATE)
@Table(name = "users")
@EntityListeners(AuditingEntityListener.class)
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(name = "phone_number", nullable = false)
    String phoneNumber;

    @Column(name = "password", nullable = false)
    String password;

    @Column(name = "first_name", nullable = false, length = 100)
    String firstName;

    @Column(name = "middle_name", nullable = false, length = 100)
    String middleName;

    @Column(name = "last_name", nullable = false, length = 100)
    String lastName;

    @ColumnDefault("true")
    @Column(name = "enabled", nullable = false)
    @Builder.Default
    Boolean enabled = true;

    @ColumnDefault("now()")
    @Column(name = "created_at", nullable = false)
    @CreatedDate
    Instant createdAt;

    @ColumnDefault("now()")
    @Column(name = "updated_at")
    @LastModifiedDate
    Instant updatedAt;

    @OneToMany(mappedBy = "owner", fetch = FetchType.LAZY)
    @BatchSize(size = 3)
    @Builder.Default
    Set<Card> cards = new LinkedHashSet<>();

    @ManyToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    Role role;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        if (role == null) {
            throw new AccessDeniedException("У пользователя отсутствует роль в системе!");
        }

        return List.of(new SimpleGrantedAuthority("ROLE_"+role.getName()));
    }

    public String getFullName() {
        return String.format("%s %s %s", lastName, firstName, middleName);
    }

    @Override
    public String getPassword() {
        return this.password;
    }

    @Override
    public String getUsername() {
        return this.phoneNumber;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return this.enabled;
    }
}