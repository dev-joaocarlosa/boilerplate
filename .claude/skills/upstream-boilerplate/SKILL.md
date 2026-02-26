---
name: upstream-boilerplate
description: Exporta uma funcionalidade, correção ou melhoria arquitetural (Skill/Rule/Código Base) do projeto atual (filho) de volta para o repositório oficial do Boilerplate. Use quando o usuário pedir para atualizar o Boilerplate com as mudanças recentes feitas neste projeto.
user-invocable: true
allowed-tools: Bash, Read, Edit
---

# Upstream Boilerplate (Backport)

Sua missão é pegar melhorias generalistas desenvolvidas neste projeto "filho" e empurrá-las de volta para o repositório pai (o Boilerplate oficial) para beneficiar novos projetos no futuro.

## Fluxo de Execução

Ao invocar esta Skill com os caminhos/features descritos ($ARGUMENTS), execute os seguintes passos:

1. **[Clonagem Temporária]**: 
   Crie uma pasta temporária (ex: `/tmp/boilerplate-sync`) e clone nela o repositório oficial do Boilerplate via Github CLI ou Git:
   `git clone git@github.com:dev-joaocarlosa/boilerplate.git /tmp/boilerplate-sync`

2. **[Extração / Generalização]**:
   Identifique as melhorias ou arquivos especificados pelo usuário ($ARGUMENTS) no projeto _atual_ (onde você está rodando). Verifique dependências e regras atreladas a eles. A melhoria é genérica o suficiente para o Boilerplate? Se houver referências específicas do domínio atual do projeto filho (ex: nomes de empresa, regras de negócios fechadas), **remova-as** (refatore o que será movido para formato genérico).

3. **[Cópia e Patch]**:
   Copie os arquivos limpos e modificados daqui do projeto filho para dentro de `/tmp/boilerplate-sync` utilizando BASH (cp, rsync) preservando as localizações das pastas e hierarquias originais (ex: `.claude/rules/`, `resources/js/Components/ui/`, etc).

4. **[Branch e PR]**:
   - Vá para a pasta `/tmp/boilerplate-sync` (`cd /tmp/boilerplate-sync`)
   - Crie uma branch baseada na modificação (`git checkout -b feat/upstream-improvements`)
   - Adicione, commite com um commit semântico (Conventional Commits) e faça um push para origin (`git push -u origin HEAD`).
   - Tente utilizar `gh pr create` para abrir o Pull Request lá automaticamente informando na descrição o que esse Pull Request atualiza no Boilerplate e os motivos.
   - Caso `gh` falhe, use commit normal na master se não houver bloqueios ou passe a URL pro console.

5. **[Limpeza]**:
   Aborte as mudanças de contexto e remova a pasta temporária `rm -rf /tmp/boilerplate-sync`. Confirme a conclusão ao usuário e forneça o link da Pull Request criada no Boilerplate.
