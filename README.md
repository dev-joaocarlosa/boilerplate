# Laravel + Ralph + Shadcn Boilerplate

Este repositório é um **Template** de base (Boilerplate) para construção de sistemas usando as ferramentas:
- **Backend**: Laravel 12 + Breeze
- **Frontend**: React + Inertia.js + Tailwind CSS + Shadcn UI
- **Agente Autônomo**: [Ralph](https://github.com/snarktank/ralph) (Rodando internamente em modelo _Dangerous_ DevContainer com **MiniMax** e Claude Code)

---

## Como iniciar um NOVO PROJETO a partir deste Boilerplate

Para criar um novo sistema derivado deste (e já vinculá-lo à organização `dev-joaocarlosa` no Github), você deve utilizar o nosso script automatizado.

1. Navegue até a pasta deste boilerplate na sua máquina:
   ```bash
   cd /Users/jc/Project/boilerplate
   ```
2. Execute o assistente informando o nome do futuro projeto:
   ```bash
   ./new-project.sh meu-novo-sistema
   ```
3. O script irá criar uma pasta irmã (ex: `/Users/jc/Project/meu-novo-sistema`), limpar os vínculos antigos do boilerplate, e fazer o push automático de um "Initial Commit" fresquinho pro Github dentro da org.

### Importante: Chave da IA
Sempre que derivar um projeto, o script criará um arquivo `.env` para você vazio.
> ⚠️ **Não esqueça** de abrir o projeto derivado e inserir a sua chave **MiniMax** (ou exportá-la globalmente) em `ANTHROPIC_AUTH_TOKEN`, caso contrário o Ralph não conseguirá iterar o código!

---

## Estrutura do Agente Autônomo (`.context`)
Os sub-agentes e inteligência artificial do repositório ficam mapeados na pasta `.context`.

Para criar a primeira _Feature_:
1. Abra o Dev Container.
2. Digite `/prd` e descreva o que quer construir.
3. Após validado, rode o parser de histórico: `/ralph`.
4. Finalmente inicie o operário que botará a mão na massa: `./scripts/ralph/ralph.sh`.

Ele interpretará o PRD gerado, testará no Laravel/React e entregará commitado pronto pra push!
