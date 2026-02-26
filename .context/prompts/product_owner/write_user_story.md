---
name: write_user_story
agent: product_owner
variables:
  - idea
  - project_name
---

# Description

Escreva uma User Story completa para a seguinte ideia:

**Ideia:** {{idea}}
**Projeto:** {{project_name}}

## Passos

1. **Identifique a persona** - Quem é o usuário principal?
2. **Defina o valor** - Por que isso é importante para o negócio?
3. **Escreva a story** - Use o formato padrão
4. **Crie critérios de aceite** - Em formato Gherkin
5. **Priorize** - Defina prioridade e estimativa

## Formato Obrigatório

```markdown
## User Story

**Como** [persona]
**Eu quero** [ação]
**Para que** [valor]

## Contexto do Negócio

- **Valor**: [por que é importante]
- **Impacto**: [quem é afetado]

## Critérios de Aceite

### Cenário 1: [nome]
**Dado que** [contexto]
**Quando** [ação]
**Então** [resultado]

## Priorização

- **Prioridade**: [1-4]
- **Estimativa**: [pontos]
```

---

# Expected Output

## User Story Criada

[Título da Story]

### Story
Como [persona], eu quero [ação] para que [valor].

### Critérios
[Cenários em Gherkin]

### Priorização
- Prioridade: [1-4]
- Estimativa: [pontos]
