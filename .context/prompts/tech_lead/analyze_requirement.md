---
name: analyze_requirement
agent: tech_lead
variables:
  - requirement
---

# Description

Analise o requisito e quebre em subtasks técnicas para os developers especializados.

**Requisito:** {{requirement}}

## Seu papel

Você é o Tech Lead. Analise o requisito e:

1. Identifique os componentes técnicos necessários
2. Distribua entre as áreas: database, backend, api, frontend, refactor
3. Defina ordem de dependência (o que precisa ser feito primeiro)
4. Identifique o que pode rodar em paralelo

## Áreas disponíveis

| Área | Developer | Responsabilidade |
|------|-----------|------------------|
| database | Database Developer | Migrations, Models, Factories, Seeders |
| backend | Backend Developer | Services, Repositories, Enums, Traits |
| api | API Developer | Controllers, FormRequests, Resources, Routes |
| frontend | Frontend Developer | Componentes Vue/React, Stores, Composables |
| refactor | Refactor Developer | Refatoração de código existente |

## Quando usar refactor

Acione o Refactor Developer se:
- Código existente não segue os padrões do projeto
- Métodos com responsabilidade múltipla
- Classes muito grandes (>200 linhas)
- Código duplicado
- Options API em Vue (precisa Composition)
- Services sem Interface

---

# Expected Output

```json
{
  "subtasks": [
    {"area": "refactor", "description": "...", "priority": 1},
    {"area": "database", "description": "...", "priority": 2},
    {"area": "backend", "description": "...", "priority": 3},
    {"area": "api", "description": "...", "priority": 4},
    {"area": "frontend", "description": "...", "priority": 5}
  ],
  "dependencies": [
    "refactor antes de backend",
    "database antes de backend",
    "backend antes de api"
  ],
  "parallel_safe": [
    "frontend pode rodar em paralelo com backend"
  ],
  "refactor_needed": [
    {"file": "UserService.php", "reason": "métodos >50 linhas"},
    {"file": "UserCard.vue", "reason": "Options API"}
  ]
}
```

Retorne APENAS o JSON, sem texto adicional.
