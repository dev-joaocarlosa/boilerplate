#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "❌ Uso: ./destroy-project.sh <project-name>"
    echo "Exemplo: ./destroy-project.sh meu-novo-app"
    exit 1
fi

PROJECT_NAME=$1
TARGET_DIR="../${PROJECT_NAME}"

echo "⚠️  ATENÇÃO: Você está prestes a DESTRUIR o projeto '${PROJECT_NAME}'."
echo "Isso removerá:"
echo "1. Os containers Docker associados"
echo "2. O volume do banco de dados (Dados perdidos permanentemente)"
echo "3. A pasta local do código-fonte (${TARGET_DIR})"
echo ""
read -p "Tem certeza que deseja continuar? (y/N) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    # 1. Stop and remove containers and network
    echo "🐳 Removendo Containers Docker (app, mysql, pma) e Rede..."
    docker rm -f "${PROJECT_NAME}-app" "${PROJECT_NAME}-mysql" "${PROJECT_NAME}-pma" 2>/dev/null || true
    
    # 2. Remove the specific Database Volume (to fully clean traces)
    echo "💾 Removendo Volume do Banco de Dados (${PROJECT_NAME}_${PROJECT_NAME}-mysql-data)..."
    docker volume rm "${PROJECT_NAME}_${PROJECT_NAME}-mysql-data" 2>/dev/null || true
    
    # 3. Remove local project directory
    if [ -d "$TARGET_DIR" ]; then
        echo "🗑️  Removendo pasta raiz do projeto (${TARGET_DIR})..."
        rm -rf "$TARGET_DIR"
    else
        echo "ℹ️  A pasta local ${TARGET_DIR} já não existia."
    fi

    echo "✅ Projeto '${PROJECT_NAME}' e todos os seus resquícios de Docker foram completamente vaporizados!"
    echo "💡 Lembrete: O repositório no GitHub deve ser excluído manualmente via painel web ou CLI: gh repo delete dev-joaocarlosa/${PROJECT_NAME} --yes"
else
    echo "🛑 Operação cancelada pelo usuário."
    exit 0
fi
