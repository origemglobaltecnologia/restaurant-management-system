# 🍽️ Restaurant System - Ecossistema de Microsserviços           
Solução robusta de alta escalabilidade para gestão de operações gastronômicas, desenvolvida pela **Origem Global Tecnologia**. O sistema utiliza uma arquitetura de microsserviços para garantir independência e resiliência entre os setores do restaurante.

## 🏗️ Master Plan & Arquitetura
Este projeto segue a arquitetura multicamadas do Spring Boot, focado em:
- **API (Controllers):** Endpoints REST para comunicação.
- **Service Layer:** Regras de negócio centralizadas.
- **Persistence (PostgreSQL):** Modelagem de dados eficiente e independente por serviço com uso obrigatório de **UUID**.

## 🛠️ Tecnologias Principais
- **Linguagem:** Java 21 (LTS)
- **Framework:** Spring Boot 3+ / Spring Cloud
- **Banco de Dados:** PostgreSQL 15+
- **Gestão de Dependências:** Gradle (Daemon desativado para ambiente Termux)
- **Padrão de Pacotes:** `tech.origemglobal.restaurante`

## 📑 Histórico de Decisões (Decision Log)

A rastreabilidade técnica e estratégica deste projeto está documentada através dos links das sessões:

* **Master Plan de Negócios:** [Visão Estratégica e Business Layer](https://g.co/gemini/share/6498271943b7)
* **Master Plan:** [Conceito e Identidade](https://g.co/gemini/share/ad47f12b25e3)
* **Master Plan Infraestrutura:** [Planejamento de Infra](https://g.co/gemini/share/370d435ab8e2)
* **Setup GitHub:** (Sessão Privada) - *Dados sensíveis de identidade e configurações.*
* **Discovery:** [Discovery Server (Eureka)](https://g.co/gemini/share/22490283743b)
* **Regist:** [Config Server (Centralização)](https://g.co/gemini/share/782e1425f28f)
* **Gateway:** [API Gateway (Roteamento)](https://g.co/gemini/share/06c641cbfa59)
* **Auth:** [Auth Service (Segurança JWT)](https://g.co/gemini/share/ca6ea4564470)

## ⚙️ Diretrizes Técnicas (Arquitetura de Comunicação)
* **Service Discovery:** Netflix Eureka (Porta 8761).
* **API Gateway:** Spring Cloud Gateway (Porta 8080) como ponto único de entrada.
* **Resiliência:** Circuit Breaker (Resilience4j) em serviços críticos (Order/Billing).
* **Data Consistency:** Padrão *Database-per-Service*. Auditoria via JPA Auditing (`created_at`/`updated_at`).

## ⚖️ Regras de Ouro (Business Logic)
1. **Imutabilidade:** Pedidos finalizados (`CLOSED`) não podem ser alterados, apenas estornados.
2. **Preços Dinâmicos:** Suporte a múltiplas tabelas (Balcão vs Delivery).
3. **Baixa de Estoque:** Reativa; processada pelo `inventory-service` após evento do `order-service`.

## 📦 Microsserviços e Portas
| Serviço | Porta | Descrição |
| :--- | :--- | :--- |
| **api-gateway** | 8080 | Roteamento e Filtros |
| **auth-service** | 8081 | Identidade e JWT |
| **user-service** | 8082 | Funcionários e Permissões |
| **customer-service**| 8083 | Cadastro de Clientes |
| **menu-service** | 8084 | Cardápios e Preços |
| **order-service** | 8085 | Fluxo de Pedidos |
| **inventory-service**| 8086 | Gestão de Estoque |
| **billing-service** | 8087 | Faturamento e Notas |
| **cashier-service** | 8088 | Fluxo de Caixa |
| **discovery-server**| 8761 | Eureka Server |
| **config-server** | 8888 | Central de Configurações |

## ⚖️ Licença
Este projeto está licenciado sob a [Licença MIT](LICENSE).
