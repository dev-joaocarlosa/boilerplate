# Skill: Code Review Manual

## Quando Usar
- Revisar código de arquivos específicos
- Analisar qualidade antes de commit
- Verificar aderência aos padrões do projeto

> **Nota**: Para MRs do GitHub, prefira o comando `CR: [URL]` configurado no `.cursorrules`

## Workflow

### 1. Identificar Arquivos
Receber lista de arquivos ou usar contexto atual.

### 2. Ler e Analisar
Para cada arquivo:
- Ler conteúdo completo
- Identificar padrões violados
- Verificar boas práticas

### 3. Classificar Problemas
- 🔴 **IMPEDITIVO**: Deve ser corrigido
- ⚠️ **MELHORIA**: Sugestão de melhoria
- ✅ **POSITIVO**: Boas práticas encontradas

### 4. Gerar Relatório
```markdown
## Arquivo: {path}

### ✅ Pontos Positivos
- ...

### 🔴 Problemas Críticos
1. **Linha X**: {descrição}
   - Atual: `{código atual}`
   - Sugestão: `{código sugerido}`

### ⚠️ Melhorias Sugeridas
1. **Linha X**: {descrição}
```

## Critérios de Avaliação

### Obrigatórios (Impeditivos)
- [ ] Imports corretos (sem namespace completo inline)
- [ ] ENUMs para strings de mensagem/status
- [ ] Helpers para dados do shop (store_id(), account_id())
- [ ] Exception completa em logs (não getMessage())
- [ ] Testes existem para código novo
- [ ] **API**: Nenhum import V1 (`Google\Shopping\Product\*`) em Services de negócio
- [ ] **API**: Nenhum import V1 (`Google\Shopping\Product\*`) em arquivos de teste

### Qualidade (Melhorias)
- [ ] Métodos <= 20 linhas
- [ ] Classes <= 200 linhas
- [ ] Early returns (sem else desnecessário)
- [ ] PHPDoc completo em interfaces
- [ ] Cobertura de testes >= 80%

### Arquitetura
- [ ] Service implementa Interface
- [ ] Facade atualizada com @method
- [ ] Repository para acesso a dados
- [ ] Entidades com PHPDoc @property

## Exemplo de Output

```markdown
## Arquivo: app/Services/Google/CampaignService.php

### ✅ Pontos Positivos
- Boa estrutura de métodos privados
- Try/catch adequado
- Logs informativos

### 🔴 Problemas Críticos
1. **Linha 45**: Namespace completo inline
   - Atual: `new \App\Entities\Google\CampaignEntity()`
   - Sugestão: Adicionar `use App\Entities\Google\CampaignEntity;`

2. **Linha 78**: getMessage() em log
   - Atual: `['message' => $e->getMessage()]`
   - Sugestão: `['exception' => $e]`

### ⚠️ Melhorias Sugeridas
1. **Linha 23-67**: Método muito longo (44 linhas)
   - Sugestão: Extrair para métodos privados

2. **Linha 89**: Poderia usar early return
   - Atual: `if (x) { return a; } else { return b; }`
   - Sugestão: `if (x) { return a; } return b;`
```

## Referências
- Critérios detalhados: `.cursor/rules/code-review/criteria.mdc`
- Exemplos: `.cursor/rules/code-review/examples.mdc`
- Padrões do projeto: `.cursor/rules/project.mdc`
