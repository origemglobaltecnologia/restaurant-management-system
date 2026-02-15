package tech.origemglobal.restaurant.user.repository;

import tech.origemglobal.restaurant.user.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface UserRepository extends JpaRepository<User, UUID> {
    
    // Método vital para a integração com o auth-service
    Optional<User> findByEmail(String email);
    
    // Verifica se já existe um e-mail cadastrado antes de criar novo usuário
    Boolean existsByEmail(String email);
}
