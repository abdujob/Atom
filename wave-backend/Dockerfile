FROM php:8.2-cli

# Installer les dépendances système
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libpq-dev \
    sqlite3 \
    libsqlite3-dev

# Installer les extensions PHP requises par Laravel (PostgreSQL et SQLite)
RUN docker-php-ext-install pdo pdo_pgsql pdo_sqlite bcmath gd

# Installer Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Définir le dossier de travail
WORKDIR /app

# Copier les fichiers du projet
COPY . /app

# Installer les dépendances du projet
RUN composer install --no-dev --optimize-autoloader

# Configurer les permissions pour le stockage de Laravel
RUN chmod -R 775 storage bootstrap/cache

# Exposer le port de l'application
EXPOSE 8000

# Démarrer le serveur avec les migrations
CMD php artisan storage:link && php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
