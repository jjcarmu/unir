FROM nginx:alpine

COPY index.html /usr/share/nginx/html/

EXPOSE 80

# Para construir la imagen, ejecuta en tu terminal, dentro del directorio 'contenedores/frontend':
# docker build -t mi-front-end .

# Para ejecutar el contenedor y mapear el puerto 80 del contenedor al puerto 8088 de tu máquina:
# docker run --name front-end-container --network unir-app-network -p 88:80 -d mi-front-end

# Crear y subir imagen a Docker Hub:
# docker login
# docker tag mi-front-end jjcarmu/mi-front-end:1.0
# docker push jjcarmu/mi-front-end:1.0