package tech.origemglobal.restaurant.auth.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import java.util.Map;

@FeignClient(name = "user-service", url = "http://localhost:8081")
public interface UserClient {
    @PostMapping("/api/users/internal/search")
    Map<String, Object> findByEmail(@RequestBody Map<String, String> request);
}
