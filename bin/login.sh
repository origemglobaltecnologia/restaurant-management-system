#!/bin/bash
echo "🚀 Tentando login em http://localhost:8080/api/auth/login..."
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST http://localhost:8080/api/auth/login \
-H "Content-Type: application/json" \
-d '{"email": "origem", "password": "123"}')

BODY=$(echo "$RESPONSE" | head -n 1)
STATUS=$(echo "$RESPONSE" | tail -n 1)

if [ "$STATUS" -eq 200 ]; then
    echo "✅ Sucesso! Token gerado:"
    echo "$BODY" | grep -oP '(?<="token":")[^"]*'
elif [ "$STATUS" -eq 503 ]; then
    echo "❌ Erro 503: O Gateway não encontrou o Auth-Service no Eureka."
    echo "Dica: Verifique http://localhost:8761 e veja se AUTH-SERVICE está na lista."
else
    echo "❌ Erro $STATUS: Verifique as credenciais ou o log do Auth-Service."
    echo "Resposta: $BODY"
fi
