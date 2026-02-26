---
name: manage_backlog
agent: scrum_master
variables:
  - team_id
  - project_id
---

# Description

Organize e priorize o backlog do projeto no Linear.

**Team ID:** {{team_id}}
{{#if project_id}}**Project ID:** {{project_id}}{{/if}}

## Passos

1. Liste todas as issues do projeto
2. Analise prioridades atuais
3. Identifique issues mal priorizadas
4. Sugira reordenação
5. Identifique issues que precisam de mais detalhes

## Critérios de Priorização

- **Impacto no usuário/negócio**: Quantos usuários são afetados?
- **Urgência/deadline**: Tem prazo definido?
- **Dependências técnicas**: Bloqueia outras tasks?
- **Complexidade vs valor**: Vale o esforço?

## Regras de Prioridade

| Prioridade | Quando usar |
|------------|-------------|
| 1 (Urgente) | Bloqueio em produção, segurança, perda de receita |
| 2 (Alta) | Feature crítica para cliente, bug impactante |
| 3 (Média) | Feature normal, melhoria de UX |
| 4 (Baixa) | Nice-to-have, refactoring, documentação |

---

# Expected Output

## Análise do Backlog

### Issues por Prioridade Atual
- 🔴 **Urgente**: [lista]
- 🟠 **Alta**: [lista]
- 🟡 **Média**: [lista]
- 🟢 **Baixa**: [lista]

### Recomendações de Mudança

#### Devem SUBIR de prioridade:
| Issue | De | Para | Justificativa |
|-------|-----|------|---------------|
| [issue] | [atual] | [nova] | [motivo] |

#### Devem DESCER de prioridade:
| Issue | De | Para | Justificativa |
|-------|-----|------|---------------|
| [issue] | [atual] | [nova] | [motivo] |

### Issues que Precisam de Mais Detalhes
- [issue]: falta [o que falta]

### Ações Sugeridas
1. [ação 1]
2. [ação 2]
