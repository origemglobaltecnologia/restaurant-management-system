#!/bin/bash
# Agora apontando para o Gateway (8080) que roteia para o Auth-Service
AUTH_URL="http://localhost:8080/api/auth/login"
EMAIL="gerente@origem.tech"
PASSWORD="admin"

echo "🔐 Tentando autenticação via Gateway na porta 8080..."

RESPONSE=$(curl -s -X POST "$AUTH_URL" \
     -H "Content-Type: application/json" \
     -d "{\"email\":\"$EMAIL\", \"password\":\"$PASSWORD\"}")

if echo "$RESPONSE" | grep -q "token"; then
    echo "$RESPONSE" | jq -r '.token // .accessToken' > .token
    echo "✅ Login realizado via Gateway! Token salvo em .token"
else
    echo "❌ Erro no login via Gateway."
    echo "Resposta do servidor: $RESPONSE"
fi
