#!/bin/bash
set -e

# Pega o nome da pasta atual como nome base do projeto (ou passe o nome como argumento opcional)
PROJECT_NAME=${1:-$(basename "$PWD")}

echo "🤖 Injetando Claude Code (com Superpoderes) no container: ${PROJECT_NAME}-app"
echo "O modo 'dangerous' pulará confirmações para edições automáticas diretas."

# Pega a chave da API do .env e ejeta as configs do MiniMax direto no Bash!
docker exec -it "${PROJECT_NAME}-app" bash -c '
    cd /workspace
    
    if [ -f .env ]; then
        TOKEN=$(grep -E "^ANTHROPIC_API_KEY=" .env | cut -d "=" -f2- | tr -d " \r\n\"'\''")
        export ANTHROPIC_AUTH_TOKEN="$TOKEN"
    fi
    
    if [ -z "$ANTHROPIC_AUTH_TOKEN" ]; then
        echo "❌ ERRO: A chave ANTHROPIC_API_KEY não foi encontrada ou está vazia no arquivo .env!"
        echo "Por favor, adicione sua API Key do MiniMax no .env e rode ./claude.sh novamente."
        exit 1
    fi

    # Força a intercepção da rota de faturamento da Anthropic
    export ANTHROPIC_BASE_URL="https://api.minimax.io/anthropic"
    export API_TIMEOUT_MS="3000000"
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="1"
    export ANTHROPIC_MODEL="MiniMax-M2.5"
    export ANTHROPIC_SMALL_FAST_MODEL="MiniMax-M2.5"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="MiniMax-M2.5"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="MiniMax-M2.5"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="MiniMax-M2.5"
    
    export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=1
    
    claude
'
