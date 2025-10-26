FROM php:8.2-apache

ENV DB_HOST=postgres-container
ENV DB_NAME=unir
ENV DB_USER=unir
ENV DB_PASS=unirAdmin
ENV DB_PORT=5432

RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql \
    && rm -rf /var/lib/apt/lists/*

COPY ./public/ /var/www/html/
COPY ./src/ /var/www/html/src/

RUN a2enmod rewrite

EXPOSE 80

# Para construir la imagen, ejecuta en tu terminal, dentro del directorio 'contenedores/backend':
# docker build -t mi-api .

# docker run --name mi-api-container --network unir-app-network -p 8080:80 -d mi-api

# Crear y subir imagen a Docker Hub:
# docker login
# docker tag mi-api jjcarmu/mi-api:1.0
# docker push jjcarmu/mi-api:1.0