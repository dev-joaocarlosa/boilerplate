---
name: implement_frontend
agent: frontend_developer
variables:
  - requirement
  - feedback
---

# Description

Implemente a interface do usuário para o requisito.

**Contexto:** {{requirement}}

{{#if feedback}}
## Feedback de Correção
{{feedback}}
{{/if}}

## Sua Responsabilidade (FRONTEND)

1. Criar componentes Vue 3 ou React
2. Integrar com a API
3. Gerenciar estado (se necessário)
4. Implementar UX adequada

## Padrões Vue 3 (Obrigatórios)

- **Composition API** com `<script setup lang="ts">`
- **TypeScript** obrigatório
- Composables para lógica reutilizável
- Pinia para state management (com `storeToRefs`)
- `shallowRef` para objetos grandes

## Padrões React (Obrigatórios)

- Functional components apenas
- Hooks para lógica (useState, useEffect, custom)
- Props tipadas com TypeScript

## Exemplo Vue 3 correto

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'

// Props tipadas
interface Props {
  userId: number
}
const props = defineProps<Props>()

// Emits tipados
const emit = defineEmits<{
  (e: 'update', value: string): void
}>()

// Store com storeToRefs
const userStore = useUserStore()
const { users, loading } = storeToRefs(userStore)

// Estado local
const search = ref('')

// Computed
const filteredUsers = computed(() => 
  users.value.filter(u => u.name.includes(search.value))
)
</script>

<template>
  <div>
    <input v-model="search" placeholder="Buscar..." />
    <ul v-if="!loading">
      <li v-for="user in filteredUsers" :key="user.id">
        {{ user.name }}
      </li>
    </ul>
  </div>
</template>
```

## Anti-patterns (NUNCA usar)

- ❌ Options API
- ❌ JavaScript puro (sempre TypeScript)
- ❌ Desestruturar props/reactive diretamente
- ❌ Pinia sem `storeToRefs`
- ❌ `v-if` com `v-for` no mesmo elemento
- ❌ Mutar props diretamente

## Você NÃO mexe em:
- PHP / Backend
- Banco de dados

---

# Expected Output

## Frontend Implementado

### Componentes:
- [Componente.vue] - [descrição]

### Composables (se houver):
- [useXxx.ts] - [descrição]

### Stores (se houver):
- [xxxStore.ts] - [descrição]

### Integração com API:
- [endpoints consumidos]

### Interface utilizável ✅
