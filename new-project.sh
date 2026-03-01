#!/bin/bash
set -e

# Define your Github Organization
ORG_NAME="dev-joaocarlosa"
TEMPLATE_REPO="git@github.com:${ORG_NAME}/boilerplate.git"

if [ -z "$1" ]; then
    echo "❌ Usage: ./new-project.sh <project-name>"
    echo "Example: ./new-project.sh meu-novo-app"
    exit 1
fi

PROJECT_NAME=$1
TARGET_DIR="../${PROJECT_NAME}"

echo "🚀 Iniciando a derivação do Boilerplate para o projeto: ${PROJECT_NAME}..."

# 1. Clone the boilerplate without history
echo "📦 Baixando o Boilerplate..."
git clone --depth 1 $TEMPLATE_REPO $TARGET_DIR

# 2. Navigate to the new project and remove old git link
cd $TARGET_DIR
rm -rf .git
echo "🧹 Removendo vínculos do Boilerplate."

# 3. Create .env from example (Minimax keys and DB are fresh)
if [ -f ".env.example" ]; then
    cp .env.example .env
    echo "📄 Arquivo .env gerado. O seu ANTHROPIC_AUTH_TOKEN (MiniMax) precisa ser preenchido nele ou no DevContainer depois!"
fi

# 4. Initialize fresh git repository
echo "🌱 Inicializando novo repositório Git..."
git config --global init.defaultBranch main || true
git init
git add .
git commit -m "Initial commit from Boilerplate (Laravel + React + Shadcn + Ralph)"

# 4.1 Customize Container Names and URLs for the Proxy
echo "🏷️ Personalizando nomes e URLs do projeto..."
# Substitui todas as ocorrências de boilerplate (incluindo em hosts do Traefik) pelo nome do projeto
sed -i '' "s/boilerplate/${PROJECT_NAME}/g" .devcontainer/docker-compose.yml
sed -i '' "s/boilerplate/${PROJECT_NAME}/g" start.sh

# Atualiza configurações vitais no arquivo .env
if [ -f ".env" ]; then
    sed -i '' "s/APP_NAME=Laravel/APP_NAME=${PROJECT_NAME}/g" .env
    sed -i '' "s/APP_URL=http:\/\/localhost/APP_URL=http:\/\/${PROJECT_NAME}.localhost/g" .env
    
    # 🎲 Resolve conflito de porta do MySQL para múltiplos projetos rodando em paralelo
    RANDOM_PORT=$((33061 + ($RANDOM % 1000)))
    echo "" >> .env
    echo "# Porta Externa Escalonada Automaticamente pelo Scaffold" >> .env
    echo "FORWARD_DB_PORT=${RANDOM_PORT}" >> .env

    # 🔑 Gera chave de criptografia do Laravel preenchendo o APP_KEY vazio
    if grep -q "^APP_KEY=$" .env; then
        GENERATED_KEY="base64:$(openssl rand -base64 32)"
        sed -i '' "s|^APP_KEY=$|APP_KEY=${GENERATED_KEY}|g" .env
    fi
fi

# 5. Create remote repository using GitHub CLI (gh)
echo "☁️  Criando repositório na organização ${ORG_NAME} via Github CLI..."
if ! command -v gh &> /dev/null; then
    echo "⚠️  O Github CLI (gh) não está instalado ou não foi encontrado."
    echo "Por favor instale (brew install gh), faça login (gh auth login) e rode manualmente:"
    echo "  gh repo create ${ORG_NAME}/${PROJECT_NAME} --private --source=. --remote=origin --push"
else
    gh repo create "${ORG_NAME}/${PROJECT_NAME}" --private --source=. --remote=origin --push
    echo "✅ Projeto ${PROJECT_NAME} criado com sucesso e commitado em: https://github.com/${ORG_NAME}/${PROJECT_NAME}"
fi

echo "🎉 Pronto! O seu novo ambiente autônomo está pronto."
echo "➡️  Próximos passos:"
echo "   cd ${TARGET_DIR}"
echo "   antigravity . (para abrir e provisionar seu Assistente IA!)"
