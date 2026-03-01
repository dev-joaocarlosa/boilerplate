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

⚡ ANTES DE ESCREVER QUALQUER CÓDIGO (RECONHECIMENTO):
1. Leia o arquivo $PRD_FILE cuidadosamente para entender a visão do produto.
2. Identifique regras e estilos: SE o projeto tiver arquivos como CLAUDE.md, AGENTS.md, pastas de regras/skills (ex: llm/rules, llm/skills) ou arquivos .mdc, LEIA TODOS OBRIGATORIAMENTE antes de começar. Respeite as arquiteturas e a inteligência neles gravadas.
3. Se o PRD pedir para buscar contexto ou endpoints numa base legada externa (ex: em /projects/, que é um volume somente-leitura do host), navegue até esse diretório primeiro e estude detalhadamente a lógica de negócio legada antes de codificar a nova.

⚡ DURANTE A EXECUÇÃO (AÇÃO E AUTO-CORREÇÃO):
4. Execute passo a passo (rotas, migrations, models, facades, form requests, views frontend). Se faltarem dependências (Composer/NPM), você tem autonomia total para instalá-las sem perguntar.
5. DEVE VALIDAR SEU PRÓPRIO TRABALHO e de forma iterativa: Verifique rotas no bash de teste, valide retornos de JSON para garantir que não são erros 500, cheque logs do Laravel (storage/logs/laravel.log) e re-compile os assets (npm run build) se alterar frontend. Conserte qualquer bug encontrado no meio do caminho sem interrupções.
6. Re-utilize padrões do ecossistema local e evite reinventar rodas: reutilize componentes de botão, tabela, form, e autenticação que já moram em repositórios da aplicação.

⚠️ CONDIÇÃO DE SAÍDA:
Você está PROIBIDO de encerrar sua execução e dar a feature como concluída se TODOS os critérios de aceitação e as subtasks do PRD não estiverem construídas e perfeitamente funcionais na infraestrutura real e livres de bugs.
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

# Dispara o Ralf lendo o prompt do arquivo (sem conflito de aspas!)
claude -p "\$(cat /tmp/ralf_prompt.txt)"
ENDOFSCRIPT

# 3. Copia ambos os arquivos pro container
docker cp "$PROMPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_prompt.txt"
docker cp "$SCRIPT_FILE" "${PROJECT_NAME}-app:/tmp/ralf_runner.sh"
docker exec "${PROJECT_NAME}-app" chmod +x /tmp/ralf_runner.sh
rm -f "$PROMPT_FILE" "$SCRIPT_FILE"

# 4. Executa o script interativamente (com TTY real)
docker exec -it "${PROJECT_NAME}-app" /tmp/ralf_runner.sh
