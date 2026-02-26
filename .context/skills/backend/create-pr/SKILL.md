# Skill: Criar Pull Request (GitHub)

## Quando Usar
- Implementação concluída
- Pronto para review
- Branch com commits finalizados

## Pré-requisitos

### OBRIGATÓRIO: URL da Issue
A skill DEVE receber a URL da issue do GitHub. Se não fornecida, solicitar ao usuário.

### Formato da URL
```
https://github.com/{owner}/{repo}/issues/{numero}
```

### Exemplo
```
https://github.com/meu-usuario/meu-projeto/issues/123
```

## Workflow

### 1. Extrair Informações da Issue
```
URL: https://github.com/meu-usuario/meu-projeto/issues/123
  ├── Owner: meu-usuario
  ├── Repo: meu-projeto
  ├── Número: 123
  └── Referência: #123
```

### 2. Buscar Título da Issue
Usar GitHub CLI:
```bash
gh issue view 123 --repo meu-usuario/meu-projeto --json title
```

### 3. Verificar Branch
```bash
# Branch atual
git branch --show-current

# Verificar se está atualizada com remote
git status

# Verificar commits não pushados
git log origin/{branch}..HEAD
```

### 4. Push da Branch (se necessário)
```bash
git push -u origin HEAD
```

### 5. Gerar Título do PR
```
#{numero} - {titulo_issue}
```

**Exemplo:**
```
#123 - Implementar endpoint de listagem de campanhas
```

### 6. Gerar Descrição
```markdown
## Descrição
{descrição_breve_das_mudanças}

## Mudanças
- {mudança_1}
- {mudança_2}
- {mudança_3}

## Testes
- [ ] Testes unitários adicionados/atualizados
- [ ] Testes de feature adicionados/atualizados
- [ ] Testes passando localmente

## Checklist
- [ ] Código segue padrões do projeto
- [ ] Validações passam (lint, type-check)
- [ ] Documentação atualizada (se aplicável)

Closes #123
```

### 7. Criar PR via GitHub CLI
```bash
gh pr create \
  --title "#123 - Título da Issue" \
  --body "$(cat <<'EOF'
## Descrição
Descrição das mudanças

## Mudanças
- Mudança 1
- Mudança 2

## Checklist
- [x] Testes passando
- [x] Lint passando

Closes #123
EOF
)" \
  --base main
```

### 8. Retornar URL do PR
```
PR criado com sucesso!
URL: https://github.com/meu-usuario/meu-projeto/pull/456
```

## Formato do Título

```
#{numero} - {titulo_issue}
```

### Exemplos
```
#123 - Implementar endpoint de listagem de campanhas
#124 - Corrigir bug na sincronização de produtos
#125 - Refatorar CampaignService
```

## Formato da Descrição

### Template Padrão
```markdown
## Contexto

**Por que essa mudança é necessária?**

{explicar_motivacao_da_mudanca}

**Como o problema foi atacado?**

{explicar_logica_utilizada}

**Quais os efeitos dessa implementação?**

{explicar_o_que_muda_no_sistema}

---

## Checklist
- [ ] Testes unitários passando
- [ ] Lint/type-check passando
- [ ] Documentação atualizada (se aplicável)
- [ ] Não há conflitos com a branch base

Closes #{numero}
```

### Exemplo para Features
```markdown
## Contexto

**Por que essa mudança é necessária?**

Implementação do endpoint de listagem de campanhas conforme solicitado na issue #123, para permitir que o frontend exiba as campanhas do usuário.

**Como o problema foi atacado?**

Criado `CampaignService` que consulta o banco de dados, aplica filtros e retorna os dados formatados. O controller recebe a requisição, valida os parâmetros e delega ao service.

**Quais os efeitos dessa implementação?**

Agora o sistema possui um endpoint `/api/campaigns` que retorna a lista de campanhas do usuário autenticado.

---

## Checklist
- [x] Testes unitários passando
- [x] Lint/type-check passando
- [x] Documentação atualizada

Closes #123
```

### Exemplo para Bugfixes
```markdown
## Contexto

**Por que essa mudança é necessária?**

Correção do bug reportado na issue #124, onde a paginação de produtos retornava dados duplicados quando o usuário navegava entre páginas.

**Como o problema foi atacado?**

Identificado que o offset estava sendo calculado incorretamente no `ProductService`. Corrigido o cálculo para `(page - 1) * perPage` e adicionado ordenação por ID para garantir consistência.

**Quais os efeitos dessa implementação?**

Agora a paginação de produtos funciona corretamente, sem duplicações ou itens faltantes.

---

## Checklist
- [x] Testes unitários passando
- [x] Lint/type-check passando

Closes #124
```

## Verificações Pré-PR

```bash
# 1. Validações de código (Laravel)
./vendor/bin/pint --test
./vendor/bin/phpstan analyse

# 1. Validações de código (Node)
npm run lint
npm run type-check

# 2. Testes
php artisan test  # ou npm test

# 3. Status do git
git status

# 4. Commits organizados
git log --oneline origin/main..HEAD
```

## Comandos Úteis

```bash
# Ver branch atual
git branch --show-current

# Push inicial
git push -u origin HEAD

# Ver diferença com main
git diff main...HEAD --stat

# Ver arquivos alterados
git diff main...HEAD --name-only

# Listar PRs abertos
gh pr list

# Ver PR específico
gh pr view 456
```

## Erros Comuns

### Branch não existe no remote
```bash
git push -u origin HEAD
```

### Conflitos com main
```bash
git fetch origin
git rebase origin/main
# Resolver conflitos
git push --force-with-lease
```

### PR já existe para a branch
Verificar se já existe PR:
```bash
gh pr list --head $(git branch --show-current)
```

## Checklist

- [ ] URL da issue fornecida
- [ ] Título extraído corretamente
- [ ] Branch atualizada no remote
- [ ] Validações passando
- [ ] Testes passando
- [ ] Descrição completa
- [ ] `Closes #{numero}` na descrição
- [ ] PR criado com sucesso
- [ ] URL do PR retornada
