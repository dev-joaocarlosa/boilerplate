---
name: final_verification
agent: qa_engineer
variables:
  - requirement
  - implemented_code
---

# Description

Realize verificação final antes do commit.

**Requisito original:**
{{requirement}}

**Código implementado:**
{{implemented_code}}

## Checklist de Verificação

### 1. Código existe e compila
- [ ] Todos os arquivos foram criados
- [ ] Sem erros de sintaxe
- [ ] Imports corretos

### 2. Padrões seguidos
- [ ] Services implementam Interfaces
- [ ] Controllers delegam para Services
- [ ] Vue usa Composition API + TypeScript
- [ ] ENUMs para strings de status

### 3. Testes
- [ ] Testes unitários existem
- [ ] Testes passam

### 4. Requisito atendido
- [ ] Funcionalidade implementada conforme solicitado
- [ ] Critérios de aceite atendidos

## Processo

1. Verifique se todos os arquivos existem
2. Execute os testes
3. Valide contra o requisito original
4. Aprove ou reprove com justificativa

---

# Expected Output

## Verificação Final

### Status: [APROVADO PARA COMMIT ✅ / REPROVADO ❌]

### Checklist
| Item | Status | Observação |
|------|--------|------------|
| Código existe | ✅/❌ | [obs] |
| Sem erros de sintaxe | ✅/❌ | [obs] |
| Padrões seguidos | ✅/❌ | [obs] |
| Testes passam | ✅/❌ | [obs] |
| Requisito atendido | ✅/❌ | [obs] |

### Se APROVADO:

#### Arquivos para commit:
```
[lista de arquivos]
```

#### Sugestão de mensagem de commit:
```
[tipo]: [descrição curta]

[descrição detalhada se necessário]
```

---

### Se REPROVADO:

#### Motivo:
[explicação detalhada do que falta]

#### Próximos passos:
1. [ação necessária 1]
2. [ação necessária 2]
