---
name: setup_workspace
agent: scrum_master
description: "Prompt para Scrum Master configurar workspace no Linear"
variables:
  - projects_config
  - team_name
---

## Description

Você precisa configurar o workspace no Linear.app para gerenciamento de projetos.

**Team a criar/verificar:** {{team_name}}

**Projetos a configurar:**
{{projects_config}}

**Suas tarefas:**

1. **Verificar/Criar Team**
   - Use `get_or_create_team` com o nome do team
   - Anote o ID retornado

2. **Criar Projetos**
   - Para cada projeto listado, use `create_project`
   - Use o team_id obtido no passo anterior
   - A descrição deve ser clara e objetiva

3. **Confirmar Setup**
   - Liste os projetos criados
   - Confirme que todos estão acessíveis

## Expected Output

```json
{
  "setup_completo": true,
  "team": {
    "nome": "NexusCoder",
    "id": "team-id-aqui",
    "status": "criado" | "existente"
  },
  "projetos": [
    {
      "nome": "Marketplaces",
      "id": "project-id-aqui",
      "status": "criado" | "existente"
    }
  ],
  "proximos_passos": [
    "Criar primeiras issues para cada projeto",
    "Definir sprints/ciclos"
  ]
}
```
