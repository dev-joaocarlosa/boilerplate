---
name: create_task
agent: scrum_master
variables:
  - idea
  - team_id
  - project_id
  - project_name
---

# Description

Crie uma task bem estruturada no Linear usando o padrão **User Story** para a seguinte ideia:

**Ideia:** {{idea}}
**Team ID:** {{team_id}}
{{#if project_id}}**Project ID:** {{project_id}}{{/if}}
{{#if project_name}}**Projeto:** {{project_name}}{{/if}}

## Passos

1. Analise a ideia e identifique:
   - **Quem** é o usuário/persona (admin, cliente, vendedor, sistema, etc)
   - **O que** ele quer fazer (a funcionalidade)
   - **Por que** ele quer fazer (o valor/benefício)
2. Identifique o tipo: FEATURE, BUG, REFACTOR, DOCS, TEST, CHORE
3. Defina prioridade (1-4) baseado no impacto
4. Estime complexidade em pontos (1, 2, 3, 5, 8)
5. Escreva critérios de aceite no formato **Gherkin** (Dado/Quando/Então)
6. Crie a task no Linear

Se a ideia for muito grande (>8 pontos), quebre em múltiplas User Stories.

## Formato da Descrição (OBRIGATÓRIO)

```markdown
## User Story

**Como** [usuário/persona]
**Eu quero** [funcionalidade/ação desejada]
**Para que** [benefício ou valor gerado]

## Critérios de Aceite

### Cenário 1: [nome do cenário]
**Dado que** [contexto inicial]
**Quando** [ação realizada]
**Então** [resultado esperado]

### Cenário 2: [nome do cenário]
**Dado que** [contexto inicial]
**Quando** [ação realizada]
**Então** [resultado esperado]

## Notas Técnicas
Informações relevantes para o desenvolvedor (APIs, libs, etc).

## Definition of Done
- [ ] Código implementado
- [ ] Testes passando
- [ ] Code review aprovado
- [ ] Documentação atualizada (se aplicável)
```

---

# Expected Output

## Task Criada

- **ID**: [Linear identifier]
- **Título**: [TIPO] Descrição clara
- **Prioridade**: [1-4]
- **Estimativa**: [pontos]
- **URL**: [link]

### User Story
Como [persona], eu quero [funcionalidade] para que [valor].

### Critérios de Aceite
[cenários em formato Gherkin]

### Sub-tasks (se houver)
[lista de sub-tasks criadas para ideias muito grandes]
