FROM mcr.microsoft.com/devcontainers/php:1-8.4-bookworm

# Fix potential GPG issues with stale repositories in the base image
RUN rm -f /etc/apt/sources.list.d/yarn.list \
    && apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    mariadb-client \
    git \
    jq \
    unzip \
    sudo \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install global Claude Code & AMP CLI (as root so binary is in /usr/local/bin)
RUN npm install -g @anthropic-ai/claude-code \
    && curl -fsSL https://ampcode.com/install.sh | bash

# Create a non-root user 'dev' for Claude Code (which refuses --bypassPermissions as root)
RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && mkdir -p /home/dev/.claude \
    && echo '{"theme":"dark","claudeCode":{"selectedModel":"MiniMax-M2.5"}}' > /home/dev/.claude/settings.json \
    && chown -R dev:dev /home/dev/.claude

# Root stays as the main container user (for php-fpm, artisan etc.)
# Claude agents (ralf.sh, claude.sh) switch to 'dev' before running claude CLI
USER root
