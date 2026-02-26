# Skill: Validações de Código

## Quando Usar
- Antes de commit
- Para verificar padrões
- Corrigir formatação
- Validar qualidade do código

## Comandos Disponíveis

### Pint (PSR-12 Formatting)
```bash
# Verificar (dry-run)
docker compose exec -T app ./vendor/bin/pint --test

# Corrigir automaticamente
docker compose exec -T app ./vendor/bin/pint

# Arquivo específico
docker compose exec -T app ./vendor/bin/pint app/Services/Google/CampaignService.php
```

### PHPMD (Mess Detector)
```bash
# Verificar todo o projeto
docker compose exec -T app ./vendor/bin/phpmd app/ text phpmd-ruleset.xml

# Arquivo específico
docker compose exec -T app ./vendor/bin/phpmd app/Services/Google/CampaignService.php text phpmd-ruleset.xml
```

### PHPStan (Static Analysis)
```bash
# Nível 3 (padrão do projeto)
docker compose exec -T app ./vendor/bin/phpstan analyse -l 3 app/

# Arquivo específico
docker compose exec -T app ./vendor/bin/phpstan analyse -l 3 app/Services/Google/CampaignService.php
```

### PHPCS (Code Sniffer)
```bash
# PSR-12
docker compose exec -T app ./vendor/bin/phpcs app/ --standard=PSR12

# Arquivo específico
docker compose exec -T app ./vendor/bin/phpcs app/Services/Google/CampaignService.php --standard=PSR12
```

### GrumPHP (Validação Completa)
```bash
docker compose exec -T app ./vendor/bin/grumphp run
```

### Script Completo
```bash
docker compose exec -T app ./code_validations.sh
```

## Workflow de Correção

### 1. Executar Validações
```bash
docker compose exec -T app ./code_validations.sh
```

### 2. Interpretar Resultados

#### Pint
```
1 file changed
app/Services/Google/CampaignService.php
```
→ Arquivo foi formatado automaticamente

#### PHPMD
```
app/Services/Google/CampaignService.php:45  The method create() has a Cyclomatic Complexity of 12.
```
→ Método muito complexo, considerar refatoração

#### PHPStan
```
app/Services/Google/CampaignService.php:67  Parameter $data of method create() has no type declaration.
```
→ Adicionar type hint ao parâmetro

### 3. Corrigir Problemas
Priorizar na ordem:
1. **PHPStan**: Erros de tipo
2. **PHPMD**: Complexidade
3. **Pint**: Formatação (automático)

### 4. Verificar Novamente
```bash
docker compose exec -T app ./code_validations.sh
```

## Erros Comuns

### PHPMD - Cyclomatic Complexity
**Problema**: Método muito complexo

**Solução**: Extrair lógica para métodos privados

### PHPStan - Missing Type
**Problema**: Parâmetro/retorno sem tipo

**Solução**: Adicionar type hints e PHPDoc

### Pint - Formatting
**Problema**: Formatação incorreta

**Solução**: Executar `./vendor/bin/pint` (automático)

## Comandos Rápidos por Situação

| Situação | Comando |
|----------|---------|
| Verificar tudo | `./code_validations.sh` |
| Formatar código | `./vendor/bin/pint` |
| Verificar tipos | `./vendor/bin/phpstan analyse -l 3 app/` |
| Verificar complexidade | `./vendor/bin/phpmd app/ text phpmd-ruleset.xml` |
| Pré-commit | `./vendor/bin/grumphp run` |

## Integração com Git

O GrumPHP está configurado para rodar automaticamente no pre-commit.
Se falhar, o commit será bloqueado até que os problemas sejam corrigidos.
