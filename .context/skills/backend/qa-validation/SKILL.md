# Skill: Validação de QA (Teste de Endpoints)

## Quando Usar
- Após o Coder implementar endpoints
- Para validar se os endpoints estão funcionando corretamente
- Para verificar resposta da API

## Regras Obrigatórias

### 1. Detecção de Endpoints
**ANTES DE TESTAR**: Você DEVE identificar todos os endpoints implementados:

```php
// Ler routes/api.php
$routes = file_get_contents(base_path('routes/api.php'));

// Detectar rotas criadas recentemente (pelo Coder)
Route::post('/logout', ...
Route::get('/user', ...
```

### 2. Métodos de Teste

| Método HTTP | Ação de Teste |
|-------------|---------------|
| GET | curl sem corpo |
| POST | curl com corpo JSON vazio ou dados mínimos |
| PUT/PATCH | curl com dados |
| DELETE | curl para delete |

### 3. Validação de Resposta

**Status Codes Válidos**:
- `200` - OK
- `201` - Created
- `204` - No Content
- `401` - Unauthorized (esperado se não autenticado)
- `422` - Validation Error (esperado se dados inválidos)
- `500` - Server Error (FALHA)

### 4. Comandos de Teste

```bash
# GET
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/api/endpoint

# POST
curl -s -X POST -w "%{http_code}" http://localhost:8000/api/endpoint

# Com dados
curl -s -X POST -H "Content-Type: application/json" \
  -d '{"email":"test@example.com"}' \
  http://localhost:8000/api/login
```

### 5. Servidor Laravel

**Iniciar servidor** (se não estiver rodando):
```bash
# Docker
docker compose up -d

# ou artisan serve
php artisan serve --host=0.0.0.0 --port=8000
```

## Checklist de Validação

- [ ] Identificar todos os endpoints implementados
- [ ] Verificar se servidor está rodando
- [ ] Testar cada endpoint com curl
- [ ] Validar status code returned
- [ ] Documentar resultados

## Saída Esperada

Retorne um relatório em Markdown:

```markdown
# QA Validation Report

## Endpoints Testados

| Method | Endpoint | Status | Result |
|--------|----------|--------|--------|
| POST | /api/logout | 200 | ✅ OK |
| GET | /api/user | 401 | ✅ Unauthorized (esperado) |

## Resumo

- Total: 4
- ✅ Passou: 3
- ❌ Falhou: 1

## Falhas

1. GET /api/products - 500 (verificar logs)
```
