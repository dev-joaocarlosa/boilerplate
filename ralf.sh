#!/bin/bash
set -e

# Pega o nome da pasta atual como nome base do projeto
PROJECT_NAME=$(basename "$PWD")

echo "================================================="
echo "🦮 INICIANDO RALF LOOPS (Autonomous Agent) 🦮"
echo "================================================="

PRD_FILE=$1

if [ -z "$PRD_FILE" ]; then
    echo "⚠️ Por favor, informe qual PRD o Ralf deve executar."
    echo "Exemplo: ./ralf.sh docs/prds/PRD-001.md"
    exit 1
fi

echo "📄 PRD Detectado: $PRD_FILE"
echo "🤖 Acordando o Ralf (Engenheiro Especialista) dentro de ${PROJECT_NAME}-app..."
echo "Aviso: Ele pode destruir, criar e modificar o que achar necessário para entregar a feature!"

# 1. Escreve o prompt num arquivo temporário (sem conflito de aspas)
PROMPT_FILE=$(mktemp /tmp/ralf_prompt.XXXXXX)
cat > "$PROMPT_FILE" << ENDOFPROMPT
Você é o Ralf, nosso Engenheiro Especialista Sênior e Arquiteto Autônomo. Sua missão inquebrável é IMPLEMENTAR DE PONTA A PONTA, 100% dos requisitos descritos neste documento de PRD: $PRD_FILE.

⚡ ARSENAL E PADRÕES (OBRIGATÓRIO):
1. Sua base de inteligência reside em .claude/rules/ e .claude/skills/. LEIA-AS ANTES DE COMEÇAR.
2. Siga RIGOROSAMENTE as regras declaradas nos seguintes arquivos. Elas são a sua Bíblia de qualidade de código. Você DEVE ler estes arquivos antes de escrever qualquer linha de código novo:
   - \`.claude/rules/backend/patterns/index.mdc\`
   - \`.claude/rules/backend/patterns/services.mdc\`
   - \`.claude/rules/backend/patterns/controllers.mdc\`
   - \`.claude/rules/backend/code-review/criteria.mdc\`
   SE A TAREFA ENVOLVER FRONTEND, LEIA TAMBÉM OBRIGATORIAMENTE:
   - \`.claude/rules/frontend.md\`
   - \`.claude/rules/frontend/index.mdc\`
   - \`.claude/rules/frontend/components.mdc\`
3. Use a Skill Mestra de implementação: .claude/skills/backend/implement-issue/SKILL.md. Siga o workflow de 8 passos descrito nela (Enum -> Entity -> Repository -> Service -> Controller -> Rota -> Bindings).
4. GESTÃO DE PROGRESSO E IDEMPOTÊNCIA (OBRIGATÓRIO): Você DEVE atuar como um agente stateful. A cada avanço que fizer, ABRA O ARQUIVO DO PRD E EDITE-O fisicamente para marcar com `[x]` as caixas de seleção correspondentes à tarefa que você acabou de concluir. Nunca termine o loop sem marcar o que fez. Se o PRD já tiver itens com `[x]`, apenas ignore e vá direto pro primeiro `[ ]` pendente.

⚡ DIRETRIZES DE ALTA PERFORMANCE:
- A sua BÍBLIA ABSOLUTA de comportamento em nível de projeto está no arquivo `CLAUDE.md` na raiz. Leia-o e obedeça-o incondicionalmente. Todas as diretrizes proibitivas (*Vetos Absolutos*) para testes, Models, Controllers e Frontend estão centralizadas lá.
- Além do `CLAUDE.md`, utilize seu arsenal de padrões globais (`.mdc`) indicados acima para governar COMO produzir cada arquivo.

⚡ DURANTE A EXECUÇÃO:
4. Autonomia total para instalar dependências (Composer/NPM) e rodar comandos bash necessários.
5. Valide seu trabalho iterativamente: Verifique rotas, logs do Laravel e retornos de APIs. Só termine quando a feature estiver brilhante e livre de bugs.

⚠️ CONDIÇÃO DE SAÍDA:
Só declare vitória se:
1. O workflow da skill 'implement-issue' estiver completo e o código seguir 100% os padrões do nosso arsenal.
2. Você tiver efetivamente editado e marcado todos os checkboxes pertinentes no arquivo do PRD para `[x]`. Não dê como tarefa concluída sem salvar fisicamente esse tracking!
ENDOFPROMPT

# 2. Escreve o script de execução completo num arquivo temporário
SCRIPT_FILE=$(mktemp /tmp/ralf_runner.XXXXXX)
cat > "$SCRIPT_FILE" << ENDOFSCRIPT
#!/bin/bash
cd /workspace

# Carrega variáveis de segurança
if [ -f .env ]; then
    TOKEN=\$(grep -E '^ANTHROPIC_API_KEY=' .env | cut -d '=' -f2- | tr -d ' \r\n')
    export ANTHROPIC_AUTH_TOKEN="\$TOKEN"
fi

if [ -z "\$ANTHROPIC_AUTH_TOKEN" ]; then
    echo "❌ ERRO: ANTHROPIC_API_KEY vazia no .env"
    exit 1
fi

# Ativa bypass da Anthropic -> MiniMax
export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"
export API_TIMEOUT_MS="3000000"
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
export ANTHROPIC_MODEL="MiniMax-M2.5"
export ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2.5"
export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=1

# Dispara o Ralf com saída visível em tempo real no terminal
# Executa nativamente como usuário 'dev' mantendo o TTY.
claude "$(cat /tmp/ralf_prompt.txt)" \
    --permission-mode bypassPermissions \
    --verbose \
    --add-dir /workspace
ENDOFSCRIPT

# 3. Copia ambos os arquivos pro container
docker cp "$PROMPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_prompt.txt"
docker cp "$SCRIPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_runner.sh"
docker exec "${PROJECT_NAME}-app" chmod a+rx /tmp/ralf_runner.sh /tmp/ralf_prompt.txt
rm -f "$PROMPT_FILE" "$SCRIPT_FILE"

# 4. Executa o script interativamente (com TTY real e usuário dev)
docker exec -it --user dev "${PROJECT_NAME}-app" /tmp/ralf_runner.sh
