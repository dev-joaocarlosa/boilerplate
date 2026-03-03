#!/bin/bash

# Script de sincronização de Rules/Skills do Boilerplate para projetos derivados

TARGET_PROJECT=$1

if [ -z "$TARGET_PROJECT" ]; then
    echo "Uso: ./sync-rules.sh <caminho-do-projeto-destino>"
    echo "Exemplo: ./sync-rules.sh ../marketplaces"
    exit 1
fi

echo "Sincronizando as regras e a inteligência do Boilerplate para $TARGET_PROJECT..."

# Copiando CLAUDE.md
cp -v ./CLAUDE.md "$TARGET_PROJECT/CLAUDE.md"

# Sincronizando regras gerais mantendo versões limpas
rsync -avz --delete \
    ./.claude/ \
    "$TARGET_PROJECT/.claude/"

echo "Sincronização conluída! O projeto $TARGET_PROJECT agora possui as mesmas Rules, Skills e Patterns do Boilerplate atualizadas."
