# Skill: Criar Enum

## Quando Usar
- Mensagens de erro padronizadas
- Status/estados fixos
- Tipos categorizados
- Constantes com significado de negócio

## Estrutura

### Localização
```
app/Enums/{Namespace}/{Nome}Enum.php
```

### Template - Enum de Mensagens
```php
<?php

namespace App\Enums\{Namespace};

/**
 * Enum com mensagens de erro para {contexto}.
 */
enum {Nome}MessageEnum: string
{
    case RESOURCE_NOT_FOUND      = 'Recurso não encontrado.';
    case INVALID_PARAMETER       = 'Parâmetro inválido.';
    case OPERATION_FAILED        = 'Falha ao executar operação.';
    case UNAUTHORIZED_ACCESS     = 'Acesso não autorizado.';
    case VALIDATION_ERROR        = 'Erro de validação.';
}
```

### Template - Enum de Status
```php
<?php

namespace App\Enums\{Namespace};

/**
 * Enum com status possíveis para {contexto}.
 */
enum {Nome}StatusEnum: string
{
    case ACTIVE   = 'active';
    case INACTIVE = 'inactive';
    case PENDING  = 'pending';
    case DELETED  = 'deleted';

    /**
     * Verifica se o status é ativo.
     */
    public function isActive(): bool
    {
        return $this === self::ACTIVE;
    }

    /**
     * Retorna os status editáveis.
     *
     * @return array<self>
     */
    public static function editableStatuses(): array
    {
        return [
            self::ACTIVE,
            self::INACTIVE,
            self::PENDING,
        ];
    }
}
```

### Template - Enum de Tipos
```php
<?php

namespace App\Enums\{Namespace};

/**
 * Enum com tipos de {contexto}.
 */
enum {Nome}TypeEnum: string
{
    case TEXT    = 'TEXT';
    case IMAGE   = 'IMAGE';
    case VIDEO   = 'VIDEO';
    case LOGO    = 'LOGO';

    /**
     * Retorna o tipo de mídia correspondente.
     */
    public function getMediaType(): string
    {
        return match ($this) {
            self::TEXT           => 'text/plain',
            self::IMAGE, self::LOGO => 'image/*',
            self::VIDEO          => 'video/*',
        };
    }

    /**
     * Verifica se é tipo visual (imagem ou vídeo).
     */
    public function isVisual(): bool
    {
        return in_array($this, [self::IMAGE, self::VIDEO, self::LOGO]);
    }
}
```

## Padrões

### Nomenclatura
- **Cases**: UPPER_SNAKE_CASE
- **Classe**: PascalCase + sufixo descritivo (`Enum`, `MessageEnum`, `StatusEnum`, `TypeEnum`)
- **Valores**: Consistentes (strings em português para mensagens, inglês para códigos)

### Backed Enums
Sempre usar backed enums (`: string` ou `: int`):

```php
// ✅ CORRETO - Backed enum
enum StatusEnum: string
{
    case ACTIVE = 'active';
}

// ❌ EVITAR - Pure enum
enum StatusEnum
{
    case ACTIVE;
}
```

## Exemplos por Domínio

### Google/Ads
```php
<?php

namespace App\Enums\Google;

/**
 * Enum com mensagens de erro do Google Ads.
 */
enum GoogleAdsErrorMessageEnum: string
{
    case CAMPAIGN_NOT_FOUND        = 'Campanha não encontrada.';
    case CAMPAIGN_CREATION_FAILED  = 'Falha ao criar campanha.';
    case BUDGET_TOO_LOW            = 'Orçamento abaixo do mínimo permitido.';
    case INVALID_TARGETING         = 'Configuração de targeting inválida.';
    case ASSET_UPLOAD_FAILED       = 'Falha ao fazer upload do asset.';
    case ACCOUNT_NOT_LINKED        = 'Conta do Google Ads não vinculada.';
}
```

### Google/ProductCenter
```php
<?php

namespace App\Enums\Google;

/**
 * Enum com status de produtos do Product Center.
 */
enum ProductStatusEnum: string
{
    case APPROVED    = 'approved';
    case PENDING     = 'pending';
    case DISAPPROVED = 'disapproved';
    case EXPIRING    = 'expiring';

    /**
     * Verifica se o produto está ativo.
     */
    public function isActive(): bool
    {
        return in_array($this, [self::APPROVED, self::EXPIRING]);
    }

    /**
     * Retorna label para exibição.
     */
    public function getLabel(): string
    {
        return match ($this) {
            self::APPROVED    => 'Aprovado',
            self::PENDING     => 'Pendente',
            self::DISAPPROVED => 'Reprovado',
            self::EXPIRING    => 'Expirando',
        };
    }
}
```

### Project
```php
<?php

namespace App\Enums\Project;

/**
 * Enum com tipos de asset do Project.
 */
enum AssetTypeEnum: string
{
    case HEADLINE         = 'HEADLINE';
    case LONG_HEADLINE    = 'LONG_HEADLINE';
    case DESCRIPTION      = 'DESCRIPTION';
    case BUSINESS_NAME    = 'BUSINESS_NAME';
    case MARKETING_IMAGE  = 'MARKETING_IMAGE';
    case SQUARE_IMAGE     = 'SQUARE_IMAGE';
    case LOGO             = 'LOGO';
    case YOUTUBE_VIDEO    = 'YOUTUBE_VIDEO';

    /**
     * Verifica se é asset de texto.
     */
    public function isText(): bool
    {
        return in_array($this, [
            self::HEADLINE,
            self::LONG_HEADLINE,
            self::DESCRIPTION,
            self::BUSINESS_NAME,
        ]);
    }

    /**
     * Verifica se é asset de imagem.
     */
    public function isImage(): bool
    {
        return in_array($this, [
            self::MARKETING_IMAGE,
            self::SQUARE_IMAGE,
            self::LOGO,
        ]);
    }

    /**
     * Retorna limite de caracteres (para text assets).
     */
    public function getCharLimit(): ?int
    {
        return match ($this) {
            self::HEADLINE       => 30,
            self::LONG_HEADLINE  => 90,
            self::DESCRIPTION    => 90,
            self::BUSINESS_NAME  => 25,
            default              => null,
        };
    }
}
```

## Uso do Enum

### Em Exceções
```php
throw new ClientException(GoogleAdsErrorMessageEnum::CAMPAIGN_NOT_FOUND->value);
```

### Em Validações
```php
$status = ProductStatusEnum::from($input['status']);

if (!$status->isActive()) {
    throw new ClientException('Produto inativo');
}
```

### Em Condições
```php
if ($asset->type === AssetTypeEnum::HEADLINE) {
    // ...
}
```

### Listagem de Valores
```php
$statuses = array_column(ProductStatusEnum::cases(), 'value');
// ['approved', 'pending', 'disapproved', 'expiring']
```

### TryFrom (Sem Exception)
```php
$status = ProductStatusEnum::tryFrom($input['status']);

if ($status === null) {
    // Status inválido
}
```

## Métodos Úteis

### Obter Todos os Values
```php
public static function values(): array
{
    return array_column(self::cases(), 'value');
}
```

### Obter Labels para Select
```php
public static function options(): array
{
    return array_map(
        fn(self $case) => [
            'value' => $case->value,
            'label' => $case->getLabel(),
        ],
        self::cases()
    );
}
```

### Verificar se Valor é Válido
```php
public static function isValid(string $value): bool
{
    return self::tryFrom($value) !== null;
}
```

## Checklist

- [ ] Arquivo em `app/Enums/{Namespace}/`
- [ ] Nome descritivo com sufixo adequado
- [ ] Backed enum (`: string` ou `: int`)
- [ ] Cases em UPPER_SNAKE_CASE
- [ ] PHPDoc com descrição
- [ ] Métodos auxiliares quando necessário
- [ ] Mensagens em português (para MessageEnum)
- [ ] Valores consistentes
