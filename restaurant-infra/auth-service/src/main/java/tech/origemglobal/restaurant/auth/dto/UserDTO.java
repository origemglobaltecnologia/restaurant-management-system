package tech.origemglobal.restaurant.auth.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
    private String email;
    private String password; // Hash vindo do banco do user-service
    private String role;     // Ex: ROLE_USER, ROLE_ADMIN
}
