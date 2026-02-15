package tech.origemglobal.restaurant.employer.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.UUID;

@Data
public class EmployerRequest {
    @NotBlank
    private String nome;
    @NotBlank
    private String endereco;
    @NotBlank
    private String telefone;
    private String observacoes;
    @NotNull
    private UUID userId;
}
