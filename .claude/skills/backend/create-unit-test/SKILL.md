# Skill: Criar Teste Unitário

## Quando Usar
- Novo Service criado
- Novo método adicionado
- Garantir cobertura de código

## Regras Obrigatórias

> **ANTES DE GERAR CÓDIGO**: Valide as regras abaixo. Se tiver dúvida, leia a rule referenciada.

### Cobertura (Ver: `rules/testing/index.mdc`)

**Regras Críticas (INLINE)**:
- ✅ DEVE testar todos os métodos públicos (sucesso e falha)
- ✅ DEVE testar TODAS as exceções possíveis (ClientException, Exception genérica)
- ✅ DEVE testar métodos privados quando contêm lógica complexa
- ✅ DEVE usar DataProvider para 3+ cenários similares

### Estrutura AAA (Ver: `rules/testing/structure.mdc`)

**Regras Críticas (INLINE)**:
- Todo teste DEVE ter comentários `// Arrange`, `// Act`, `// Assert`
- Mocks devem estar no `// Arrange`
- Apenas UMA chamada no `// Act`

### API - Classes final (Ver: `rules/testing/mocks.mdc`)

**Regras Críticas (INLINE)**:
- ❌ NUNCA importe classes V1 (`Google\Shopping\Product\*`) no teste
- ❌ NUNCA use Mockery em classes `final` diretamente
- ✅ SEMPRE usar `$this->app->instance(Interface::class, $mock)` para API

```php
// ❌ PROIBIDO
use Google\Shopping\Product\Accounts\V1\Homepage;
$mockHomepage = Mockery::mock(Homepage::class); // Erro: final class

// ✅ CORRETO
$mockHomepage = Mockery::mock();
$mockHomepage->shouldReceive('getClaimed')->andReturn(true);
$this->app->instance(ExternalClientServiceInterface::class, $mockService);
```

### Exception Messages (Ver: `rules/patterns/services.mdc`)

**Regras Críticas (INLINE)**:
- `expectExceptionMessage()` DEVE usar valor do `ErrorMessageEnum`
- NUNCA usar string hardcoded em `expectExceptionMessage()`

**Checklist Pré-Geração**:
- [ ] Todos os métodos públicos têm teste de sucesso
- [ ] Todas as exceções têm teste específico
- [ ] Estrutura AAA com comentários
- [ ] API: Nenhum import V1 no arquivo de teste
- [ ] API: Usa `$this->app->instance()` para classes final

## Estrutura

### Localização
```
tests/Unit/Services/{Namespace}/{Nome}ServiceTest.php
```

### Template Base
```php
<?php

namespace Tests\Unit\Services\{Namespace};

use Tests\TestCase;
use App\Services\{Namespace}\{Nome}Service;
use App\Facades\{Namespace}\{Repository}Repository;
use App\Entities\{Namespace}\{Nome}Entity;
use App\Exceptions\ClientException;
use Mockery;
use Exception;

class {Nome}ServiceTest extends TestCase
{
    // Constantes de teste
    private const TEST_ID       = 123;
    private const TEST_NAME     = 'Test Name';
    private const TEST_STORE_ID = 456;

    private {Nome}Service $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new {Nome}Service();
    }

    /**
     * Testa a função create e espera sucesso.
     */
    public function test_create_function_and_returns_entity(): void
    {
        // Arrange
        $data = [
            'name'     => self::TEST_NAME,
            'store_id' => self::TEST_STORE_ID,
        ];

        $expectedEntity = new {Nome}Entity([
            'id'       => self::TEST_ID,
            'name'     => self::TEST_NAME,
            'store_id' => self::TEST_STORE_ID,
        ]);

        {Repository}Repository::partialMock()
            ->shouldReceive('create')
            ->once()
            ->with(Mockery::on(fn($arg) => $arg['name'] === self::TEST_NAME))
            ->andReturn($expectedEntity);

        // Act
        $result = $this->service->create($data);

        // Assert
        $this->assertInstanceOf({Nome}Entity::class, $result);
        $this->assertEquals(self::TEST_ID, $result->id);
        $this->assertEquals(self::TEST_NAME, $result->name);
    }

    /**
     * Testa exceção ClientException em create.
     */
    public function test_throw_exception_by_client_exception_in_create_function(): void
    {
        // Arrange
        $data = ['name' => ''];

        // Assert
        $this->expectException(ClientException::class);

        // Act
        $this->service->create($data);
    }

    /**
     * Testa exceção genérica em create.
     */
    public function test_throw_exception_by_generic_exception_in_create_function(): void
    {
        // Arrange
        $data = ['name' => self::TEST_NAME];

        {Repository}Repository::partialMock()
            ->shouldReceive('create')
            ->once()
            ->andThrow(new Exception('Database error'));

        // Assert
        $this->expectException(Exception::class);
        $this->expectExceptionMessage({ErrorMessage}Enum::CREATE_ERROR->value);  // ✅ Usar Enum

        // Act
        $this->service->create($data);
    }
}
```

## Padrões

### Nomenclatura de Métodos

| Cenário | Formato |
|---------|---------|
| Sucesso | `test_{metodo}_function_and_returns_{resultado}` |
| ClientException | `test_throw_exception_by_client_exception_in_{metodo}_function` |
| Exception genérica | `test_throw_exception_by_generic_exception_in_{metodo}_function` |
| Validação | `test_should_throw_validation_exception_when_{condicao}` |

### Constantes de Teste
```php
private const TEST_ID           = 123;
private const TEST_NAME         = 'Test Name';
private const TEST_STORE_ID     = 456;
private const TEST_CUSTOMER_ID  = '789-012-3456';
private const TEST_BUDGET       = 100.00;
```

### Estrutura AAA

```php
public function test_example(): void
{
    // Arrange - Preparação
    $input = ['key' => 'value'];
    $expectedResult = new Entity(['id' => 1]);

    Facade::partialMock()
        ->shouldReceive('method')
        ->once()
        ->andReturn($expectedResult);

    // Act - Execução
    $result = $this->service->doSomething($input);

    // Assert - Verificação
    $this->assertEquals($expectedResult, $result);
}
```

## Mocks

### Facades (partialMock)
```php
{Repository}Repository::partialMock()
    ->shouldReceive('find')
    ->once()
    ->with(self::TEST_ID)
    ->andReturn($entity);
```

### Com Mockery::on (Validação de Parâmetros)
```php
Facade::partialMock()
    ->shouldReceive('create')
    ->once()
    ->with(Mockery::on(function ($arg) {
        return $arg['name'] === self::TEST_NAME
            && $arg['store_id'] === self::TEST_STORE_ID;
    }))
    ->andReturn($entity);
```

### Múltiplas Chamadas
```php
Facade::partialMock()
    ->shouldReceive('find')
    ->twice()
    ->andReturn($entity, null);
```

### Sequência de Retornos
```php
Facade::partialMock()
    ->shouldReceive('get')
    ->andReturn($entity1, $entity2, $entity3);
```

### Não Deve Ser Chamado
```php
Facade::partialMock()
    ->shouldNotReceive('delete');
```

## Testando Métodos Privados

```php
use ReflectionMethod;

public function test_private_method(): void
{
    // Arrange
    $service = new {Nome}Service();
    $method  = new ReflectionMethod($service, 'privateMethodName');
    $method->setAccessible(true);

    $input = ['data' => 'value'];

    // Act
    $result = $method->invoke($service, $input);

    // Assert
    $this->assertEquals('expected', $result);
}
```

## Testando Exceções

### Esperar Exceção
```php
public function test_throws_client_exception(): void
{
    // Arrange
    $data = ['invalid' => 'data'];

    // Assert (antes do Act)
    $this->expectException(ClientException::class);
    $this->expectExceptionMessage('Mensagem esperada');

    // Act
    $this->service->create($data);
}
```

### Mock que Lança Exceção
```php
Facade::partialMock()
    ->shouldReceive('create')
    ->once()
    ->andThrow(new ClientException('Erro específico'));
```

## DataProviders

### Quando Usar
- 3+ cenários com mesma estrutura
- Diferentes inputs, mesmo fluxo
- Validações com múltiplos valores

### Exemplo
```php
/**
 * @dataProvider invalidDataProvider
 */
public function test_validation_fails_with_invalid_data(array $data, string $expectedField): void
{
    // Arrange
    $method = new ReflectionMethod($this->service, 'validate');
    $method->setAccessible(true);

    // Assert
    $this->expectException(ValidationException::class);

    // Act
    $method->invoke($this->service, $data);
}

public static function invalidDataProvider(): array
{
    return [
        'empty_name' => [
            'data'          => ['name' => ''],
            'expectedField' => 'name',
        ],
        'negative_budget' => [
            'data'          => ['name' => 'Test', 'budget' => -10],
            'expectedField' => 'budget',
        ],
        'missing_store_id' => [
            'data'          => ['name' => 'Test', 'budget' => 100],
            'expectedField' => 'store_id',
        ],
    ];
}
```

## Exemplo Completo

```php
<?php

namespace Tests\Unit\Services\Google;

use App\Entities\Google\CampaignEntity;
use App\Enums\Google\GoogleErrorMessageEnum;
use App\Exceptions\ClientException;
use App\Facades\Project\CampaignRepository;
use App\Services\Google\CampaignService;
use App\Support\Logging\ApiLog;
use Exception;
use Mockery;
use ReflectionMethod;
use Tests\TestCase;

class CampaignServiceTest extends TestCase
{
    private const TEST_ID          = 123;
    private const TEST_NAME        = 'Test Campaign';
    private const TEST_STORE_ID    = 456;
    private const TEST_BUDGET      = 100.00;

    private CampaignService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new CampaignService();
    }

    /**
     * Testa a função create e espera sucesso.
     */
    public function test_create_function_and_returns_campaign_entity(): void
    {
        // Arrange
        $data = [
            'name'   => self::TEST_NAME,
            'budget' => self::TEST_BUDGET,
        ];

        $expectedEntity = new CampaignEntity([
            'id'       => self::TEST_ID,
            'name'     => self::TEST_NAME,
            'budget'   => self::TEST_BUDGET,
            'store_id' => self::TEST_STORE_ID,
        ]);

        CampaignRepository::partialMock()
            ->shouldReceive('create')
            ->once()
            ->andReturn($expectedEntity);

        ApiLog::shouldReceive('info')
            ->twice();

        // Act
        $result = $this->service->create($data);

        // Assert
        $this->assertInstanceOf(CampaignEntity::class, $result);
        $this->assertEquals(self::TEST_ID, $result->id);
        $this->assertEquals(self::TEST_NAME, $result->name);
    }

    /**
     * Testa a função get e espera sucesso.
     */
    public function test_get_function_and_returns_campaign_entity(): void
    {
        // Arrange
        $expectedEntity = new CampaignEntity([
            'id'   => self::TEST_ID,
            'name' => self::TEST_NAME,
        ]);

        CampaignRepository::partialMock()
            ->shouldReceive('find')
            ->once()
            ->with(self::TEST_ID)
            ->andReturn($expectedEntity);

        // Act
        $result = $this->service->get(self::TEST_ID);

        // Assert
        $this->assertInstanceOf(CampaignEntity::class, $result);
        $this->assertEquals(self::TEST_ID, $result->id);
    }

    /**
     * Testa a função get quando não encontra.
     */
    public function test_get_function_and_returns_null_when_not_found(): void
    {
        // Arrange
        CampaignRepository::partialMock()
            ->shouldReceive('find')
            ->once()
            ->with(self::TEST_ID)
            ->andReturn(null);

        // Act
        $result = $this->service->get(self::TEST_ID);

        // Assert
        $this->assertNull($result);
    }

    /**
     * Testa exceção ClientException em create com nome vazio.
     */
    public function test_throw_exception_by_client_exception_in_create_when_name_empty(): void
    {
        // Arrange
        $data = ['name' => '', 'budget' => self::TEST_BUDGET];

        ApiLog::shouldReceive('info')->once();
        ApiLog::shouldReceive('error')->once();

        // Assert
        $this->expectException(ClientException::class);

        // Act
        $this->service->create($data);
    }

    /**
     * Testa exceção genérica em create.
     */
    public function test_throw_exception_by_generic_exception_in_create_function(): void
    {
        // Arrange
        $data = ['name' => self::TEST_NAME, 'budget' => self::TEST_BUDGET];

        CampaignRepository::partialMock()
            ->shouldReceive('create')
            ->once()
            ->andThrow(new Exception('Database error'));

        ApiLog::shouldReceive('info')->once();
        ApiLog::shouldReceive('error')->once();

        // Assert
        $this->expectException(Exception::class);
        $this->expectExceptionMessage(GoogleErrorMessageEnum::CAMPAIGN_CREATE_ERROR->value);  // ✅ Usar Enum

        // Act
        $this->service->create($data);
    }

    /**
     * Testa validação de dados privada.
     */
    public function test_validate_create_data_throws_exception_when_budget_too_low(): void
    {
        // Arrange
        $method = new ReflectionMethod($this->service, 'validateCreateData');
        $method->setAccessible(true);

        $data = ['name' => self::TEST_NAME, 'budget' => 0];

        // Assert
        $this->expectException(ClientException::class);

        // Act
        $method->invoke($this->service, $data);
    }
}
```

## Testando Serviços API

As classes da API são `final class`, o que impede Mockery diretamente. Use `$this->app->instance()`.

### 🚫 Proibições em Testes API

1. **NUNCA** importe classes V1 (`Google\Shopping\Product\*`) nos arquivos de teste
2. **NUNCA** use Mockery diretamente em classes `final`

### Padrão para Testes API

```php
// ❌ PROIBIDO - Import V1 no teste
use Google\Shopping\Product\Accounts\V1\Homepage;

// ✅ CORRETO - Mock genérico sem tipar com classe V1
$mockHomepage = Mockery::mock();
$mockHomepage->shouldReceive('getClaimed')->andReturn(true);

$mockHomepageClient = Mockery::mock();
$mockHomepageClient->shouldReceive('getHomepage')->andReturn($mockHomepage);

$mockService = Mockery::mock();
$mockService->shouldReceive('getHomepageClient')->andReturn($mockHomepageClient);

// ✅ Substituir no container via Interface
$this->app->instance(ExternalClientServiceInterface::class, $mockService);
```

**Documentação completa**: `.cursor/rules/testing/mocks.mdc` → Seção "Testando API"

## Checklist

- [ ] Classe em `tests/Unit/Services/{Namespace}/`
- [ ] Nome termina com `Test`
- [ ] Estende `TestCase`
- [ ] Constantes para dados de teste
- [ ] `setUp()` inicializa service
- [ ] Padrão AAA em todos os testes
- [ ] Teste de sucesso para cada método
- [ ] Teste de ClientException
- [ ] Teste de Exception genérica
- [ ] Mocks com `partialMock()`
- [ ] Nomenclatura correta
- [ ] **API**: Nenhum import V1 no arquivo de teste
- [ ] **API**: Usar `$this->app->instance()` para classes `final`
