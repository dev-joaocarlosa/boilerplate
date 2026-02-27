FROM php:8.3-fpm

# Fix DEBIAN_FRONTEND warnings
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependências do sistema + Nginx
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    wget \
    nodejs \
    npm \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    supervisor \
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar extensões PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Criar usuário padrão seguro (evitando conflitos com os preexistentes)
RUN useradd -G www-data,root -u 1000 -d /home/appuser appuser && \
    mkdir -p /home/appuser/.composer && \
    chown -R appuser:appuser /home/appuser

WORKDIR /var/www

# Copiar código da aplicação 
# Obs: O ideal de CI/CD é rodar o npm run build ANTES da imagem Docker se o server for pequeno.
COPY --chown=appuser:appuser . /var/www

# Criar diretórios necessários e setar permissões SECURE (seguras, evitando chmod 777)
RUN mkdir -p /var/www/storage/app/public \
    && mkdir -p /var/www/storage/framework/cache \
    && mkdir -p /var/www/storage/framework/sessions \
    && mkdir -p /var/www/storage/framework/views \
    && mkdir -p /var/www/storage/logs \
    && mkdir -p /var/www/bootstrap/cache \
    && chown -R appuser:www-data /var/www/storage /var/www/bootstrap/cache \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache \
    && chmod -R ug+rwx /var/www/storage /var/www/bootstrap/cache

# Instalar dependências PHP
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Supervisor setup
RUN mkdir -p /var/log/supervisor
# A ser adaptado se quiser um conf de supervisor pronto, descomente as linhas
# COPY infra/production/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
# COPY infra/production/start-workers.sh /var/www/start-workers.sh
# RUN chmod +x /var/www/start-workers.sh

# Nginx setup
RUN rm -f /etc/nginx/sites-enabled/default
# COPY infra/production/nginx/default.conf /etc/nginx/sites-enabled/default.conf

# Não expor via bind 0.0.0.0 se não for estritamente necessário em produção para outras redes.
# Apenas libere se tiver Load Balancers ou workers em servidores difentes batendo nessa porta
RUN sed -i 's/^listen = 127.0.0.1:9000/listen = 9000/' /usr/local/etc/php-fpm.d/www.conf

EXPOSE 80

# Inicia o supervisor, que em tese gerenciaria o PHP-FPM, Nginx e Queues (ajuste o arquivo conf)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
