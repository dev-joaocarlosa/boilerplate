# Regras e Padrões de Backend (Laravel 12 + PHP 8.3)

Este arquivo define as restrições e boas práticas na arquitetura backend que todo desenvolvimento técnico neste Boilerplate deve obedecer.

## 1. Stack Base e Padrões Modernos
- **PHP 8.3+**: Use fortemente os recursos modernos: enums, união de tipos, promotores de propriedades de construct, *read-only properties* e named arguments. Typing estrito é mandatório (`declare(strict_types=1);` onde possível).
- **Laravel 12**: Use *Dependency Injection* sempre que possível ao invés de *Facades* no domínio principal para facilitar testes, mas Facades são aceitáveis nas camadas de Controller/Routing.

## 2. Arquitetura e Componentização
- **Fat Models vs Fat Controllers**: Mantenha os Controllers finos, delegando regras de negócios complexas para **Actions**, **Services** ou métodos descritivos nos **Models**.
- Form Request Validation é obrigatório. Nunca valide no escopo do Controller (`$request->validate(...)`). Crie Requests correspondentes.
- Para respostas pro front (via Inertia), retorne sempre um `Inertia::render('Path/To/ReactComponent', ['data' => $data]);`.

## 3. Database, Eloquent e Migrations
- Queries complexas ou que exigem joins/agrupamentos devem preferencialmente usar DB Raw Queries focadas ou Eloquent Resources otimizados. Evite o N+1 problem ativamente utilizando eager loading (`with('relations')`).
- Sempre declare tipos de retorno nos métodos de relacionamento Eloquent (`BelongsTo`, `HasMany`, etc).
- Use Model Observers, Events e Listeners fortemente se houver triggers a serem escalonados assincronamente (e delegue disparos pesados para o *Queue System/Jobs*).

## 4. Testes
- Todos os endpoints e lógicas críticas devem ser acompanhadas de um Feature ou Unit Test em Pest ou PHPUnit na pasta `tests/`. O agente nunca conclui uma tarefa que não passe pelos testes de backend providenciados pelo `./vendor/bin/pest` ou equivalente.
