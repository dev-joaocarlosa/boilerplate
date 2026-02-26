# Skill: Criar Entity

## Quando Usar
- Representar dados estruturados
- Mapear responses de APIs
- Encapsular dados de domínio

## Estrutura

### Localização
```
app/Entities/{Namespace}/{Nome}Entity.php
```

### Template Base
```php
<?php

namespace App\Entities\{Namespace};

use App\Entities\Entity;

/**
 * Entidade que representa {descrição}.
 *
 * @property int $id
 * @property string $name
 * @property string $status
 * @property float $budget
 * @property array $settings
 * @property \DateTime $created_at
 * @property \DateTime|null $updated_at
 */
class {Nome}Entity extends Entity
{
    //
}
```

## Padrões

### Nomenclatura
- **Classe**: PascalCase + sufixo `Entity`
- **Namespace**: Organizado por domínio (Google, Project, Store)
- **Propriedades**: snake_case no PHPDoc

### PHPDoc de Propriedades
```php
/**
 * @property int $id                     Tipo primitivo obrigatório
 * @property string|null $name           Tipo primitivo nullable
 * @property float $amount               Números decimais
 * @property bool $active                Booleanos
 * @property array $items                Arrays genéricos
 * @property array<int, string> $tags    Arrays tipados
 * @property CampaignEntity $campaign    Entidade relacionada
 * @property CampaignEntity[] $campaigns Array de entidades
 * @property \DateTime $created_at       Datas
 * @property \DateTime|null $deleted_at  Datas nullable
 */
```

### Tipos Comuns

| Tipo | Quando Usar |
|------|-------------|
| `int` | IDs, contadores, quantidades |
| `string` | Textos, identificadores |
| `float` | Valores monetários, percentuais |
| `bool` | Flags, estados binários |
| `array` | Listas, configurações |
| `\DateTime` | Datas e timestamps |
| `Entity` | Relacionamentos |

## Exemplos por Domínio

### Google/Ads
```php
<?php

namespace App\Entities\Google;

use App\Entities\Entity;

/**
 * Entidade que representa uma campanha do Google Ads.
 *
 * @property int $id
 * @property string $resource_name
 * @property string $name
 * @property string $status
 * @property float $daily_budget
 * @property float $total_budget
 * @property string $bidding_strategy_type
 * @property array $targeting
 * @property \DateTime $start_date
 * @property \DateTime|null $end_date
 * @property \DateTime $created_at
 * @property \DateTime $updated_at
 */
class CampaignEntity extends Entity
{
    //
}
```

### Google/ProductCenter
```php
<?php

namespace App\Entities\Google;

use App\Entities\Entity;

/**
 * Entidade que representa um produto no Product Center.
 *
 * @property string $id
 * @property string $offer_id
 * @property string $title
 * @property string $description
 * @property string $link
 * @property string $image_link
 * @property float $price
 * @property string $currency
 * @property string $availability
 * @property string $condition
 * @property string $brand
 * @property string $gtin
 * @property string $mpn
 * @property array $additional_image_links
 * @property array $product_types
 * @property array $custom_labels
 */
class ProductEntity extends Entity
{
    //
}
```

### Project
```php
<?php

namespace App\Entities\Project;

use App\Entities\Entity;

/**
 * Entidade que representa uma conta Project.
 *
 * @property int $id
 * @property int $store_id
 * @property string $ads_customer_id
 * @property string $product_id
 * @property string $status
 * @property bool $is_active
 * @property array $settings
 * @property \DateTime $created_at
 * @property \DateTime|null $linked_at
 */
class AccountEntity extends Entity
{
    //
}
```

## Uso da Entity

### Criação
```php
$entity = new CampaignEntity([
    'id'           => 123,
    'name'         => 'Campanha Teste',
    'status'       => 'ENABLED',
    'daily_budget' => 100.00,
]);
```

### Acesso
```php
$id     = $entity->id;
$name   = $entity->name;
$budget = $entity->daily_budget;
```

### Conversão
```php
// Para array
$array = $entity->toArray();

// Para JSON
$json = json_encode($entity);
```

### Fill
```php
$entity->fill([
    'status' => 'PAUSED',
    'daily_budget' => 50.00,
]);
```

## Relacionamentos

### Entity com Entity
```php
/**
 * @property CampaignEntity $campaign
 * @property AssetGroupEntity[] $asset_groups
 */
class AdGroupEntity extends Entity
{
    //
}
```

### Uso
```php
// Atribuir entidade relacionada
$adGroup = new AdGroupEntity([
    'campaign' => new CampaignEntity(['id' => 1]),
]);

// Acessar
$campaignId = $adGroup->campaign->id;
```

## Checklist

- [ ] Arquivo em `app/Entities/{Namespace}/`
- [ ] Nome termina com `Entity`
- [ ] Estende `App\Entities\Entity`
- [ ] PHPDoc com descrição da entidade
- [ ] Todas as propriedades documentadas com `@property`
- [ ] Tipos corretos nas propriedades
- [ ] Nullable marcado quando apropriado (`|null`)
- [ ] Relacionamentos tipados corretamente
