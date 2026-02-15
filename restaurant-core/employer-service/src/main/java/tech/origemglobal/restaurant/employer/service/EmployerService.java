package tech.origemglobal.restaurant.employer.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import tech.origemglobal.restaurant.employer.model.Employer;
import tech.origemglobal.restaurant.employer.repository.EmployerRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class EmployerService {

    private final EmployerRepository repository;

    @Transactional
    public Employer save(Employer employer) {
        return repository.save(employer);
    }

    public List<Employer> findAll() {
        return repository.findAll();
    }

    public Optional<Employer> findById(UUID id) {
        return repository.findById(id);
    }

    public Optional<Employer> findByUserId(UUID userId) {
        return repository.findByUserId(userId);
    }

    @Transactional
    public void delete(UUID id) {
        repository.deleteById(id);
    }
}
