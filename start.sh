#!/bin/bash
set -e

echo "🚀 Iniciando containers do Boilerplate..."

# Verificar se o .env existe na raiz
if [ ! -f .env ]; then
    if [ -f .env.example ]; then
        echo "📄 .env não encontrado. Copiando de .env.example..."
        cp .env.example .env
    else
        echo "⚠️  Aviso: .env e .env.example não encontrados."
    fi
fi

# Subir os containers apontando para o arquivo dentro de .devcontainer
docker compose --env-file .env -f .devcontainer/docker-compose.yml up -d --build

echo "✅ Containers iniciados com sucesso!"
echo "🌍 Aplicação: http://boilerplate.localhost"
echo "🔌 API:       http://api.boilerplate.localhost"
echo "📊 phpMyAdmin: http://pma.boilerplate.localhost"
echo ""
echo "💡 Dica: Para ver os logs, rode: docker compose -f .devcontainer/docker-compose.yml logs -f"
