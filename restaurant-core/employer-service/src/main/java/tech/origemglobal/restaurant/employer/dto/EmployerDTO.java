package tech.origemglobal.restaurant.employer.dto;

import lombok.Data;
import java.util.UUID;

@Data
public class EmployerDTO {
    private String nome;
    private String endereco;
    private String telefone;
    private String observacoes;
    private UUID userId; // Vinculo com o User Service
}
