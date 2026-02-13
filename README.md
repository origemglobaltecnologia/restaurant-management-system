# 🍽️ Restaurant System - Ecossistema de Microsserviços

Solução robusta de alta escalabilidade para gestão de operações gastronômicas, desenvolvida pela **Origem Global Tecnologia**. O sistema utiliza uma arquitetura de microsserviços para garantir independência e resiliência entre os setores do restaurante.

## 🏗️ Master Plan & Arquitetura
Este projeto segue a arquitetura multicamadas do Spring Boot, focado em:
- **API (Controllers):** Endpoints REST para comunicação.
- **Service Layer:** Regras de negócio centralizadas.
- **Persistence (PostgreSQL):** Modelagem de dados eficiente e independente por serviço.

## 🛠️ Tecnologias Principais
- **Linguagem:** Java 21 (LTS)
- **Framework:** Spring Boot 3+
- **Banco de Dados:** PostgreSQL
- **Gestão de Dependências:** Maven
- **Padrão de Pacotes:** `tech.origemglobal.restaurante`

## 📑 Histórico de Decisões (Decision Log)

A rastreabilidade técnica deste projeto está documentada através dos links das sessões de arquitetura:

* **Master Plan:** [Conceito e Identidade](https://g.co/gemini/share/ad47f12b25e3)
* **Setup GitHub:** (Sessão Privada) - *Este link contém dados sensíveis de identidade (e-mail/usuário) e configurações de segurança de diretório, por isso permanece restrito para proteção de credenciais da agência.*
* **Discovery:** [Discovery Server (Eureka)](https://g.co/gemini/share/22490283743b)
* **Regist:** [Config Server (Centralização)](https://g.co/gemini/share/782e1425f28f)
* **Gateway:** [API Gateway (Roteamento)](https://g.co/gemini/share/06c641cbfa59)
* **Auth:** [Auth Service (Segurança JWT)](https://g.co/gemini/share/ca6ea4564470)

## 📦 Microsserviços do Sistema
1. **auth-service:** Gestão de identidades e tokens.
2. **customer-service:** Cadastro de clientes.
3. **user-service:** Funcionários e permissões.
4. **menu-service:** Cardápios e preços.
5. **order-service:** Fluxo de pedidos.
6. **inventory-service:** Estoque.
7. **billing-service:** Faturamento.
8. **cashier-service:** Fluxo de caixa.
9. **api-gateway:** Roteamento.
10. **discovery-server:** Eureka Server.
11. **config-server:** Central de configurações.

## ⚖️ Licença
Este projeto está licenciado sob a [Licença MIT](LICENSE).

