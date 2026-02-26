---
name: analyze_project
agent: scrum_master
variables:
  - team_id
  - project_id
---

# Description

Analise o estado atual do projeto no Linear.

**Team ID:** {{team_id}}
{{#if project_id}}**Project ID:** {{project_id}}{{/if}}

## Passos

1. Liste os projetos do time (se project_id não fornecido)
2. Liste as issues do projeto/time
3. Identifique issues em andamento
4. Identifique bloqueios ou dependências
5. Gere um resumo do estado atual

## O que analisar

- **Issues em progresso**: Quais estão sendo trabalhadas agora?
- **Backlog**: O que está esperando para ser feito?
- **Bloqueios**: Algo está impedindo o progresso?
- **Priorização**: As prioridades fazem sentido?

---

# Expected Output

## Análise do Projeto

### Estado Atual
- **Em progresso**: [lista de issues em andamento]
- **No backlog**: [lista de issues pendentes]
- **Bloqueadas**: [lista de issues bloqueadas e motivo]

### Métricas
- Total de issues abertas: [número]
- Por prioridade:
  - 🔴 Urgente: [número]
  - 🟠 Alta: [número]
  - 🟡 Média: [número]
  - 🟢 Baixa: [número]

### Observações
- **Padrões identificados**: [observações sobre o projeto]
- **Riscos potenciais**: [riscos identificados]
- **Sugestões**: [recomendações de organização]
