FROM php:8.1-fpm

# Arguments defined in docker-compose.yml
ARG user
ARG uid
ARG nginxport
ARG dbcontainer

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo

RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user && \
    chown -R $user:$user /var/www

RUN adduser $user sudo

# Set working directory
WORKDIR /var/www

RUN rm -rf html

RUN git clone https://github.com/laravel/laravel .

RUN cp .env.example .env

RUN sed -i "s/^APP_URL=.*/APP_URL=http:\/\/localhost:$nginxport/g" .env
RUN sed -i 's/^DB_USERNAME=.*/DB_USERNAME=laravel/g' .env
RUN sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=laravel/g' .env
RUN sed -i "s/^DB_HOST=.*/DB_HOST=$dbcontainer/g" .env

RUN chown -R $user:$user /var/www

USER $user
