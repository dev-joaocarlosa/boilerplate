# Sistema de Code Review

Este diretório contém a documentação modular do sistema de code review automatizado.

## 📁 Estrutura

```
code-review/
├── README.md      # Esta documentação
├── index.mdc      # Processo principal e formato de resposta
├── criteria.mdc   # Critérios técnicos de avaliação
└── examples.mdc   # Exemplos práticos de sugestões
```

## 🔗 Referências Cruzadas

- **Fluxo completo**: Veja `index.mdc` para o processo de 6 etapas
- **Critérios**: Veja `criteria.mdc` para detalhes de validação
- **Exemplos**: Veja `examples.mdc` para modelos de sugestões

## 🚀 Como Usar

1. O sistema é acionado pelo comando `CR: [URL_MR]`
2. Configurado no `.cursorrules` do projeto
3. Segue os critérios definidos em `criteria.mdc`
4. Gera sugestões no formato de `examples.mdc`
