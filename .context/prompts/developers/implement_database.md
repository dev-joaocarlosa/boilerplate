---
name: implement_database
agent: database_developer
variables:
  - requirement
  - feedback
---

# Description

Implemente a estrutura de banco de dados para o requisito.

**Contexto:** {{requirement}}

{{#if feedback}}
## Feedback de Correção
{{feedback}}
{{/if}}

## Sua Responsabilidade (DATABASE)

1. Criar Migrations necessárias (up e down funcionais)
2. Criar/atualizar Models com relacionamentos
3. Criar Factories para testes
4. Criar Seeders se necessário

## Padrões Obrigatórios

- Model com $fillable ou $guarded
- PHPDoc @property em Models
- Relacionamentos tipados (HasMany, BelongsTo, etc)
- Índices em colunas de busca
- Foreign keys com onDelete apropriado

## Exemplo de Model correto

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * @property int $id
 * @property string $name
 * @property string $email
 * @property int $team_id
 * @property \Carbon\Carbon $created_at
 * @property \Carbon\Carbon $updated_at
 */
class User extends Model
{
    protected $fillable = ['name', 'email', 'team_id'];
    
    public function team(): BelongsTo
    {
        return $this->belongsTo(Team::class);
    }
    
    public function posts(): HasMany
    {
        return $this->hasMany(Post::class);
    }
}
```

## Você NÃO mexe em:
- Services (área do Backend Developer)
- Controllers (área do API Developer)
- Frontend (área do Frontend Developer)

---

# Expected Output

## Estrutura de Banco Criada

### Migrations:
- [nome_migration.php] - [descrição]

### Models:
- [Model.php] - relacionamentos: [lista]

### Factories:
- [ModelFactory.php]

### Pronto para o Backend Developer usar ✅
