# Skill: Documentar Endpoints com Bruno

## Quando Usar
- Novo endpoint criado
- Endpoint existente sem documentação
- Atualizar documentação de API

## Estrutura de Arquivos Bruno

```
.bruno/
├── bruno.json              # Configuração do projeto
├── environments/
│   ├── local.bru           # Variáveis locais
│   ├── staging.bru         # Variáveis staging
│   └── production.bru      # Variáveis produção
└── collections/
    ├── Google/
    │   ├── Campaigns/
    │   │   ├── List.bru
    │   │   ├── Get.bru
    │   │   ├── Create.bru
    │   │   └── Update.bru
    │   └── ProductCenter/
    │       └── ...
    └── Project/
        └── ...
```

## Template de Arquivo .bru

```bru
meta {
  name: Nome do Endpoint
  type: http
  seq: 1
}

get {
  url: {{baseUrl}}/api/project/campaigns
  body: none
  auth: bearer
}

headers {
  Content-Type: application/json
  Accept: application/json
}

auth:bearer {
  token: {{authToken}}
}

docs {
  # Nome do Endpoint

  ## Descrição
  Breve descrição do que o endpoint faz.

  ## Parâmetros

  | Nome | Tipo | Obrigatório | Descrição |
  |------|------|-------------|-----------|
  | id   | int  | Sim         | ID do recurso |

  ## Exemplo de Resposta

  ```json
  {
    "data": {
      "id": 1,
      "name": "Campaign Name"
    }
  }
  ```

  ## Códigos de Status

  | Código | Descrição |
  |--------|-----------|
  | 200    | Sucesso |
  | 400    | Erro de validação |
  | 401    | Não autorizado |
  | 404    | Não encontrado |
  | 500    | Erro interno |
}
```

## Template POST

```bru
meta {
  name: Create Campaign
  type: http
  seq: 3
}

post {
  url: {{baseUrl}}/api/project/campaigns
  body: json
  auth: bearer
}

headers {
  Content-Type: application/json
  Accept: application/json
}

auth:bearer {
  token: {{authToken}}
}

body:json {
  {
    "name": "Nova Campanha",
    "budget": 100.00,
    "status": "active"
  }
}

docs {
  # Create Campaign

  ## Descrição
  Cria uma nova campanha Project.

  ## Body

  ```json
  {
    "name": "string (obrigatório)",
    "budget": "float (obrigatório)",
    "status": "string (opcional, default: draft)"
  }
  ```

  ## Resposta de Sucesso (201)

  ```json
  {
    "data": {
      "id": 1,
      "name": "Nova Campanha",
      "budget": 100.00,
      "status": "active",
      "created_at": "2024-01-01T00:00:00Z"
    }
  }
  ```

  ## Erros

  ### 400 - Validação
  ```json
  {
    "error": "Validation failed",
    "details": {
      "name": ["The name field is required."]
    }
  }
  ```
}
```

## Workflow

### 1. Identificar Endpoint
- Controller e método
- Rota correspondente
- Parâmetros aceitos
- Resposta esperada

### 2. Criar Arquivo .bru
- Seguir estrutura de pastas
- Usar template adequado (GET/POST/PUT/DELETE)
- Preencher todos os campos

### 3. Documentar
- Descrição clara
- Todos os parâmetros
- Exemplos de request/response
- Códigos de status possíveis

### 4. Testar
- Verificar se o arquivo carrega no Bruno
- Testar endpoint com variáveis de ambiente

## Padrões Obrigatórios

### Nomenclatura
- Pasta: PascalCase (`ProductCenter`)
- Arquivo: PascalCase (`GetCampaign.bru`)
- Meta name: Descritivo (`Get Campaign by ID`)

### Documentação
- [ ] Descrição do endpoint
- [ ] Tabela de parâmetros
- [ ] Exemplo de request body (se aplicável)
- [ ] Exemplo de resposta de sucesso
- [ ] Exemplos de erros comuns
- [ ] Códigos de status

### Variáveis
- `{{baseUrl}}`: URL base da API
- `{{authToken}}`: Token de autenticação
- Variáveis específicas no environment

## Exemplo Completo

```bru
meta {
  name: Get Campaign Budget
  type: http
  seq: 2
}

get {
  url: {{baseUrl}}/api/project/campaigns/:campaignId/budget
  body: none
  auth: bearer
}

params:path {
  campaignId: 123
}

headers {
  Content-Type: application/json
  Accept: application/json
}

auth:bearer {
  token: {{authToken}}
}

docs {
  # Get Campaign Budget

  ## Descrição
  Retorna informações de orçamento de uma campanha específica.

  ## Path Parameters

  | Nome | Tipo | Descrição |
  |------|------|-----------|
  | campaignId | int | ID da campanha |

  ## Resposta de Sucesso (200)

  ```json
  {
    "data": {
      "campaign_id": 123,
      "daily_budget": 50.00,
      "total_budget": 1500.00,
      "spent": 450.00,
      "remaining": 1050.00
    }
  }
  ```

  ## Erros

  ### 404 - Campanha não encontrada
  ```json
  {
    "error": "Campaign not found"
  }
  ```

  ### 401 - Não autorizado
  ```json
  {
    "error": "Unauthorized"
  }
  ```
}
```

## Referências
- Bruno Docs: https://docs.usebruno.com/
- API Standards: `.cursor/rules/project.mdc`
