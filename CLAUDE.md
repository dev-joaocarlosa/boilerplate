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

### 🚫 Restrições Rígidas (Mandamentos de Elite)
Ao atuar como Ralph ou gerar código autônomo, **é estritamente PROIBIDO**:
1. **(Testes)** Nunca crie testes unitários ou feature tests (pastas `/tests`) a menos que o PRD do usuário faça a solicitação explícita.
2. **(Classes)** Nunca utilize `final class` para nenhuma estrutura (Controllers, Services, Jobs, Models, etc). Use apenas `class`.
3. **(God Classes e Models)** Nunca instancie Modelos do Eloquent (`App\Models\...`) diretamente dentro de um Service ou Controller. Use SEMPRE as Facades dos Repositories limitados. Aplique "um método, uma responsabilidade"; se o Service está gigante, particione em contextos menores.
4. **(Controllers Limpos)** O Controller tem comportamento EXCLUSIVO de proxy. NUNCA coloque blocos `try/catch`, validação local, `$response()->json()` ou retornos `Inertia` em linha. O Controller APENAS chama o `$this->getResponse()->dispatch(function() {...})` invocando a Facade de Serviço e repassando argumentos limpos.
5. **(Erros e Exceptions)** Nunca lance Exceptions (`ClientException` ou normais) com mensagens hardcoded (strings literais isoladas). Use SEMPRE valores provenientes de um Enum tipado de Erro que deverá ser injetado. Se for lançar Exception genérica, faça primeiro um `Log::error(...)` com prefixo na notação correta e repasse o erro para a Exception pelo Enum.
6. O Ralph atua estritamente seguindo os arquivos `.mdc`. Tudo que está listado como bloqueado nos `patterns/` é regra cega.

### 🌐 Regulamentação (Frontend)
7. Para interfaces, utilize estritamente **React + Inertia.js + Tailwind + Shadcn UI**. NUNCA construa lógicas de Ajax comuns (`fetch`, `axios`) em manipulação de form ou navegação normal. Adote cegamente os hooks de estado atrelados ao Inertia (`useForm`, e renderização `Link` em href).

### 📦 Contexto Externo Legado
8. Se as regras do PRD indicarem referências ao repositório ou pasta legado montado fora do projeto local (ex: volume `/projects/`), você TEM AUTONOMIA PRÉVIA de buscar e recuperar o funcionamento e lógicas complexas da base de código original para traduzi-las e reescrevê-las na **arquitetura ideal aprovada por nossos padrões** em vez de cegamente fazer copia-e-cola.

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

