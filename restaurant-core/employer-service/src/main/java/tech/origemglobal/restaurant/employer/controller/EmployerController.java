package tech.origemglobal.restaurant.employer.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tech.origemglobal.restaurant.employer.model.Employer;
import tech.origemglobal.restaurant.employer.service.EmployerService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/employers")
@RequiredArgsConstructor
public class EmployerController {

    private final EmployerService service;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Employer create(@Valid @RequestBody Employer employer) {
        return service.save(employer);
    }

    @GetMapping
    public List<Employer> getAll() {
        return service.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Employer> getById(@PathVariable UUID id) {
        return service.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<Employer> getByUserId(@PathVariable UUID userId) {
        return service.findByUserId(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
