# Skill: Criar Teste para Artisan Command

## Quando Usar
- Novo Command criado
- Testar comportamento do CLI
- Verificar integração com Services

## Desafio: Classes Final do Google API

A Product API do Google (API) usa classes `final`, que não podem ser mockadas diretamente com Mockery.

### Problema
```php
// ❌ Não funciona - classe final
$mock = Mockery::mock(\Google\Shopping\Product\Accounts\V1\Client\AccountsServiceClient::class);
// Error: Cannot mock a final class
```

### Solução: Arquitetura Command → Service → Facade

```
Command → Facade → Service → Repository/Client
   ↓
 Mockamos apenas a Facade no teste
```

## Estrutura de Teste

### Localização
```
tests/Feature/Commands/{Nome}CommandTest.php
```

### Template Base
```php
<?php

namespace Tests\Feature\Commands;

use Tests\TestCase;
use App\Facades\Google\{Service}Service;
use Mockery;

class {Nome}CommandTest extends TestCase
{
    /**
     * Testa execução com sucesso do comando.
     */
    public function test_command_executes_successfully(): void
    {
        // Arrange
        {Service}Service::partialMock()
            ->shouldReceive('process')
            ->once()
            ->andReturn([
                'processed' => 10,
                'success'   => 10,
                'errors'    => 0,
            ]);

        // Act
        $this->artisan('project:{nome}')
            ->expectsOutput('Iniciando...')
            ->expectsOutput('Comando executado com sucesso!')
            ->assertExitCode(0);
    }

    /**
     * Testa execução com argumentos.
     */
    public function test_command_with_arguments(): void
    {
        // Arrange
        {Service}Service::partialMock()
            ->shouldReceive('process')
            ->once()
            ->with(['store_id' => '12345', 'limit' => 100])
            ->andReturn(['processed' => 5]);

        // Act
        $this->artisan('project:{nome}', ['storeId' => '12345'])
            ->assertExitCode(0);
    }

    /**
     * Testa execução com opções.
     */
    public function test_command_with_options(): void
    {
        // Arrange
        {Service}Service::partialMock()
            ->shouldReceive('process')
            ->once()
            ->with(Mockery::on(fn($arg) => $arg['limit'] === 50))
            ->andReturn(['processed' => 50]);

        // Act
        $this->artisan('project:{nome}', ['--limit' => 50])
            ->assertExitCode(0);
    }

    /**
     * Testa tratamento de erro.
     */
    public function test_command_handles_error(): void
    {
        // Arrange
        {Service}Service::partialMock()
            ->shouldReceive('process')
            ->once()
            ->andThrow(new \Exception('Erro de teste'));

        // Act
        $this->artisan('project:{nome}')
            ->expectsOutput('Erro: Erro de teste')
            ->assertExitCode(1);
    }

    /**
     * Testa confirmação do usuário.
     */
    public function test_command_confirms_action(): void
    {
        // Arrange
        {Service}Service::partialMock()
            ->shouldReceive('dangerousOperation')
            ->once()
            ->andReturn(true);

        // Act - usuário confirma
        $this->artisan('project:{nome}')
            ->expectsConfirmation('Tem certeza?', 'yes')
            ->assertExitCode(0);
    }

    /**
     * Testa cancelamento pelo usuário.
     */
    public function test_command_cancelled_by_user(): void
    {
        // Arrange - Service NÃO deve ser chamado
        {Service}Service::partialMock()
            ->shouldNotReceive('dangerousOperation');

        // Act - usuário cancela
        $this->artisan('project:{nome}')
            ->expectsConfirmation('Tem certeza?', 'no')
            ->expectsOutput('Operação cancelada.')
            ->assertExitCode(0);
    }
}
```

## Métodos de Assertion

### Básicos
```php
// Verificar código de saída
->assertExitCode(0)     // Sucesso
->assertExitCode(1)     // Falha
->assertSuccessful()    // Alias para exitCode(0)
->assertFailed()        // Alias para exitCode != 0

// Verificar output
->expectsOutput('Texto exato')
->expectsOutputToContain('Parte do texto')
->doesntExpectOutput('Não deve aparecer')
```

### Interação com Usuário
```php
// Confirmação sim/não
->expectsConfirmation('Pergunta?', 'yes')
->expectsConfirmation('Pergunta?', 'no')

// Input de texto
->expectsQuestion('Qual seu nome?', 'João')

// Escolha de opções
->expectsChoice('Selecione:', 'Opção A', ['Opção A', 'Opção B'])
```

### Tabelas
```php
->expectsTable(['Header 1', 'Header 2'], [
    ['Valor 1', 'Valor 2'],
    ['Valor 3', 'Valor 4'],
])
```

## Exemplo Completo

```php
<?php

namespace Tests\Feature\Commands;

use Tests\TestCase;
use App\Facades\Google\ProductSyncService;
use Mockery;

class SyncProductsCommandTest extends TestCase
{
    /**
     * Testa sincronização com sucesso.
     */
    public function test_sync_products_command_executes_successfully(): void
    {
        // Arrange
        ProductSyncService::partialMock()
            ->shouldReceive('sync')
            ->once()
            ->with([
                'store_id' => null,
                'limit'    => 100,
                'force'    => false,
            ])
            ->andReturn([
                'processed' => 100,
                'success'   => 95,
                'errors'    => 5,
            ]);

        // Act & Assert
        $this->artisan('project:sync-products')
            ->expectsOutput('Iniciando sincronização de produtos...')
            ->expectsTable(['Métrica', 'Valor'], [
                ['Processados', 100],
                ['Sucesso', 95],
                ['Erros', 5],
            ])
            ->expectsOutput('Sincronização concluída!')
            ->assertExitCode(0);
    }

    /**
     * Testa sincronização de loja específica.
     */
    public function test_sync_products_for_specific_store(): void
    {
        // Arrange
        ProductSyncService::partialMock()
            ->shouldReceive('sync')
            ->once()
            ->with(Mockery::on(function ($args) {
                return $args['store_id'] === '12345';
            }))
            ->andReturn([
                'processed' => 50,
                'success'   => 50,
                'errors'    => 0,
            ]);

        // Act & Assert
        $this->artisan('project:sync-products', ['storeId' => '12345'])
            ->expectsOutputToContain('Loja específica: 12345')
            ->assertExitCode(0);
    }

    /**
     * Testa sincronização com limite customizado.
     */
    public function test_sync_products_with_custom_limit(): void
    {
        // Arrange
        ProductSyncService::partialMock()
            ->shouldReceive('sync')
            ->once()
            ->with(Mockery::on(function ($args) {
                return $args['limit'] === 50;
            }))
            ->andReturn(['processed' => 50, 'success' => 50, 'errors' => 0]);

        // Act & Assert
        $this->artisan('project:sync-products', ['--limit' => 50])
            ->expectsOutput('Limite: 50 produtos por loja')
            ->assertExitCode(0);
    }

    /**
     * Testa tratamento de exceção.
     */
    public function test_sync_products_handles_exception(): void
    {
        // Arrange
        ProductSyncService::partialMock()
            ->shouldReceive('sync')
            ->once()
            ->andThrow(new \Exception('Conexão falhou'));

        // Act & Assert
        $this->artisan('project:sync-products')
            ->expectsOutput('Erro durante sincronização')
            ->assertExitCode(1);
    }

    /**
     * Testa flag --force.
     */
    public function test_sync_products_with_force_flag(): void
    {
        // Arrange
        ProductSyncService::partialMock()
            ->shouldReceive('sync')
            ->once()
            ->with(Mockery::on(function ($args) {
                return $args['force'] === true;
            }))
            ->andReturn(['processed' => 100, 'success' => 100, 'errors' => 0]);

        // Act & Assert
        $this->artisan('project:sync-products', ['--force' => true])
            ->assertExitCode(0);
    }
}
```

## Checklist

- [ ] Teste de execução com sucesso
- [ ] Teste com argumentos
- [ ] Teste com opções
- [ ] Teste de tratamento de erro
- [ ] Teste de confirmação (se aplicável)
- [ ] Mocks apenas nas Facades
- [ ] Verificação de output
- [ ] Verificação de exit code
