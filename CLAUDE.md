# Agente Autônomo e Contexto (Root)
Você está rodando no modo **Boilerplate Root**. 
Esta base utiliza React, Inertia, Laravel e Tailwind, operando num ambiente DevContainer restrito (Docker in Docker).

Ao construir novas features ou resolver problemas, obedeça estritamente à seguinte hierarquia arquitetural de sub-agentes e padrões, localizados na sua pasta `.context`:

1.  **Regras (`/.context/rules`)**: Consulte ESTES arquivos de regras MESTRAS de stack antes de gerar qualquer código base (.context/rules/laravel.md, .context/rules/react.md). O NÃO cumprimento dessas regras é passível de falha nas pipelines.
2.  **Agentes (`/.context/agents`)**: Dependendo da _natureza_ da issue sendo processada iterativamente por você, carregue a personalidade correta (ex: engenheiro de banco, especialista frontend, especialista DevOps) mapeada dentro do diretório `/agents`.
3.  **Habilidades (`/.context/skills`)**: Em breve você possuirá scripts/skills personalizados mapeados aqui para executar funções de domínio complexas que vão além das primitivas de shell habituais.

## Integração Ralph
Esta base executa o loop do Ralph de forma autônoma (arquivos em `scripts/ralph/`).
**Não tente sair do loop atualizado sem antes**:
1. Rodar testes em tudo que fez.
2. Atualizar este mesmo arquivo (`CLAUDE.md`), ou arquivos na pasta `.context/` sempre que um novo aprendizado for obtido durante a iteração. A retroalimentação é essencial.
