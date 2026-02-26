---
name: implement_api
agent: api_developer
variables:
  - requirement
  - feedback
---

# Description

Implemente os endpoints da API para o requisito.

**Contexto:** {{requirement}}

{{#if feedback}}
## Feedback de Correção
{{feedback}}
{{/if}}

## Sua Responsabilidade (API)

1. Definir rotas em api.php
2. Criar Controller(s)
3. Criar FormRequest(s) para validação
4. Criar Resource(s) para response

## Padrões Obrigatórios

- Controller retorna JsonResponse
- Controller magro (delega para Service)
- FormRequest para TODA validação de input
- Resource para TODA transformação de output
- Rotas agrupadas com prefixo e middleware

## Exemplo de Controller

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreUserRequest;
use App\Http\Resources\UserResource;
use App\Facades\UserFacade;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    public function store(StoreUserRequest $request): JsonResponse
    {
        $user = UserFacade::create($request->validated());
        
        return response()->json([
            'success' => true,
            'data' => new UserResource($user),
        ], 201);
    }
    
    public function index(): JsonResponse
    {
        $users = UserFacade::list();
        
        return response()->json([
            'success' => true,
            'data' => UserResource::collection($users),
        ]);
    }
}
```

## Exemplo de FormRequest

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreUserRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }
    
    public function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users'],
        ];
    }
}
```

## Você NÃO mexe em:
- Services (área do Backend Developer)
- Migrations (área do Database Developer)
- Frontend (área do Frontend Developer)

---

# Expected Output

## API Implementada

### Rotas:
```
[METHOD] /api/[path] - [descrição]
```

### Controller:
- [Controller.php]

### FormRequests:
- [Request.php] - validações: [lista]

### Resources:
- [Resource.php]

### Pronto para o Frontend consumir ✅
