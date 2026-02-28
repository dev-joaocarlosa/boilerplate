# Frontend Developer Skills - Vue 3 & React

> Skills sintetizadas de [antfu/skills](https://github.com/antfu/skills) - Anthony Fu's curated collection.
> 
> Este documento é a referência obrigatória para o **Frontend Developer** do CrewAI.

---

## 🎯 Stack Principal

| Tecnologia | Versão | Uso |
|------------|--------|-----|
| **Vue.js** | 3.5+ | Framework principal |
| **React** | 18+ | Framework alternativo |
| **Pinia** | 3.x | State management (Vue) |
| **Vite** | 8.x | Build tool |
| **TypeScript** | 5.x | Tipagem estática |

---

## 📋 Regras Obrigatórias

### 1. SEMPRE usar Composition API com `<script setup>`

```vue
<!-- ✅ CORRETO -->
<script setup lang="ts">
import { ref, computed } from 'vue'

const count = ref(0)
const doubled = computed(() => count.value * 2)
</script>

<!-- ❌ PROIBIDO - Options API -->
<script>
export default {
  data() { return { count: 0 } }
}
</script>
```

### 2. SEMPRE usar TypeScript

```vue
<script setup lang="ts">
// Props tipadas
const props = defineProps<{
  title: string
  count?: number
}>()

// Emits tipados
const emit = defineEmits<{
  update: [value: string]
  delete: [id: number]
}>()

// v-model tipado
const model = defineModel<string>()
</script>
```

### 3. SEMPRE usar `shallowRef` para performance quando deep reactivity não é necessária

```ts
// ✅ Para objetos grandes ou externos
const data = shallowRef<LargeObject>(null)

// ❌ Evite ref para dados grandes
const data = ref<LargeObject>(null)
```

### 4. NUNCA destruturar reactive() ou props diretamente

```ts
// ❌ PERDE REATIVIDADE
const { name, email } = props
const { count } = reactive({ count: 0 })

// ✅ Use toRefs ou acesse diretamente
const { name, email } = toRefs(props)
// ou
props.name
```

---

## 🧩 Padrões de Componentes Vue

### Template de Componente Padrão

```vue
<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import type { User } from '@/types'

// Props
const props = defineProps<{
  user: User
  editable?: boolean
}>()

// Emits
const emit = defineEmits<{
  save: [user: User]
  cancel: []
}>()

// v-model
const model = defineModel<string>({ default: '' })

// State local
const isLoading = ref(false)
const error = ref<string | null>(null)

// Computed
const fullName = computed(() => `${props.user.firstName} ${props.user.lastName}`)

// Watchers
watch(() => props.user.id, async (newId) => {
  await fetchUserData(newId)
}, { immediate: true })

// Lifecycle
onMounted(() => {
  console.log('Component mounted')
})

// Methods
async function handleSave() {
  isLoading.value = true
  try {
    await saveUser(props.user)
    emit('save', props.user)
  } catch (e) {
    error.value = e.message
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <div class="user-card">
    <h2>{{ fullName }}</h2>
    <input v-model="model" :disabled="!editable" />
    <button @click="handleSave" :disabled="isLoading">
      {{ isLoading ? 'Salvando...' : 'Salvar' }}
    </button>
    <p v-if="error" class="error">{{ error }}</p>
  </div>
</template>

<style scoped>
.user-card { /* ... */ }
.error { color: red; }
</style>
```

### Composables Pattern

```ts
// composables/useUser.ts
import { ref, computed, watch } from 'vue'
import type { User } from '@/types'

export function useUser(userId: MaybeRefOrGetter<string>) {
  const user = ref<User | null>(null)
  const isLoading = ref(false)
  const error = ref<Error | null>(null)

  const fullName = computed(() => 
    user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  )

  async function fetchUser() {
    isLoading.value = true
    error.value = null
    try {
      user.value = await api.getUser(toValue(userId))
    } catch (e) {
      error.value = e as Error
    } finally {
      isLoading.value = false
    }
  }

  // Auto-fetch quando userId mudar
  watch(() => toValue(userId), fetchUser, { immediate: true })

  return {
    user: readonly(user),
    fullName,
    isLoading: readonly(isLoading),
    error: readonly(error),
    refresh: fetchUser,
  }
}
```

---

## 🗄️ Pinia - State Management

### Definição de Store (Setup Store - PREFERIDO)

```ts
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  // State
  const user = ref<User | null>(null)
  const isAuthenticated = ref(false)

  // Getters
  const fullName = computed(() => 
    user.value ? `${user.value.firstName} ${user.value.lastName}` : ''
  )

  // Actions
  async function login(credentials: Credentials) {
    const response = await api.login(credentials)
    user.value = response.user
    isAuthenticated.value = true
  }

  function logout() {
    user.value = null
    isAuthenticated.value = false
  }

  return {
    // State
    user,
    isAuthenticated,
    // Getters
    fullName,
    // Actions
    login,
    logout,
  }
})
```

### Uso em Componentes

```vue
<script setup lang="ts">
import { storeToRefs } from 'pinia'
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()

// ✅ CORRETO - storeToRefs para state/getters
const { user, fullName, isAuthenticated } = storeToRefs(userStore)

// ✅ CORRETO - Actions podem ser desestruturadas diretamente
const { login, logout } = userStore
</script>
```

---

## ⚡ Vite Configuration

### vite.config.ts Padrão

```ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import { resolve } from 'path'

export default defineConfig({
  plugins: [vue()],
  
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@components': resolve(__dirname, 'src/components'),
      '@composables': resolve(__dirname, 'src/composables'),
      '@stores': resolve(__dirname, 'src/stores'),
      '@types': resolve(__dirname, 'src/types'),
    },
  },
  
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true,
      },
    },
  },
  
  build: {
    target: 'esnext',
    outDir: 'dist',
  },
})
```

---

## 🎨 Convenções de Código

### Organização de Arquivos

```
src/
├── components/
│   ├── common/           # Componentes reutilizáveis
│   │   ├── Button.vue
│   │   └── Modal.vue
│   └── features/         # Componentes de features
│       └── UserCard.vue
├── composables/          # Composables/hooks
│   └── useUser.ts
├── stores/               # Pinia stores
│   └── user.ts
├── types/                # TypeScript types
│   └── index.ts
├── utils/                # Utilitários puros
│   └── format.ts
└── constants/            # Constantes
    └── index.ts
```

### Nomenclatura

| Tipo | Convenção | Exemplo |
|------|-----------|---------|
| Componentes | PascalCase | `UserCard.vue` |
| Composables | camelCase com `use` | `useUser.ts` |
| Stores | camelCase com `use` | `useUserStore` |
| Types/Interfaces | PascalCase | `User`, `UserProps` |
| Constantes | UPPER_SNAKE_CASE | `MAX_ITEMS` |

---

## 🚫 Anti-Patterns (NUNCA FAÇA)

### 1. v-if com v-for no mesmo elemento

```vue
<!-- ❌ ERRADO -->
<div v-for="item in items" v-if="item.active">

<!-- ✅ CORRETO - Use computed -->
<div v-for="item in activeItems">
```

### 2. Mutações em computed

```ts
// ❌ ERRADO - Side effects em computed
const filtered = computed(() => {
  items.value.sort() // MUTA o original!
  return items.value.filter(...)
})

// ✅ CORRETO - Crie cópia
const filtered = computed(() => {
  return [...items.value].sort().filter(...)
})
```

### 3. Props mutáveis

```ts
// ❌ ERRADO
props.user.name = 'New Name'

// ✅ CORRETO - Emita evento
emit('update:user', { ...props.user, name: 'New Name' })
```

### 4. Watchers desnecessários

```ts
// ❌ ERRADO - Use computed!
watch(firstName, () => {
  fullName.value = firstName.value + ' ' + lastName.value
})

// ✅ CORRETO
const fullName = computed(() => `${firstName.value} ${lastName.value}`)
```

---

## 🧪 Testes (Vitest)

### Estrutura de Teste

```ts
// UserCard.test.ts
import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import { createTestingPinia } from '@pinia/testing'
import UserCard from './UserCard.vue'

describe('UserCard', () => {
  it('renders user name', () => {
    const wrapper = mount(UserCard, {
      props: {
        user: { firstName: 'John', lastName: 'Doe' }
      },
      global: {
        plugins: [createTestingPinia()]
      }
    })
    
    expect(wrapper.text()).toContain('John Doe')
  })
  
  it('emits save event on button click', async () => {
    const wrapper = mount(UserCard, {
      props: { user: mockUser }
    })
    
    await wrapper.find('button').trigger('click')
    
    expect(wrapper.emitted('save')).toBeTruthy()
  })
})
```

---

## 📦 Imports Essenciais

```ts
// Vue Core
import { 
  ref, shallowRef, computed, reactive, readonly,
  watch, watchEffect, 
  onMounted, onUnmounted,
  toRef, toRefs, toValue,
  nextTick, defineAsyncComponent
} from 'vue'

// Pinia
import { defineStore, storeToRefs } from 'pinia'

// Vue Router
import { useRouter, useRoute } from 'vue-router'

// VueUse (se disponível)
import { useFetch, useLocalStorage, useDebounce } from '@vueuse/core'
```

---

## 🔗 Referências

- [Vue.js Documentation](https://vuejs.org)
- [Pinia Documentation](https://pinia.vuejs.org)
- [Vite Documentation](https://vitejs.dev)
- [VueUse](https://vueuse.org)
- [Anthony Fu's Skills](https://github.com/antfu/skills)
