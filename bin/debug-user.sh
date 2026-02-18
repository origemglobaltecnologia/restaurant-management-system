#!/bin/bash
LOG_FILE="~/restaurant-management-system/logs/user-service.log"
TOKEN=$(cat ~/restaurant-management-system/bin/.token)

echo "🔍 Monitorando logs do User-Service... (Pressione Ctrl+C para parar)"
echo "🚀 Enviando requisição de teste..."

# Faz a chamada em background e mostra o log em tempo real
curl -4 -s -H "Authorization: Bearer $TOKEN" http://localhost:8080/user-service/api/users/me > /dev/null &

tail -f ~/restaurant-management-system/logs/user-service.log | grep -iE "auth|security|denied|token"
