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
echo "🤖 Acordando o Ralf (Claude Code em modo Perigoso) dentro de ${PROJECT_NAME}-app..."
echo "Aviso: Ele pode destruir, criar e modificar o que achar necessário para entregar a feature!"

# Entra no Docker e ejeta a instrução do Ralf diretamente
docker exec -it "${PROJECT_NAME}-app" bash -c "
    cd /workspace
    
    # 1. Carrega as Variáveis de Segurança
    if [ -f .env ]; then
        TOKEN=\$(grep -E '^ANTHROPIC_API_KEY=' .env | cut -d '=' -f2- | tr -d ' \\r\\n\"'\\'')
        export ANTHROPIC_AUTH_TOKEN=\"\$TOKEN\"
    fi
    
    if [ -z \"\$ANTHROPIC_AUTH_TOKEN\" ]; then
        echo '❌ ERRO: ANTHROPIC_API_KEY vazia no .env'
        exit 1
    fi

    # 2. Ativa Bypass da Anthropic para usar LLM do MiniMax
    export ANTHROPIC_BASE_URL='https://api.minimax.io/anthropic'
    export API_TIMEOUT_MS='3000000'
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC='1'
    export ANTHROPIC_MODEL='MiniMax-M2.5'
    export ANTHROPIC_SMALL_FAST_MODEL='MiniMax-M2.5'
    
    export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=1
    
    # 3. Dispara o Ralf Loop
    claude -p \"Você é o Ralf, nosso Agente Arquiteto Autônomo. Sua única missão agora é ler, analisar e implementar 100% dos requisitos apontados neste documento de PRD (Product Requirements Document): '\$PRD_FILE'. Certifique-se de compreender todo o escopo arquitetural, e comece a executar o código, migrações, testes e criações de UI iterativamente até que a User Story principal esteja completa e brilhante. Se houver dependências não cobertas, instale-as. Se houver bugs no meio, conserte-os antes de dar como concluído.\"
"
