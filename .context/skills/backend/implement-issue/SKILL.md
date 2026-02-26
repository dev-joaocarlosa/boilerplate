# Skill: Implementar Issue Completa

## Quando Usar
- Nova funcionalidade end-to-end (Controller → Service → Repository)
- Implementação completa de uma issue/tarefa
- Criação de endpoint novo com toda a stack

## Conceito

Esta skill é um **orquestrador** que coordena a execução de outras skills especializadas.
**NÃO** contém templates de código - cada etapa deve:
1. Ler a skill correspondente
2. Buscar código de referência no projeto
3. Seguir o padrão encontrado

## Regras Obrigatórias

> **CRÍTICO**: Leia `rules/patterns/services.mdc` e `rules/patterns/repositories.mdc` antes de começar.

### Regras Inline (Memorizar)

| Regra | Descrição |
|-------|-----------|
| ClientException | APENAS `throw $e;` no catch (log já na origem) |
| Exception genérica | Mensagem via Enum, NUNCA hardcoded |
| SELECT | NUNCA `SELECT *`, especificar colunas |
| Existência | NUNCA `count()`, usar `exists()` |
| Métodos privados | NUNCA chamar outros privados (evitar cascata) |

## Workflow de Implementação

### Ordem de Criação (SEGUIR RIGOROSAMENTE)

```
STEP 1  → Enum (mensagens de erro)
STEP 2  → Entity (estrutura de dados)
STEP 3  → Repository Interface + Implementação
STEP 4  → Service Interface + Implementação + Facade
STEP 5  → Controller
STEP 6  → Rota
STEP 7  → Bindings no ServiceProvider
STEP 8  → Validação e Commit
```

> ⚠️ **IMPORTANTE**: NÃO criar testes unitários automaticamente.
> Testes só devem ser criados quando **explicitamente solicitados** pelo usuário.

---

## STEP 1: Enum de Mensagens de Erro

### Ações Obrigatórias

1. **Ler skill**: `.cursor/skills/create-enum/SKILL.md`
2. **Buscar referência**: 
   ```
   Glob: app/Enums/**/*ErrorMessageEnum.php
   Ler um arquivo como referência do padrão atual
   ```
3. **Criar arquivo**: `app/Enums/{Namespace}/{Nome}ErrorMessageEnum.php`

---

## STEP 2: Entity

### Ações Obrigatórias

1. **Ler skill**: `.cursor/skills/create-entity/SKILL.md`
2. **Buscar referência**:
   ```
   Glob: app/Entities/**/*Entity.php
   Ler um arquivo similar como referência
   ```
3. **Criar arquivo**: `app/Entities/{Namespace}/{Nome}Entity.php`

---

## STEP 3: Repository

### Ações Obrigatórias

1. **Ler skill**: `.cursor/skills/create-repository/SKILL.md`
2. **Ler rule de performance**: `rules/patterns/repositories.mdc`
3. **Buscar referência Interface**:
   ```
   Glob: app/Contracts/Repositories/**/*RepositoryInterface.php
   ```
4. **Buscar referência Implementação**:
   ```
   Glob: app/Repositories/**/*Repository.php (excluir DbRepository, ApiRepository)
   ```
5. **Criar arquivos**:
   - `app/Contracts/Repositories/{Namespace}/{Nome}RepositoryInterface.php`
   - `app/Repositories/{Namespace}/{Nome}Repository.php`

### Checklist do Step
- [ ] Interface com PHPDoc completo
- [ ] Implementação com `@inheritDoc`
- [ ] Colunas especificadas (não SELECT *)
- [ ] Métodos usando `exists()` ao invés de `count()`

---

## STEP 4: Service + Facade

### Ações Obrigatórias

1. **Ler skill**: `.cursor/skills/create-service/SKILL.md`
2. **Ler rules**: `rules/patterns/services.mdc`
3. **Buscar referência Interface**:
   ```
   Glob: app/Contracts/Services/**/*ServiceInterface.php
   ```
4. **Buscar referência Service**:
   ```
   Glob: app/Services/**/*Service.php
   Escolher um service similar ao que será criado
   ```
5. **Buscar referência Facade**:
   ```
   Glob: app/Facades/**/*Service.php
   ```
6. **Criar arquivos**:
   - `app/Contracts/Services/{Namespace}/{Nome}ServiceInterface.php`
   - `app/Services/{Namespace}/{Nome}Service.php`
   - `app/Facades/{Namespace}/{Nome}Service.php`

### Checklist do Step
- [ ] Interface com PHPDoc completo dos métodos
- [ ] Service com `@inheritDoc`
- [ ] Try/catch APENAS no método público
- [ ] ClientException: apenas `throw $e;` (sem log no catch)
- [ ] Exception genérica: usa Enum
- [ ] Métodos privados não chamam outros privados
- [ ] Facade com `@method static` para cada método

---

## STEP 5: Controller

### Ações Obrigatórias

1. **Buscar referência**:
   ```
   Glob: app/Http/Controllers/**/*Controller.php
   Escolher um controller similar
   ```
2. **Criar arquivo**: `app/Http/Controllers/{Namespace}/{Nome}Controller.php`

### Padrão de Dispatch
```php
// Com retorno (200)
return $this->getResponse()->dispatch(function () {
    return Service::method();
});

// Sem retorno (204)
return $this->getResponse()->dispatch(function () {
    Service::method();
}, Response::HTTP_NO_CONTENT);

// Com criação (201)
return $this->getResponse()->dispatch(function () {
    return Service::create($this->getPostAttributes());
}, Response::HTTP_CREATED);
```

---

## STEP 6: Rota

### Ações Obrigatórias

1. **Ler arquivo**: `routes/api.php`
2. **Identificar grupo** apropriado ou criar novo
3. **Adicionar rotas** seguindo padrão existente

### Padrão
```php
Route::group(['prefix' => '{prefixo}'], function () {
    Route::get('/', '{Namespace}\{Nome}Controller@index');
    Route::get('/{id}', '{Namespace}\{Nome}Controller@show');
    Route::post('/', '{Namespace}\{Nome}Controller@store');
    Route::put('/{id}', '{Namespace}\{Nome}Controller@update');
    Route::delete('/{id}', '{Namespace}\{Nome}Controller@destroy');
});
```

---

## STEP 7: Bindings no ServiceProvider

### Ações Obrigatórias

1. **Ler arquivo**: `app/Providers/AppServiceProvider.php`
2. **Identificar seção** de bindings
3. **Adicionar bindings** para Service e Repository

### Padrão
```php
// No método register()

// {Nome} Service
$this->app->bind(
    {Nome}ServiceInterface::class,
    {Nome}Service::class
);

// {Nome} Repository  
$this->app->bind(
    {Nome}RepositoryInterface::class,
    {Nome}Repository::class
);
```

---

## STEP 8: Validação e Commit

### Ações Obrigatórias

1. **Executar validações**:
   ```bash
   ./vendor/bin/pint --test
   ./vendor/bin/phpstan analyse
   ```

2. **Corrigir erros** se houver

3. **Ler skill de commit**: `.cursor/skills/create-commit/SKILL.md`

4. **Criar commit** com mensagem descritiva

---

## Checklist Final

### Arquivos Criados
- [ ] `app/Enums/{Namespace}/{Nome}ErrorMessageEnum.php`
- [ ] `app/Entities/{Namespace}/{Nome}Entity.php`
- [ ] `app/Contracts/Repositories/{Namespace}/{Nome}RepositoryInterface.php`
- [ ] `app/Repositories/{Namespace}/{Nome}Repository.php`
- [ ] `app/Contracts/Services/{Namespace}/{Nome}ServiceInterface.php`
- [ ] `app/Services/{Namespace}/{Nome}Service.php`
- [ ] `app/Facades/{Namespace}/{Nome}Service.php`
- [ ] `app/Http/Controllers/{Namespace}/{Nome}Controller.php`

### Configurações
- [ ] Rota adicionada em `routes/api.php`
- [ ] Bindings em `AppServiceProvider::register()`

### Validações
- [ ] Lint sem erros
- [ ] Commit criado

---

## Testes Unitários (OPCIONAL)

> ⚠️ **NÃO CRIAR TESTES AUTOMATICAMENTE**
> 
> Testes unitários só devem ser criados quando o usuário **solicitar explicitamente**.
> 
> Se solicitado, usar a skill: `.cursor/skills/create-unit-test/SKILL.md`

---

## Skills Utilizadas

| Step | Skill | Rule |
|------|-------|------|
| 1 | `create-enum/SKILL.md` | - |
| 2 | `create-entity/SKILL.md` | - |
| 3 | `create-repository/SKILL.md` | `patterns/repositories.mdc` |
| 4 | `create-service/SKILL.md` | `patterns/services.mdc` |
| 5 | - | `patterns/controllers.mdc` |
| 6 | - | - |
| 7 | - | - |
| 8 | `create-commit/SKILL.md` | - |
| ⚠️ | `create-unit-test/SKILL.md` | `testing/index.mdc` (APENAS SE SOLICITADO) |

---

## Fluxo Resumido

```
┌─────────────────────────────────────────────────────────────┐
│  PARA CADA STEP:                                            │
│                                                             │
│  1. Ler a skill correspondente (se houver)                  │
│  2. Ler a rule correspondente (se houver)                   │
│  3. Buscar código de referência no projeto (Glob + Read)    │
│  4. Criar o código seguindo o padrão encontrado             │
│  5. Verificar checklist do step                             │
│  6. Avançar para próximo step                               │
└─────────────────────────────────────────────────────────────┘
```
