---
name: implement_backend
agent: backend_developer
variables:
  - requirement
  - feedback
---

# Description

Implemente a lógica de negócio para o requisito.

**Contexto:** {{requirement}}

{{#if feedback}}
## Feedback de Correção
{{feedback}}
{{/if}}

## Sua Responsabilidade (BACKEND)

1. Criar Interface do Service
2. Implementar Service
3. Atualizar/criar Facade com @method
4. Criar Enums necessários
5. Criar Repository se precisar de queries complexas

## Padrões Obrigatórios

- Service SEMPRE implementa Interface
- Facade com PHPDoc @method para cada método público
- Logs com exception completa (não getMessage())
- Injeção de dependências
- PHPDoc em métodos públicos

## Exemplo de Interface

```php
<?php

namespace App\Services\Interfaces;

use App\Models\User;
use Illuminate\Support\Collection;

interface UserServiceInterface
{
    /**
     * Cria um novo usuário.
     *
     * @param array $data Dados do usuário
     * @return User
     * @throws \Exception
     */
    public function create(array $data): User;
    
    /**
     * Lista usuários com filtros.
     *
     * @param array $filters
     * @return Collection<User>
     */
    public function list(array $filters = []): Collection;
}
```

## Exemplo de Facade

```php
<?php

namespace App\Facades;

use Illuminate\Support\Facades\Facade;
use App\Services\Interfaces\UserServiceInterface;

/**
 * @method static \App\Models\User create(array $data)
 * @method static \Illuminate\Support\Collection list(array $filters = [])
 * 
 * @see \App\Services\UserService
 */
class UserFacade extends Facade
{
    protected static function getFacadeAccessor(): string
    {
        return UserServiceInterface::class;
    }
}
```

## Você NÃO mexe em:
- Controllers (área do API Developer)
- Migrations (área do Database Developer)
- Frontend (área do Frontend Developer)

---

# Expected Output

## Lógica de Negócio Implementada

### Interface:
- [ServiceInterface.php]

### Service:
- [Service.php] - implementa [Interface]

### Facade:
- [Facade.php] - @method documentados

### Enums (se houver):
- [Enum.php]

### Pronto para o API Developer expor ✅
