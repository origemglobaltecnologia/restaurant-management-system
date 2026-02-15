package tech.origemglobal.restaurant.auth.service;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import tech.origemglobal.restaurant.auth.client.UserClient;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class AuthService {
    private final UserClient userClient;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public String executeLogin(String email, String password) {
        try {
            var response = userClient.findByEmail(Map.of("email", email));
            
            if (response == null || !response.containsKey("password")) {
                throw new RuntimeException("Credenciais invalidas ou usuario nao encontrado");
            }

            String encodedPassword = String.valueOf(response.get("password"));
            String role = response.containsKey("role") ? String.valueOf(response.get("role")) : "USER";

            if (!passwordEncoder.matches(password, encodedPassword)) {
                throw new RuntimeException("Senha incorreta");
            }

            return jwtService.generateToken(email, role);
        } catch (Exception e) {
            System.err.println("DETALHE DO ERRO: " + e.getMessage());
            throw new RuntimeException("Falha na autenticacao: " + e.getMessage());
        }
    }
}
