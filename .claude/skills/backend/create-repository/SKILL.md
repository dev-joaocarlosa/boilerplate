# Skill: Criar Repository

## Quando Usar
- Acesso a dados do banco
- Queries customizadas
- Persistência de entidades

## Regras Obrigatórias

> **ANTES DE GERAR CÓDIGO**: Valide as regras abaixo. Se tiver dúvida, leia a rule referenciada.

### Performance (Ver: `rules/patterns/repositories.mdc`)

**Regras Críticas (INLINE)**:
- ❌ NUNCA usar `SELECT *` - sempre especificar colunas necessárias
- ❌ NUNCA usar `count()` para verificar existência - usar `exists()`
- ❌ NUNCA carregar relacionamentos desnecessários
- ✅ SEMPRE usar índices nas colunas de WHERE/ORDER BY
- ✅ SEMPRE usar `chunk()` para processar grandes volumes
- ✅ SEMPRE usar eager loading para evitar N+1

```php
// ❌ ERRADO - SELECT *, count() para existência
$query->select('*');
if ($query->count() > 0) { ... }

// ✅ CORRETO - Colunas específicas, exists()
$query->select(['id', 'name', 'status']);
if ($query->exists()) { ... }
```

### Concorrência (Ver: `rules/patterns/repositories.mdc`)

**Regras Críticas (INLINE)**:
- ❌ NUNCA fazer transações longas (> 1s)
- ❌ NUNCA fazer UPDATE sem WHERE específico
- ❌ NUNCA usar LOCK TABLE sem extrema necessidade
- ✅ SEMPRE usar transações curtas e atômicas
- ✅ SEMPRE considerar deadlocks em updates em massa

### Queries Otimizadas

```php
// ❌ ERRADO - N+1 query
$campaigns = Campaign::all();
foreach ($campaigns as $campaign) {
    echo $campaign->store->name; // Query para cada iteração
}

// ✅ CORRETO - Eager loading
$campaigns = Campaign::with('store')->get();
foreach ($campaigns as $campaign) {
    echo $campaign->store->name; // Já carregado
}

// ❌ ERRADO - Carregar tudo na memória
$allRecords = $this->db()->table('huge_table')->get();

// ✅ CORRETO - Processar em chunks
$this->db()->table('huge_table')->chunk(1000, function ($records) {
    foreach ($records as $record) {
        // Processar
    }
});
```

**Checklist Pré-Geração**:
- [ ] Queries especificam colunas (não SELECT *)
- [ ] Verificações de existência usam `exists()`
- [ ] Relacionamentos usam eager loading
- [ ] Processamento de grandes volumes usa `chunk()`

## Estrutura

### Arquivos a Criar
```
app/Contracts/Repositories/{Namespace}/{Nome}RepositoryInterface.php
app/Repositories/{Namespace}/{Nome}Repository.php
```

### Interface
```php
<?php

namespace App\Contracts\Repositories\{Namespace};

use App\Entities\{Namespace}\{Nome}Entity;
use Illuminate\Support\Collection;

/**
 * Interface para {Nome}Repository.
 */
interface {Nome}RepositoryInterface
{
    /**
     * Busca registro por ID.
     *
     * @param int $id
     * @return {Nome}Entity|null
     */
    public function find(int $id): ?{Nome}Entity;

    /**
     * Busca todos os registros.
     *
     * @param array $filters
     * @return Collection<{Nome}Entity>
     */
    public function findAll(array $filters = []): Collection;

    /**
     * Cria novo registro.
     *
     * @param array $data
     * @return {Nome}Entity
     */
    public function create(array $data): {Nome}Entity;

    /**
     * Atualiza registro existente.
     *
     * @param int $id
     * @param array $data
     * @return {Nome}Entity
     */
    public function update(int $id, array $data): {Nome}Entity;

    /**
     * Remove registro.
     *
     * @param int $id
     * @return bool
     */
    public function delete(int $id): bool;
}
```

### Repository
```php
<?php

namespace App\Repositories\{Namespace};

use App\Contracts\Repositories\{Namespace}\{Nome}RepositoryInterface;
use App\Entities\{Namespace}\{Nome}Entity;
use App\Repositories\DbRepository;
use Illuminate\Support\Collection;

/**
 * Repository para {Nome}.
 */
class {Nome}Repository extends DbRepository implements {Nome}RepositoryInterface
{
    /**
     * @var string
     */
    protected string $table = '{tabela}';

    /**
     * Colunas da tabela.
     */
    private array $columns = ['id', 'store_id', 'name', 'status', 'created_at', 'updated_at'];

    /**
     * @inheritDoc
     */
    public function find(int $id): ?{Nome}Entity
    {
        $result = $this->db()
            ->table($this->table)
            ->select($this->columns)  // ✅ Especifica colunas
            ->where('id', $id)
            ->first();

        if (!$result) {
            return null;
        }

        return new {Nome}Entity((array) $result);
    }

    /**
     * @inheritDoc
     */
    public function findAll(array $filters = []): Collection
    {
        $query = $this->db()
            ->table($this->table)
            ->select($this->columns);  // ✅ Especifica colunas

        if (isset($filters['store_id'])) {
            $query->where('store_id', $filters['store_id']);
        }

        if (isset($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        return $query->get()->map(
            fn($row) => new {Nome}Entity((array) $row)
        );
    }

    /**
     * @inheritDoc
     */
    public function create(array $data): {Nome}Entity
    {
        $id = $this->db()
            ->table($this->table)
            ->insertGetId($data);

        return $this->find($id);
    }

    /**
     * @inheritDoc
     */
    public function update(int $id, array $data): {Nome}Entity
    {
        $this->db()
            ->table($this->table)
            ->where('id', $id)
            ->update($data);

        return $this->find($id);
    }

    /**
     * @inheritDoc
     */
    public function delete(int $id): bool
    {
        return $this->db()
            ->table($this->table)
            ->where('id', $id)
            ->delete() > 0;
    }
}
```

## Padrões

### Nomenclatura
- **Interface**: `{Nome}RepositoryInterface`
- **Classe**: `{Nome}Repository`
- **Tabela**: snake_case plural (`campaigns`, `products`)

### Retornos
- `find()`: Entity ou null
- `findAll()`: Collection de Entities
- `create()`: Entity criada
- `update()`: Entity atualizada
- `delete()`: bool

### PHPDoc
- Documentação APENAS na Interface
- Repository usa `@inheritDoc`

## Métodos Comuns

### Busca por Campo
```php
/**
 * Busca por store_id.
 *
 * @param int $storeId
 * @return Collection<{Nome}Entity>
 */
public function findByStoreId(int $storeId): Collection;
```

### Busca com Paginação
```php
/**
 * Lista com paginação.
 *
 * @param int $page
 * @param int $perPage
 * @return array{data: Collection, total: int, page: int, per_page: int}
 */
public function paginate(int $page = 1, int $perPage = 20): array;
```

### Verificação de Existência
```php
/**
 * Verifica se registro existe.
 *
 * @param int $id
 * @return bool
 */
public function exists(int $id): bool;
```

### Busca ou Cria
```php
/**
 * Busca ou cria registro.
 *
 * @param array $attributes
 * @param array $values
 * @return {Nome}Entity
 */
public function firstOrCreate(array $attributes, array $values = []): {Nome}Entity;
```

### Update ou Create
```php
/**
 * Atualiza ou cria registro.
 *
 * @param array $attributes
 * @param array $values
 * @return {Nome}Entity
 */
public function updateOrCreate(array $attributes, array $values = []): {Nome}Entity;
```

## Exemplo Completo

### Interface
```php
<?php

namespace App\Contracts\Repositories\Project;

use App\Entities\Project\CampaignEntity;
use Illuminate\Support\Collection;

/**
 * Interface para CampaignRepository.
 */
interface CampaignRepositoryInterface
{
    /**
     * Busca campanha por ID.
     *
     * @param int $id
     * @return CampaignEntity|null
     */
    public function find(int $id): ?CampaignEntity;

    /**
     * Busca campanhas por store_id.
     *
     * @param int $storeId
     * @return Collection<CampaignEntity>
     */
    public function findByStoreId(int $storeId): Collection;

    /**
     * Busca campanha por ads_customer_id.
     *
     * @param string $adsCustomerId
     * @return CampaignEntity|null
     */
    public function findByAdsCustomerId(string $adsCustomerId): ?CampaignEntity;

    /**
     * Lista campanhas com paginação.
     *
     * @param array $filters
     * @param int $page
     * @param int $perPage
     * @return array{data: Collection<CampaignEntity>, total: int, page: int, per_page: int}
     */
    public function paginate(array $filters = [], int $page = 1, int $perPage = 20): array;

    /**
     * Cria nova campanha.
     *
     * @param array $data
     * @return CampaignEntity
     */
    public function create(array $data): CampaignEntity;

    /**
     * Atualiza campanha existente.
     *
     * @param int $id
     * @param array $data
     * @return CampaignEntity
     */
    public function update(int $id, array $data): CampaignEntity;

    /**
     * Atualiza status da campanha.
     *
     * @param int $id
     * @param string $status
     * @return CampaignEntity
     */
    public function updateStatus(int $id, string $status): CampaignEntity;

    /**
     * Remove campanha.
     *
     * @param int $id
     * @return bool
     */
    public function delete(int $id): bool;
}
```

### Repository
```php
<?php

namespace App\Repositories\Project;

use App\Contracts\Repositories\Project\CampaignRepositoryInterface;
use App\Entities\Project\CampaignEntity;
use App\Repositories\DbRepository;
use Illuminate\Support\Collection;

/**
 * Repository para Campaign.
 */
class CampaignRepository extends DbRepository implements CampaignRepositoryInterface
{
    /**
     * @var string
     */
    protected string $table = 'campaigns';

    /**
     * Colunas da tabela (evitar SELECT *).
     */
    private array $columns = [
        'id',
        'store_id',
        'ads_customer_id',
        'name',
        'status',
        'budget',
        'created_at',
        'updated_at',
    ];

    /**
     * @inheritDoc
     */
    public function find(int $id): ?CampaignEntity
    {
        $result = $this->db()
            ->table($this->table)
            ->select($this->columns)  // ✅ Especifica colunas
            ->where('id', $id)
            ->first();

        if (!$result) {
            return null;
        }

        return new CampaignEntity((array) $result);
    }

    /**
     * @inheritDoc
     */
    public function findByStoreId(int $storeId): Collection
    {
        return $this->db()
            ->table($this->table)
            ->select($this->columns)  // ✅ Especifica colunas
            ->where('store_id', $storeId)
            ->get()
            ->map(fn($row) => new CampaignEntity((array) $row));
    }

    /**
     * @inheritDoc
     */
    public function findByAdsCustomerId(string $adsCustomerId): ?CampaignEntity
    {
        $result = $this->db()
            ->table($this->table)
            ->select($this->columns)  // ✅ Especifica colunas
            ->where('ads_customer_id', $adsCustomerId)
            ->first();

        if (!$result) {
            return null;
        }

        return new CampaignEntity((array) $result);
    }

    /**
     * @inheritDoc
     */
    public function paginate(array $filters = [], int $page = 1, int $perPage = 20): array
    {
        $query = $this->db()
            ->table($this->table)
            ->select($this->columns);  // ✅ Especifica colunas

        if (isset($filters['store_id'])) {
            $query->where('store_id', $filters['store_id']);
        }

        if (isset($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        // ✅ Clone para count (evita conflito com offset/limit)
        $total = (clone $query)->count('id');

        $data = $query
            ->offset(($page - 1) * $perPage)
            ->limit($perPage)
            ->get()
            ->map(fn($row) => new CampaignEntity((array) $row));

        return [
            'data'     => $data,
            'total'    => $total,
            'page'     => $page,
            'per_page' => $perPage,
        ];
    }

    /**
     * @inheritDoc
     */
    public function create(array $data): CampaignEntity
    {
        $id = $this->db()
            ->table($this->table)
            ->insertGetId($data);

        return $this->find($id);
    }

    /**
     * @inheritDoc
     */
    public function update(int $id, array $data): CampaignEntity
    {
        $this->db()
            ->table($this->table)
            ->where('id', $id)
            ->update($data);

        return $this->find($id);
    }

    /**
     * @inheritDoc
     */
    public function updateStatus(int $id, string $status): CampaignEntity
    {
        return $this->update($id, ['status' => $status]);
    }

    /**
     * @inheritDoc
     */
    public function delete(int $id): bool
    {
        return $this->db()
            ->table($this->table)
            ->where('id', $id)
            ->delete() > 0;
    }
}
```

## Registro no ServiceProvider

```php
// app/Providers/AppServiceProvider.php

use App\Contracts\Repositories\Project\CampaignRepositoryInterface;
use App\Repositories\Project\CampaignRepository;

public function register(): void
{
    $this->app->bind(
        CampaignRepositoryInterface::class,
        CampaignRepository::class
    );
}
```

## Checklist

- [ ] Interface em `app/Contracts/Repositories/{Namespace}/`
- [ ] Repository em `app/Repositories/{Namespace}/`
- [ ] Estende `DbRepository`
- [ ] Implementa Interface
- [ ] PHPDoc na Interface
- [ ] `@inheritDoc` no Repository
- [ ] Retorna Entities (não arrays)
- [ ] Registrado no ServiceProvider
