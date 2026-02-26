---
name: implement_feature
agent: specialist_developer
variables:
  - requirement
  - feedback
---

# Description

Desenvolva a funcionalidade seguindo os padrões Laravel/PHP.

**Requisito:** {{requirement}}

{{#if feedback}}
## Feedback de Correção
{{feedback}}

**IMPORTANTE:** Corrija TODOS os pontos apontados pelo Reviewer ou QA.
{{/if}}

## Instruções

1. Analise o requisito (ou feedback de correção se houver)
2. Implemente seguindo os padrões Laravel/PHP do projeto
3. Crie/atualize os arquivos necessários
4. Garanta que o código está pronto para review

## Padrões Laravel Obrigatórios

- Services para lógica de negócio (implementando Interface)
- Repositories para acesso a dados
- FormRequests para validação
- Resources para transformação de dados
- Enums para status e constantes
- PHPDoc completo em interfaces
- Imports no topo (nunca namespace inline)
- Logs com contexto completo (exception, não getMessage)

## Exemplo de Service correto

```php
<?php

namespace App\Services;

use App\Services\Interfaces\UserServiceInterface;
use App\Repositories\UserRepository;
use Illuminate\Support\Facades\Log;

class UserService implements UserServiceInterface
{
    public function __construct(
        private UserRepository $repository
    ) {}
    
    public function create(array $data): User
    {
        try {
            return $this->repository->create($data);
        } catch (\Exception $e) {
            Log::error('Erro ao criar usuário', [
                'exception' => $e,  // exception completa, não getMessage()
                'data' => $data,
            ]);
            throw $e;
        }
    }
}
```

---

# Expected Output

## Implementação Realizada

### Arquivos criados/modificados:
- [caminho/arquivo.php] - [descrição do que foi feito]

### Resumo:
[Breve descrição do que foi implementado]

{{#if feedback}}
### Correções aplicadas:
- [ponto corrigido 1]
- [ponto corrigido 2]
{{/if}}

### Código pronto para review ✅
