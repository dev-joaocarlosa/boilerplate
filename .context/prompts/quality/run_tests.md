---
name: run_tests
agent: qa_engineer
variables:
  - code_to_test
  - test_type
---

# Description

Execute testes dinâmicos no código entregue.

**Código para testar:**
{{code_to_test}}

{{#if test_type}}**Tipo de teste:** {{test_type}}{{/if}}

## Seu Papel

Você é o QA Engineer. Execute os testes e valide que o código funciona corretamente.

## ⚠️ AMBIENTE DOCKER

**TODOS os comandos devem ser executados via Docker:**

```bash
# Testes PHP/Laravel
docker compose exec app php artisan test
docker compose exec app ./vendor/bin/phpunit

# Testes específicos
docker compose exec app php artisan test --filter=NomeDoTeste

# Testes Frontend
docker compose exec node npm run test
docker compose exec node npm run test:unit
```

**NUNCA** execute comandos PHP diretamente no host.

## O que testar

### Backend (PHP/Laravel)
1. Testes unitários existentes passam
2. Testes de integração se houver
3. Validações de FormRequest
4. Comportamento de Services

### Frontend (Vue/React)
1. Testes de componentes
2. Testes de composables/hooks
3. Testes de stores

## Processo

1. Identifique os testes relevantes para o código
2. Execute os testes via Docker
3. Analise os resultados
4. Se falhar, capture o traceback completo
5. Reporte o resultado

---

# Expected Output

## Status: [PASSOU ✅ / FALHOU ❌]

### Se PASSOU:

#### Testes Executados
```
[output do comando de teste]
```

#### Resumo
- Total de testes: [número]
- Passou: [número]
- Tempo: [tempo]

#### Cobertura (se disponível)
- [métricas de cobertura]

---

### Se FALHOU:

#### Testes Executados
```
[output do comando de teste]
```

#### Falhas Encontradas

| Teste | Erro | Arquivo | Linha |
|-------|------|---------|-------|
| [nome] | [erro] | [arquivo] | [linha] |

#### Traceback Completo
```
[traceback do erro]
```

#### Resumo
O código **DEVE** ser corrigido pelo Developer. Os erros acima indicam:
- [explicação do que precisa ser corrigido]
