# Skill: Criar Commit com Referência de Issue

## Quando Usar
- Ao finalizar implementação
- Quando há issue do GitHub vinculada
- Para manter rastreabilidade

## Formato do Commit

```
#{numero} - {titulo_issue}

{tipo}: {descricao_curta}

- {detalhe_1}
- {detalhe_2}
```

### Exemplo
```
#123 - Implementar endpoint de listagem de campanhas

feat: adiciona endpoint GET /api/campaigns

- CampaignController com método index
- CampaignService com lógica de listagem
- Testes unitários e feature
```

## Tipos de Commit

| Tipo | Quando Usar |
|------|-------------|
| `feat` | Nova funcionalidade |
| `fix` | Correção de bug |
| `refactor` | Refatoração sem mudança de comportamento |
| `test` | Adição/modificação de testes |
| `docs` | Documentação |
| `style` | Formatação, sem mudança de código |
| `chore` | Tarefas de manutenção |

## Workflow

### 1. Receber URL da Issue
```
https://github.com/{owner}/{repo}/issues/{numero}
```

### 2. Extrair Informações
- **Owner/Repo**: `{owner}/{repo}`
- **Número**: `{numero}`
- **Referência**: `#{numero}`

### 3. Buscar Título da Issue
Usar GitHub CLI:
```bash
gh issue view {numero} --repo {owner}/{repo} --json title
```

### 4. Montar Mensagem
```bash
git commit -m "$(cat <<'EOF'
#123 - Título da Issue

feat: descrição das mudanças

- Detalhe 1
- Detalhe 2
EOF
)"
```

### 5. Executar Commit
```bash
git add .
git commit -m "mensagem"
```

## Verificações Pré-Commit

Antes de commitar, verificar:

1. **Validações de código**
   ```bash
   # Para Laravel
   ./vendor/bin/pint --test
   ./vendor/bin/phpstan analyse
   
   # Para Node/TypeScript
   npm run lint
   npm run type-check
   ```

2. **Testes**
   ```bash
   # Laravel
   php artisan test
   
   # Node
   npm test
   ```

3. **Arquivos não desejados**
   ```bash
   git status
   ```

## Exemplos por Tipo

### Feature
```
#123 - Criar serviço de notificação

feat: implementa NotificationService para alertas

- NotificationServiceInterface com métodos send e schedule
- NotificationService com implementação completa
- Testes unitários com 90% cobertura
```

### Fix
```
#124 - Corrigir erro na listagem de produtos

fix: corrige paginação na listagem de produtos

- Ajusta cálculo de offset no ProductRepository
- Adiciona validação de página mínima
- Testa cenário de página inválida
```

### Refactor
```
#125 - Refatorar CampaignService

refactor: extrai lógica de validação para método privado

- validateCampaignData() criado
- Reduz complexidade ciclomática
- Melhora legibilidade
```

### Test
```
#126 - Adicionar testes faltantes

test: adiciona testes para cenários de exceção

- Testa ClientException em create()
- Testa ValidationException em update()
- Cobertura aumentada para 85%
```

## Comandos Úteis

```bash
# Ver arquivos alterados
git diff --name-only

# Ver mudanças detalhadas
git diff

# Adicionar arquivos específicos
git add app/Services/CampaignService.php

# Verificar o que será commitado
git diff --cached

# Commit com editor
git commit

# Commit direto
git commit -m "mensagem"

# Alterar último commit (se não foi pushed)
git commit --amend
```

## Checklist

- [ ] Validações de código passam
- [ ] Testes passam
- [ ] Arquivos corretos adicionados
- [ ] Mensagem segue formato padrão
- [ ] Referência da issue presente
- [ ] Tipo de commit adequado
- [ ] Descrição clara e concisa
