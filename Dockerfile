# Base image PHP
FROM php:8.2.29-zts-alpine3.21

# Install dependencies
RUN apk update && apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    zlib-dev \
    libxml2-dev \
    curl \
    bash \
    git \
    nodejs \
    npm \
    mysql-client \
    freetype-dev \
    pkgconfig \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install opcache

# Set the working directory to /var/www
WORKDIR /var/www

# Copy the existing Laravel project into the container
COPY . /var/www

# Set permissions for Laravel folder
RUN chown -R www-data:www-data /var/www

# Install Laravel dependencies
RUN composer install

# Install Node.js dependencies
RUN npm install

# Expose port 9000 to the outside
EXPOSE 9000

# Start PHP built-in server
CMD ["php", "-S", "0.0.0.0:9000", "-t", "public"]
