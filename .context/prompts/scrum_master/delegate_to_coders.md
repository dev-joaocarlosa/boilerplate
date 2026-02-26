---
name: delegate_to_coders
agent: scrum_master
variables:
  - issue_id
  - issue_title
  - issue_description
  - project_stack
---

# Description

Analise a issue e delegue para o(s) developer(s) correto(s):

**Issue:** {{issue_id}} - {{issue_title}}
**Stack:** {{project_stack}}

**Descrição:**
{{issue_description}}

## Desenvolvedores Disponíveis

| Developer | Stack | Responsabilidade |
|-----------|-------|------------------|
| Database Developer | Backend | Migrations, Models, Factories |
| Backend Developer | Backend | Services, Repositories, Enums |
| API Developer | Backend | Controllers, FormRequests, Routes |
| Frontend Developer | Frontend | Componentes Vue/React, Stores |
| Refactor Developer | Ambos | Refatoração de código |

## Critérios de Delegação

1. **Backend apenas**: Backend Developer + API Developer
2. **Frontend apenas**: Frontend Developer
3. **Fullstack**: Backend + API + Frontend
4. **Refatoração**: Refactor Developer
5. **Banco de dados**: Database Developer

## Formato de Saída

```json
{
  "issue_id": "{{issue_id}}",
  "delegation": [
    {
      "developer": "backend_developer",
      "task": "Descrição específica da tarefa",
      "priority": 1
    },
    {
      "developer": "api_developer",
      "task": "Descrição específica da tarefa",
      "priority": 2
    }
  ],
  "dependencies": [
    "backend_developer deve terminar antes de api_developer"
  ],
  "can_parallel": false
}
```

---

# Expected Output

## Delegação Definida

### Issue
- **ID**: {{issue_id}}
- **Título**: {{issue_title}}

### Developers Assignados
[Lista de developers com suas tasks]

### Ordem de Execução
[Sequência ou paralelismo]

### Dependências
[Dependencies identificadas]
