---
name: write-prd
description: Formato base obrigatório a ser seguido para qualquer Product Requirement Document ser persistido em código e entendível pelos bots de engenharia. Utilizada tipicamente pelo product-owner agent.
user-invocable: true
allowed-tools: Write
---

# Output Formato (OBRIGATÓRIO)

Para qualquer PRD escrito, copie e preencha este template EXATAMENTE como no bloco markdown a seguir:

```markdown
---
id: {{prd_id}}
title: TITULO CURTO
status: backlog
priority: NUMERO 1-4
estimate: NUMERO 1-8
project: {{project_name}}
created: DATA
updated: DATA
assignee: null
---

## Visao
FRASE CURTA

## User Story
**Como** PERSONA
**Eu quero** ACAO
**Para que** VALOR

## Requisitos Funcionais
- **RF1**: descricao
- **RF2**: descricao
- **RF3**: descricao

## Requisitos Nao-Funcionais
- **RNF1**: descricao
- **RNF2**: descricao

## Criterios de Aceite
### Cenario 1: NOME
**Dado que** CONTEXTO
**Quando** ACAO
**Entao** RESULTADO

### Cenario 2: NOME
**Dado que** CONTEXTO
**Quando** ACAO
**Entao** RESULTADO

## Checklist QA
- [ ] item 1
- [ ] item 2
- [ ] item 3

## Informacoes Tecnicas
### Dependencias
- dependencia 1

### Consideracoes
- nota tecnica

## Priorizacao
- **Prioridade**: NUMERO
- **Estimativa**: NUMERO
- **Justificativa**: TEXTO
```
