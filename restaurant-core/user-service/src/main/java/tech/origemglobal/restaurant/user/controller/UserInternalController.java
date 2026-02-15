package tech.origemglobal.restaurant.user.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tech.origemglobal.restaurant.user.repository.UserRepository;

import java.util.Map;

@RestController
@RequestMapping("/api/users/internal")
@RequiredArgsConstructor
public class UserInternalController {

    private final UserRepository userRepository;

    @PostMapping("/search")
    public ResponseEntity<?> findByEmailInternal(@RequestBody Map<String, String> request) {
        return userRepository.findByEmail(request.get("email"))
            .map(user -> ResponseEntity.ok(Map.of(
                "email", user.getEmail(),
                "password", user.getPassword(), 
                "role", user.getRole()
            )))
            .orElse(ResponseEntity.notFound().build());
    }
}
