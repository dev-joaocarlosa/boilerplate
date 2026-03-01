#!/bin/bash
set -e

# Pega o nome da pasta atual como nome base do projeto (ou passe o nome como argumento opcional)
PROJECT_NAME=${1:-$(basename "$PWD")}

echo "🤖 Injetando Claude Code (com Superpoderes) no container: ${PROJECT_NAME}-app"
echo "O modo 'dangerous' pulará confirmações para edições automáticas diretas."

# Entra interativamente no Docker usando o terminal para rodar o claude
docker exec -it "${PROJECT_NAME}-app" bash -c "cd /workspace && export CLAUDE_DANGEROUSLY_SKIP_PERMISSIONS=1 && claude"
