---
name: refactor_code
agent: refactor_developer
variables:
  - files_to_refactor
  - refactor_reasons
---

# Description

Refatore o código identificado pelo Tech Lead como problemático.

**Arquivo(s) para refatorar:**
{{files_to_refactor}}

**Problemas identificados:**
{{refactor_reasons}}

## Técnicas a Aplicar

### 1. Extract Method (Métodos grandes)
Identificar responsabilidades distintas e extrair para métodos privados.

```php
// ANTES: método faz 3 coisas
public function process($data) {
    // validação + transformação + persistência
}

// DEPOIS: método orquestra
public function process($data) {
    $this->validateData($data);
    $payload = $this->transformData($data);
    return $this->persistData($payload);
}
```

### 2. Extract Interface (Services sem contrato)

```php
// ANTES
class UserService { }

// DEPOIS
interface UserServiceInterface { }
class UserService implements UserServiceInterface { }
```

### 3. Replace Magic String with Enum

```php
// ANTES
if ($status === 'active') { }

// DEPOIS
if ($status === StatusEnum::ACTIVE->value) { }
```

### 4. Convert Options to Composition API (Vue)

```vue
// ANTES - Options API
export default {
  data() { return { count: 0 } }
}

// DEPOIS - Composition API
<script setup lang="ts">
const count = ref(0)
</script>
```

### 5. Extract Composable (Vue)

```typescript
// Antes: lógica repetida em componentes
// Depois: composable reutilizável
export function useSearch() {
  const query = ref('')
  const results = ref([])
  // ...
  return { query, results }
}
```

## Regras de Refatoração

- ❌ **NÃO** alterar comportamento externo
- ❌ **NÃO** adicionar features
- ❌ **NÃO** remover funcionalidades
- ✅ Manter testes passando
- ✅ Commits pequenos e incrementais
- ✅ Uma técnica por vez

## IMPORTANTE

Se não existem testes para o código, **CRIAR TESTES PRIMEIRO** antes de refatorar.

⚠️ **AMBIENTE DOCKER** - Comandos via:
```bash
docker compose exec app php artisan test
docker compose exec app ./vendor/bin/phpunit
```

---

# Expected Output

## Refatoração Realizada

### Arquivos modificados:
| Arquivo | Técnica aplicada |
|---------|------------------|
| [arquivo] | [técnica] |

### Antes/Depois:

#### [Arquivo 1]
**Antes:**
```
[código original]
```

**Depois:**
```
[código refatorado]
```

### Testes:
- Status: [PASSANDO ✅ / CRIADOS ✅]
- Testes criados (se necessário): [lista]

### Comportamento:
- ✅ Comportamento externo não alterado
- ✅ APIs públicas mantidas
- ✅ Testes passando
