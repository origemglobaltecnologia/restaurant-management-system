package tech.origemglobal.restaurant.user.dto;

import java.util.UUID;

public record UserResponseDTO(
    UUID id, 
    String email, 
    String role, 
    Boolean isActive
) {}
