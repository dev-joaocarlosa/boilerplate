---
name: code_review
agent: specialist_reviewer
variables:
  - code_to_review
---

# Description

Realize Code Review estático do código entregue.

**Código para revisão:**
{{code_to_review}}

## Checklist de Validação Laravel/PHP

### 🔴 IMPEDITIVOS (reprovar se encontrar)

- [ ] Imports inline (namespace completo no código)
- [ ] Strings hardcoded que deveriam ser ENUMs
- [ ] `getMessage()` em logs (deve ser exception completa)
- [ ] Dados sensíveis expostos
- [ ] SQL injection ou vulnerabilidades
- [ ] Código sem testes correspondentes
- [ ] Service sem Interface
- [ ] Controller com lógica de negócio

### ⚠️ MELHORIAS (não impeditivos)

- [ ] Métodos > 20 linhas
- [ ] Classes > 200 linhas
- [ ] Falta de early returns
- [ ] PHPDoc incompleto

## Checklist de Validação Vue/React

### 🔴 IMPEDITIVOS (reprovar se encontrar)

- [ ] Options API (deve ser Composition API)
- [ ] JavaScript puro (deve ser TypeScript)
- [ ] Desestruturação de props/reactive
- [ ] Pinia sem `storeToRefs`
- [ ] `v-if` com `v-for` no mesmo elemento
- [ ] Mutação de props

### ⚠️ MELHORIAS (não impeditivos)

- [ ] Poderia usar `shallowRef`
- [ ] Componente muito grande
- [ ] Falta de tipagem explícita

## IMPORTANTE

- Você **NÃO** executa código, apenas análise estática
- Se encontrar **QUALQUER** impeditivo, **REPROVE**
- Seja específico: arquivo, linha, problema, sugestão

---

# Expected Output

## Status: [APROVADO ✅ / REPROVADO ❌]

### Se APROVADO:

#### Pontos Positivos
- [o que está bem feito]

#### Sugestões Opcionais
- [melhorias que podem ser feitas depois]

---

### Se REPROVADO:

#### Problemas Encontrados

| # | Arquivo | Linha | Problema | Como corrigir |
|---|---------|-------|----------|---------------|
| 1 | [arquivo] | [linha] | [problema] | [solução] |
| 2 | [arquivo] | [linha] | [problema] | [solução] |

#### Resumo
O Coder **DEVE** corrigir todos os pontos listados acima antes de nova revisão.
