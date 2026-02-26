#!/bin/bash
set -e

# Install global Claude Code
npm install -g @anthropic-ai/claude-code

# Create Claude Code configuration directory and settings
mkdir -p ~/.claude
cat << 'EOF' > ~/.claude/settings.json
{
  "claudeCode": {
    "selectedModel": "MiniMax-M2.5",
    "theme": "dark"
  }
}
EOF

# Install Amp CLI
curl -fsSL https://ampcode.com/install.sh | bash

# Create initial environment variables structure for Laravel (will be overwritten if installed later but good for container startup)
if [ ! -f "/workspace/.env" ]; then
    cp /workspace/.env.example /workspace/.env || true
fi

echo "Dev container setup complete! MiniMax Claude Code env vars are initialized."
