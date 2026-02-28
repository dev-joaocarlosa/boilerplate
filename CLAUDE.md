# Agente Autônomo e Contexto (Root)
Você está rodando no modo **Boilerplate Root**. 
Esta base utiliza React, Inertia, Laravel e Tailwind, operando num ambiente DevContainer restrito (Docker in Docker).

Ao construir novas features ou resolver problemas, obedeça estritamente à seguinte hierarquia arquitetural e de padrões, localizados na sua pasta `.context` e nos seus plugins nativos `.claude`:

1.  **Regras (`/.claude/rules`)**: Consulte ESTES arquivos de regras MESTRAS de stack antes de gerar qualquer código base (.claude/rules/backend.md, .claude/rules/frontend.md).
2.  **Agentes (`/.claude/agents`)**: *VOCÊ possui Sub-Agentes Nativos*. Dependendo da issue/PRD em execução, você DEVE engatilhar a criação do subagente especializado (ex: `backend-dev`, `frontend-dev`, `product-owner`) para fazer o trabalho paralelo/delegado sem estourar o seu contexto.
3.  **Habilidades (`/.claude/skills`)**: Você utiliza nativamente as Skills (ex: `/write-prd`) para garantir a geração padronizada de arquivos. Armazene também aprendizados nas pastas de `.claude/skills` para iterar sua própria base de conhecimento.

## Integração Ralph
Esta base executa o loop do Ralph de forma autônoma (arquivos em `scripts/ralph/`).
**Não tente sair do loop atualizado sem antes**:
1. Rodar testes em tudo que fez.
2. Atualizar este mesmo arquivo (`CLAUDE.md`), ou arquivos na pasta `.claude/` sempre que um novo aprendizado for obtido durante a iteração. A retroalimentação é essencial.

## Derivando Novos Projetos (Scaffolding Automático)
Se o usuário solicitar a **criação de um novo projeto**, inicialização de um novo app, ou instruir algo como "derive um projeto a partir deste boilerplate", **NÃO** crie as pastas manualmente e não clone nada na mão.
Sua diretriz de uso e única ferramenta válida para isso é o script executável na raiz:
- Rode no terminal: `./new-project.sh <nome-do-novo-projeto>`
- Este script clonará o boilerplate limpo em uma pasta irmã, excluirá históricos do git nativos, fará um build de repositório privado via Github CLI (gh) sob o org `dev-joaocarlosa` e commitará automaticamente. Comunique-se com o usuário sobre o resultado final.

## Gestão de PRDs (Product Requirements)
A organização dos requisitos segue um padrão rígido para automação:
1.  **Pasta de Saída**: Todos os PRDs devem ser salvos em `/tasks/` com o padrão `prd-[id]-[slug].md`.
2.  **Agente Responsável**: O `product-owner` (chamado via Subagente).
3.  **Template**: Utilize SEMPRE a skill nativa `/write-prd`.
4.  **Fluxo**: Quando o usuário pedir para "Planejar uma feature" ou "Criar um PRD", delegue a criação para o agente `product-owner` e cobre a entrega do PRD preenchido em formato markdown em `/tasks/`.

