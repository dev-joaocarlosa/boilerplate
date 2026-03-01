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
PROMPT_FILE=$(mktemp /tmp/ralf_prompt.XXXXXX.txt)
cat > "$PROMPT_FILE" << ENDOFPROMPT
Você é o Ralf, nosso Engenheiro Especialista Sênior e Arquiteto Autônomo. Sua missão inquebrável é IMPLEMENTAR DE PONTA A PONTA, 100% dos requisitos descritos neste documento de PRD: $PRD_FILE.

⚡ ARSENAL E PADRÕES (OBRIGATÓRIO):
1. Sua base de inteligência reside em .claude/rules/ e .claude/skills/. LEIA-AS ANTES DE COMEÇAR.
2. Siga RIGOROSAMENTE as regras em .claude/rules/backend/patterns/index.mdc e arquivos vizinhos. Elas são a sua Bíblia de qualidade de código.
3. Use a Skill Mestra de implementação: .claude/skills/backend/implement-issue/SKILL.md. Siga o workflow de 8 passos descrito nela (Enum -> Entity -> Repository -> Service -> Controller -> Rota -> Bindings).

⚡ DIRETRIZES DE ALTA PERFORMANCE (FEEDBACK DO USUÁRIO):
- 🚫 PROIBIDO: 'declare(strict_types=1)', comentários inline, PHPDoc descritivo de parâmetros, e IFs aninhados (use Early Returns).
- 🚫 PROIBIDO: Injeção de dependência via construtor no Domínio. Use FACADES para acessar Services e Repositories conforme as regras .mdc.
- ✅ MANTRA: "Um método, uma responsabilidade". Métodos públicos orquestram privados. Métodos privados não chamam outros privados.
- ✅ ERROS: Use SEMPRE Enums para mensagens de erro. Nunca use strings hardcoded em Exceptions.
- ✅ CONTEXTO EXTERNO: Se o PRD apontar para /projects/ (volume externo), estude o código legado lá antes de portar para a nova arquitetura padrão.

⚡ DURANTE A EXECUÇÃO:
4. Autonomia total para instalar dependências (Composer/NPM) e rodar comandos bash necessários.
5. Valide seu trabalho iterativamente: Verifique rotas, logs do Laravel e retornos de APIs. Só termine quando a feature estiver brilhante e livre de bugs.

⚠️ CONDIÇÃO DE SAÍDA:
Só declare vitória se o workflow da skill 'implement-issue' estiver completo e o código seguir 100% os padrões do nosso arsenal.
ENDOFPROMPT

# 2. Escreve o script de execução completo num arquivo temporário
SCRIPT_FILE=$(mktemp /tmp/ralf_runner.XXXXXX.sh)
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
# (Claude Code recusa bypassPermissions como root - executa como usuário 'dev')
export RALF_TOKEN="\$ANTHROPIC_AUTH_TOKEN"
export RALF_BASE_URL="\$ANTHROPIC_BASE_URL"
export RALF_MODEL="\$ANTHROPIC_MODEL"

su dev -c "
    export ANTHROPIC_AUTH_TOKEN='\$RALF_TOKEN'
    export ANTHROPIC_BASE_URL='\$RALF_BASE_URL'
    export ANTHROPIC_MODEL='\$RALF_MODEL'
    export ANTHROPIC_SMALL_FAST_MODEL='\$RALF_MODEL'
    export API_TIMEOUT_MS='3000000'
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC='1'
    export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=1
    claude -p \"\$(cat /tmp/ralf_prompt.txt)\" \
        --permission-mode bypassPermissions \
        --verbose \
        --add-dir /workspace
"
ENDOFSCRIPT

# 3. Copia ambos os arquivos pro container
docker cp "$PROMPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_prompt.txt"
docker cp "$SCRIPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_runner.sh"
docker exec "${PROJECT_NAME}-app" chmod +x /tmp/ralf_runner.sh
rm -f "$PROMPT_FILE" "$SCRIPT_FILE"

# 4. Executa o script interativamente (com TTY real)
docker exec -it "${PROJECT_NAME}-app" /tmp/ralf_runner.sh
