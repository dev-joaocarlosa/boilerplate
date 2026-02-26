FROM mcr.microsoft.com/devcontainers/php:1-8.3-bullseye

# Install MariaDB client and other required tools
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    mariadb-client \
    git \
    jq \
    unzip \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set user to root (since it's dangerous mode for Ralph)
USER root
