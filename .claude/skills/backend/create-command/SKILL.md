# Skill: Criar Artisan Command

## Quando Usar
- Tarefas agendadas
- Processamento em background
- Scripts de migração
- Comandos CLI

## Estrutura

### Localização
```
app/Console/Commands/{Nome}Command.php
```

### Template Base
```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Facades\{Namespace}\{Service}Service;
use App\Support\Logging\ApiLog;

/**
 * Comando para {descrição do que faz}.
 *
 * Exemplos de uso:
 *   php artisan project:{nome}
 *   php artisan project:{nome} --option=value
 *   php artisan project:{nome} argument
 */
class {Nome}Command extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'project:{nome}
        {argument? : Descrição do argumento opcional}
        {--option= : Descrição da opção}
        {--flag : Descrição da flag booleana}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Descrição breve do comando';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('Iniciando {nome}...');

        try {
            $argument = $this->argument('argument');
            $option   = $this->option('option');
            $flag     = $this->option('flag');

            ApiLog::info('Project - {Nome}Command - handle - Starting', [
                'argument' => $argument,
                'option'   => $option,
            ]);

            // Lógica do comando
            $result = {Service}Service::process($argument, $option);

            ApiLog::info('Project - {Nome}Command - handle - Completed', [
                'result' => $result,
            ]);

            $this->info('Comando executado com sucesso!');

            return Command::SUCCESS;

        } catch (\Exception $exception) {
            ApiLog::error('Project - {Nome}Command - handle - Error', [
                'exception' => $exception,
            ]);

            $this->error('Erro: ' . $exception->getMessage());

            return Command::FAILURE;
        }
    }
}
```

## Padrões

### Nomenclatura da Signature
- Prefixo: `project:`
- Nome: kebab-case
- Exemplo: `project:sync-products`, `project:process-queue`

### Argumentos e Opções
```php
// Argumento obrigatório
{storeId : ID da loja}

// Argumento opcional
{storeId? : ID da loja (opcional)}

// Argumento com valor padrão
{storeId=all : ID da loja ou "all" para todas}

// Opção com valor
{--limit= : Limite de registros}

// Opção com valor padrão
{--limit=100 : Limite de registros (default: 100)}

// Flag booleana
{--force : Força execução sem confirmação}

// Opção com alias
{--Q|queue : Processar em queue}
```

### Output
```php
// Informação
$this->info('Mensagem informativa');

// Sucesso
$this->line('<fg=green>Sucesso!</>');

// Aviso
$this->warn('Atenção: mensagem');

// Erro
$this->error('Erro: mensagem');

// Tabela
$this->table(['ID', 'Nome', 'Status'], $data);

// Barra de progresso
$bar = $this->output->createProgressBar(count($items));
foreach ($items as $item) {
    // processar
    $bar->advance();
}
$bar->finish();

// Confirmação
if ($this->confirm('Deseja continuar?')) {
    // ...
}

// Input
$name = $this->ask('Qual o nome?');

// Input secreto
$password = $this->secret('Senha:');

// Escolha
$option = $this->choice('Selecione:', ['A', 'B', 'C']);
```

### Códigos de Retorno
```php
return Command::SUCCESS;   // 0 - Sucesso
return Command::FAILURE;   // 1 - Erro
return Command::INVALID;   // 2 - Entrada inválida
```

## Exemplo Completo

```php
<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Facades\Google\ProductSyncService;
use App\Support\Logging\ApiLog;

/**
 * Comando para sincronizar produtos com o Google Product Center.
 *
 * Exemplos de uso:
 *   php artisan project:sync-products
 *   php artisan project:sync-products 12345
 *   php artisan project:sync-products --limit=50
 *   php artisan project:sync-products --force
 */
class SyncProductsCommand extends Command
{
    /**
     * @var string
     */
    protected $signature = 'project:sync-products
        {storeId? : ID específico da loja para sincronizar}
        {--limit=100 : Limite de produtos por loja}
        {--force : Força sincronização mesmo com erros}';

    /**
     * @var string
     */
    protected $description = 'Sincroniza produtos das lojas com o Google Product Center';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $storeId = $this->argument('storeId');
        $limit   = (int) $this->option('limit');
        $force   = $this->option('force');

        $this->info('Iniciando sincronização de produtos...');
        $this->line("Limite: {$limit} produtos por loja");

        if ($storeId) {
            $this->line("Loja específica: {$storeId}");
        }

        try {
            ApiLog::info('Project - SyncProductsCommand - handle - Starting', [
                'store_id' => $storeId,
                'limit'    => $limit,
                'force'    => $force,
            ]);

            $result = ProductSyncService::sync([
                'store_id' => $storeId,
                'limit'    => $limit,
                'force'    => $force,
            ]);

            $this->table(
                ['Métrica', 'Valor'],
                [
                    ['Processados', $result['processed']],
                    ['Sucesso', $result['success']],
                    ['Erros', $result['errors']],
                ]
            );

            ApiLog::info('Project - SyncProductsCommand - handle - Completed', [
                'result' => $result,
            ]);

            $this->info('Sincronização concluída!');

            return Command::SUCCESS;

        } catch (\Exception $exception) {
            ApiLog::error('Project - SyncProductsCommand - handle - Error', [
                'exception' => $exception,
            ]);

            $this->error('Erro durante sincronização');

            if ($this->getOutput()->isVerbose()) {
                $this->error($exception->getMessage());
            }

            return Command::FAILURE;
        }
    }
}
```

## Registro do Comando

### Em app/Console/Kernel.php
```php
protected $commands = [
    \App\Console\Commands\SyncProductsCommand::class,
];
```

### Ou Auto-Discovery
Laravel auto-descobre commands em `app/Console/Commands`.

## Agendamento

### Em app/Console/Kernel.php
```php
protected function schedule(Schedule $schedule): void
{
    $schedule->command('project:sync-products')
        ->hourly()
        ->withoutOverlapping()
        ->runInBackground();
}
```

## Checklist

- [ ] Nome segue padrão `project:{nome-em-kebab}`
- [ ] PHPDoc com exemplos de uso
- [ ] Argumentos e opções documentados na signature
- [ ] Logs no início e fim da execução
- [ ] Try/catch com tratamento de erro
- [ ] Retorno de código correto (SUCCESS/FAILURE)
- [ ] Output informativo para o usuário
