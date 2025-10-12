FROM postgres:latest

ENV POSTGRES_DB=unir
ENV POSTGRES_USER=unir
#ENV POSTGRES_PASSWORD=unirAdmin

COPY init.sql /docker-entrypoint-initdb.d/
COPY 99-allow-remote-connections.sh /docker-entrypoint-initdb.d/
RUN chmod +x /docker-entrypoint-initdb.d/99-allow-remote-connections.sh

EXPOSE 5432

# Para construir la imagen, ejecuta en tu terminal, dentro del directorio 'contenedores/persistencia':
# docker build -t postgres-db .

# Para ejecutar el contenedor y mapear el puerto 5432 del contenedor al puerto 5232 de tu máquina:
# docker run --name postgres-container --network unir-app-network -p 5232:5432 -e POSTGRES_PASSWORD=unirAdmin -d postgres-db

# Crear y subir imagen a Docker Hub:
# docker login
# docker tag postgres-db jjcarmu/postgres-db:1.0
# docker push jjcarmu/postgres-db:1.0