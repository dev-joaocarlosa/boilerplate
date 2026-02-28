# Skill: Criar Service

## Quando Usar
- Nova funcionalidade de negócio
- Integração com APIs externas
- Lógica que não pertence a Controller/Repository

## Regras Obrigatórias

> **ANTES DE GERAR CÓDIGO**: Valide as regras abaixo. Se tiver dúvida, leia a rule referenciada.

### Exception Handling (Ver: `rules/patterns/services.mdc`)

**Regras Críticas (INLINE)**:
- **ClientException**: APENAS `throw $e;` no catch (log já feito na origem, NÃO duplicar)
- **Exception genérica**: mensagem via `ErrorMessageEnum`, NUNCA string hardcoded
- **Exception genérica**: NUNCA expor `getMessage()` para o usuário

### Responsabilidade Única (Ver: `rules/patterns/services.mdc`)

**Regras Críticas (INLINE)**:
- Cada método público deve ter UMA responsabilidade
- Métodos privados: NUNCA chamar outros métodos privados (evitar cascata)
- Métodos privados: SEM try/catch, SEM logs

### Mensagens de Erro

**Regras Críticas (INLINE)**:
- SEMPRE usar `ErrorMessageEnum` para mensagens em português
- NUNCA usar strings hardcoded em `ClientException` ou `Exception`

**Checklist Pré-Geração**:
- [ ] Li `rules/patterns/services.mdc` se houver dúvida sobre exceptions
- [ ] Mensagens de erro usam `ErrorMessageEnum`
- [ ] ClientException não tem log no catch

## Estrutura

### Arquivos a Criar
```
app/Contracts/Services/{Namespace}/{Nome}ServiceInterface.php
app/Services/{Namespace}/{Nome}Service.php
app/Facades/{Namespace}/{Nome}Service.php
```

### Interface
```php
<?php

namespace App\Contracts\Services\{Namespace};

use App\Entities\{Namespace}\{Nome}Entity;
use App\Exceptions\ClientException;

/**
 * Interface para {Nome}Service.
 */
interface {Nome}ServiceInterface
{
    /**
     * Descrição do método.
     *
     * @param array $data Dados de entrada
     * @return {Nome}Entity
     * @throws ClientException
     */
    public function create(array $data): {Nome}Entity;

    /**
     * Descrição do método.
     *
     * @param int $id
     * @return {Nome}Entity|null
     */
    public function get(int $id): ?{Nome}Entity;
}
```

### Service
```php
<?php

namespace App\Services\{Namespace};

use App\Contracts\Services\{Namespace}\{Nome}ServiceInterface;
use App\Entities\{Namespace}\{Nome}Entity;
use App\Exceptions\ClientException;
use App\Facades\{Namespace}\{Repository}Repository;
use App\Support\Logging\ApiLog;
use Exception;

/**
 * Service para {contexto}.
 */
class {Nome}Service implements {Nome}ServiceInterface
{
    /**
     * @inheritDoc
     */
    public function create(array $data): {Nome}Entity
    {
        try {
            ApiLog::info('Project - {Nome}Service - create - Starting', [
                'data' => $data,
            ]);

            $this->validateData($data);

            $entity = {Repository}Repository::create($data);

            ApiLog::info('Project - {Nome}Service - create - Success', [
                'entity_id' => $entity->id,
            ]);

            return $entity;

        } catch (ClientException $e) {
            throw $e; // Log já feito na origem

        } catch (Exception $exception) {
            ApiLog::error('Project - {Nome}Service - create - Error', [
                'exception' => $exception,
            ]);
            throw new Exception({ErrorMessage}Enum::CREATE_ERROR->value);
        }
    }

    /**
     * @inheritDoc
     */
    public function get(int $id): ?{Nome}Entity
    {
        try {
            ApiLog::info('Project - {Nome}Service - get - Starting', [
                'id' => $id,
            ]);

            $entity = {Repository}Repository::find($id);

            ApiLog::info('Project - {Nome}Service - get - Completed', [
                'found' => $entity !== null,
            ]);

            return $entity;

        } catch (Exception $exception) {
            ApiLog::error('Project - {Nome}Service - get - Error', [
                'exception' => $exception,
            ]);
            throw new Exception({ErrorMessage}Enum::GET_ERROR->value);
        }
    }

    /**
     * Valida dados de entrada.
     */
    private function validateData(array $data): void
    {
        if (empty($data['name'])) {
            ApiLog::error('Project - {Nome}Service - validateData - Name required');
            throw new ClientException({ErrorMessage}Enum::NAME_REQUIRED->value);
        }
    }
}
```

### Facade
```php
<?php

namespace App\Facades\{Namespace};

use App\Contracts\Services\{Namespace}\{Nome}ServiceInterface;
use App\Entities\{Namespace}\{Nome}Entity;
use Illuminate\Support\Facades\Facade;

/**
 * Facade para {Nome}Service.
 *
 * @method static {Nome}Entity create(array $data)
 * @method static {Nome}Entity|null get(int $id)
 *
 * @see \App\Services\{Namespace}\{Nome}Service
 */
class {Nome}Service extends Facade
{
    /**
     * @return string
     */
    protected static function getFacadeAccessor(): string
    {
        return {Nome}ServiceInterface::class;
    }
}
```

## Padrões Obrigatórios

### PHPDoc
- **Interface**: Documentação completa de cada método
- **Service**: Usar `@inheritDoc`
- **Facade**: Anotações `@method static` para todos os métodos

### Try/Catch
- Apenas no método público
- ClientException: APENAS `throw $e;` (SEM log no catch)
- Exception: mensagem via `ErrorMessageEnum` + log

### Logs
- Início: `{Classe} - {metodo} - Starting`
- Sucesso: `{Classe} - {metodo} - Success` ou `Completed`
- Erro: `{Classe} - {metodo} - Error`
- Sempre passar `['exception' => $exception]`

### Métodos Privados
- Sem try/catch (exceção sobe)
- Sem logs (evitar duplicação)
- Focados em uma responsabilidade

## Registro no ServiceProvider

```php
// app/Providers/AppServiceProvider.php

use App\Contracts\Services\{Namespace}\{Nome}ServiceInterface;
use App\Services\{Namespace}\{Nome}Service;

public function register(): void
{
    $this->app->bind(
        {Nome}ServiceInterface::class,
        {Nome}Service::class
    );
}
```

## Exemplo Completo

### Interface
```php
<?php

namespace App\Contracts\Services\Google;

use App\Entities\Google\CampaignEntity;
use App\Exceptions\ClientException;

/**
 * Interface para CampaignService.
 */
interface CampaignServiceInterface
{
    /**
     * Cria uma nova campanha Project.
     *
     * @param array{
     *     name: string,
     *     budget: float,
     *     status?: string
     * } $data Dados da campanha
     * @return CampaignEntity
     * @throws ClientException
     */
    public function create(array $data): CampaignEntity;

    /**
     * Busca campanha por ID.
     *
     * @param int $id ID da campanha
     * @return CampaignEntity|null
     */
    public function get(int $id): ?CampaignEntity;

    /**
     * Lista campanhas da loja atual.
     *
     * @param array $filters Filtros opcionais
     * @return array<CampaignEntity>
     */
    public function list(array $filters = []): array;

    /**
     * Atualiza uma campanha existente.
     *
     * @param int $id ID da campanha
     * @param array $data Dados para atualização
     * @return CampaignEntity
     * @throws ClientException
     */
    public function update(int $id, array $data): CampaignEntity;

    /**
     * Remove uma campanha.
     *
     * @param int $id ID da campanha
     * @return bool
     * @throws ClientException
     */
    public function delete(int $id): bool;
}
```

### Service
```php
<?php

namespace App\Services\Google;

use App\Contracts\Services\Google\CampaignServiceInterface;
use App\Entities\Google\CampaignEntity;
use App\Enums\Google\GoogleErrorMessageEnum;
use App\Exceptions\ClientException;
use App\Facades\Project\CampaignRepository;
use App\Support\Logging\ApiLog;
use Exception;

/**
 * Service para gerenciamento de campanhas Project.
 */
class CampaignService implements CampaignServiceInterface
{
    /**
     * @inheritDoc
     */
    public function create(array $data): CampaignEntity
    {
        try {
            ApiLog::info('Project - CampaignService - create - Starting', [
                'data' => $data,
            ]);

            $this->validateCreateData($data);

            $entity = CampaignRepository::create([
                'store_id' => store_id(),
                'name'     => $data['name'],
                'budget'   => $data['budget'],
                'status'   => $data['status'] ?? 'draft',
            ]);

            ApiLog::info('Project - CampaignService - create - Success', [
                'campaign_id' => $entity->id,
            ]);

            return $entity;

        } catch (ClientException $e) {
            throw $e; // Log já feito na origem

        } catch (Exception $exception) {
            ApiLog::error('Project - CampaignService - create - Error', [
                'exception' => $exception,
            ]);
            throw new Exception(GoogleErrorMessageEnum::CAMPAIGN_CREATE_ERROR->value);
        }
    }

    /**
     * @inheritDoc
     */
    public function get(int $id): ?CampaignEntity
    {
        try {
            return CampaignRepository::find($id);

        } catch (Exception $exception) {
            ApiLog::error('Project - CampaignService - get - Error', [
                'exception' => $exception,
            ]);
            throw new Exception(GoogleErrorMessageEnum::CAMPAIGN_GET_ERROR->value);
        }
    }

    /**
     * @inheritDoc
     */
    public function list(array $filters = []): array
    {
        try {
            $filters['store_id'] = store_id();

            return CampaignRepository::findAll($filters)->toArray();

        } catch (Exception $exception) {
            ApiLog::error('Project - CampaignService - list - Error', [
                'exception' => $exception,
            ]);
            throw new Exception(GoogleErrorMessageEnum::CAMPAIGN_LIST_ERROR->value);
        }
    }

    /**
     * @inheritDoc
     */
    public function update(int $id, array $data): CampaignEntity
    {
        try {
            ApiLog::info('Project - CampaignService - update - Starting', [
                'id'   => $id,
                'data' => $data,
            ]);

            $campaign = $this->findOrFail($id);
            $entity   = CampaignRepository::update($id, $data);

            ApiLog::info('Project - CampaignService - update - Success', [
                'campaign_id' => $entity->id,
            ]);

            return $entity;

        } catch (ClientException $e) {
            throw $e; // Log já feito na origem

        } catch (Exception $exception) {
            ApiLog::error('Project - CampaignService - update - Error', [
                'exception' => $exception,
            ]);
            throw new Exception(GoogleErrorMessageEnum::CAMPAIGN_UPDATE_ERROR->value);
        }
    }

    /**
     * @inheritDoc
     */
    public function delete(int $id): bool
    {
        try {
            ApiLog::info('Project - CampaignService - delete - Starting', [
                'id' => $id,
            ]);

            $this->findOrFail($id);
            $result = CampaignRepository::delete($id);

            ApiLog::info('Project - CampaignService - delete - Success', [
                'campaign_id' => $id,
            ]);

            return $result;

        } catch (ClientException $e) {
            throw $e; // Log já feito na origem

        } catch (Exception $exception) {
            ApiLog::error('Project - CampaignService - delete - Error', [
                'exception' => $exception,
            ]);
            throw new Exception(GoogleErrorMessageEnum::CAMPAIGN_DELETE_ERROR->value);
        }
    }

    /**
     * Valida dados para criação.
     */
    private function validateCreateData(array $data): void
    {
        if (empty($data['name'])) {
            ApiLog::error('Project - CampaignService - validateCreateData - Name required');
            throw new ClientException(GoogleErrorMessageEnum::CAMPAIGN_NAME_REQUIRED->value);
        }

        if (!isset($data['budget']) || $data['budget'] <= 0) {
            ApiLog::error('Project - CampaignService - validateCreateData - Budget invalid', [
                'budget' => $data['budget'] ?? null,
            ]);
            throw new ClientException(GoogleErrorMessageEnum::BUDGET_TOO_LOW->value);
        }
    }

    /**
     * Busca campanha ou lança exceção.
     */
    private function findOrFail(int $id): CampaignEntity
    {
        $campaign = CampaignRepository::find($id);

        if (!$campaign) {
            ApiLog::error('Project - CampaignService - findOrFail - Campaign not found', [
                'id' => $id,
            ]);
            throw new ClientException(GoogleErrorMessageEnum::CAMPAIGN_NOT_FOUND->value);
        }

        return $campaign;
    }
}
```

### Facade
```php
<?php

namespace App\Facades\Google;

use App\Contracts\Services\Google\CampaignServiceInterface;
use App\Entities\Google\CampaignEntity;
use Illuminate\Support\Facades\Facade;

/**
 * Facade para CampaignService.
 *
 * @method static CampaignEntity create(array $data)
 * @method static CampaignEntity|null get(int $id)
 * @method static array list(array $filters = [])
 * @method static CampaignEntity update(int $id, array $data)
 * @method static bool delete(int $id)
 *
 * @see \App\Services\Google\CampaignService
 */
class CampaignService extends Facade
{
    /**
     * @return string
     */
    protected static function getFacadeAccessor(): string
    {
        return CampaignServiceInterface::class;
    }
}
```

## Checklist

- [ ] Interface em `app/Contracts/Services/{Namespace}/`
- [ ] Service em `app/Services/{Namespace}/`
- [ ] Facade em `app/Facades/{Namespace}/`
- [ ] Service implementa Interface
- [ ] PHPDoc completo na Interface
- [ ] `@inheritDoc` no Service
- [ ] `@method static` na Facade
- [ ] Try/catch nos métodos públicos
- [ ] Logs no padrão do projeto
- [ ] Registrado no ServiceProvider
- [ ] Testes criados
