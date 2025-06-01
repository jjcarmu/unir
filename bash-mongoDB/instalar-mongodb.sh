#!/bin/bash

set -e

logger "Arrancando instalacion y configuracion de MongoDB"
USO="Uso : instalar-mongodb.sh -f config.ini
   Ejemplo:
   instalar-mongodb.sh -f config.ini
   Ejemplo Contenido Archivo de configuracion :
      user=administrador
      password=secreto
      port=27017
   "

function ayuda() {
echo "${USO}"
if [[ ${1} ]]
then
echo ${1}
fi
}   

#Gestionar los argumentos
while getopts ":f:" OPCION
do
    case ${OPCION} in 
        f)  FILE=$OPTARG
            echo "Parametro ARCHIVO establecido con '${FILE}'";;
        \?) ayuda "La opcion no existe : $OPTARG"; exit 1;;
        :) ayuda "Falta el parametro para -$OPTARG"; exit 1;;
        
        esac
done

# Verificar si se pasó un archivo .ini como argumento
if [ -z ${FILE} ]; then
   echo "Error: Debe especificar un archivo de configuración con -f." 
   ayuda
   exit 1
fi

# Verificar si el archivo realmente existe
if [ ! -f ${FILE} ]; then
  echo "Error: El archivo ${FILE} no existe."
  ayuda
  exit 1
fi

echo "Leyendo archivo de configuración: ${FILE}"
while IFS='=' read -r key value || [ -n "$key" ]; do
  # Eliminar espacios y omitir comentarios o líneas vacías
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)

  [ -z "$key" ] && continue
  [[ "$key" == \#* ]] && continue
  # Gestionar los argumentos 
  case "$key" in
    user) USUARIO="$value"
    echo "Parametro USUARIO establecido con '${USUARIO}'";;
    password) PASSWORD="$value" 
    echo "Parametro PASSWORD establecido";;
    port) PUERTO_MONGOD="$value"
    echo "Parametro PUERTO_MONGOD establecido con '${PUERTO_MONGOD}'";;
    :) ayuda "Falta el parametro para -$OPTARG"; exit 1;; \?) ayuda "La opcion no existe : $OPTARG"; exit 1;;
  esac
done < ${FILE}

if [ -z ${USUARIO} ]; then
ayuda "El usuario (-u) debe ser especificado"; exit 1
fi

if [ -z ${PASSWORD} ]; then
ayuda "La password (-p) debe ser especificada"; exit 1
fi

if [ -z ${PUERTO_MONGOD} ]; then
PUERTO_MONGOD=27017
fi

# Preparar el repositorio (apt-get) de mongodb añadir su clave apt
#Ubuntu 18.04 con version de mongo 4.4
#curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
#echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-4.4.list

#Ubuntu 16.04 y 18.04
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 4B7C549A058F8B6B
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | tee /etc/apt/sources.list.d/mongodb.list

if [[ -z "$(mongo --version 2> /dev/null | grep '4.2.1')" ]]; then
# Instalar paquetes comunes, servidor, shell, balanceador de shards y herramientas
# Para ubuntu 18.04, se agrega la libreria libcurl3 \
   apt-get -y update \
   && apt-get install -y \
   libcurl3 \
   mongodb-org=4.2.1 \
   mongodb-org-server=4.2.1 \
   mongodb-org-shell=4.2.1 \
   mongodb-org-mongos=4.2.1 \
   mongodb-org-tools=4.2.1 \
   #Se comnenta por estaba generando problemas y se tenia ejecutar 2 veces el Script (Causa de de la version del Ubuntu)
   #&& rm -rf /var/lib/apt/lists/* \
   #&& pkill -u mongodb || true \
   #&& pkill -f mongod || true \
   #&& rm -rf /var/lib/mongodb
fi

# Crear las carpetas de logs y datos con sus permisos
[[ -d "/datos/bd" ]] || mkdir -p -m 755 "/datos/bd"
[[ -d "/datos/log" ]] || mkdir -p -m 755 "/datos/log"

# Establecer el dueño y el grupo de las carpetas db y log
chown mongodb /datos/log /datos/bd
chgrp mongodb /datos/log /datos/bd

# Crear el archivo de configuración de mongodb con el puerto solicitado
mv /etc/mongod.conf /etc/mongod.conf.orig
(
cat <<MONGOD_CONF
# /etc/mongod.conf
systemLog:
   destination: file
   path: /datos/log/mongod.log
   logAppend: true
storage:
   dbPath: /datos/bd
   engine: wiredTiger
   journal:
      enabled: true
net:
   port: ${PUERTO_MONGOD}
security:
   authorization: enabled
MONGOD_CONF
) > /etc/mongod.conf

# Reiniciar el servicio de mongod para aplicar la nueva configuracion
systemctl restart mongod

logger "Esperando a que mongod responda..."
until nc -z localhost ${PUERTO_MONGOD}
do
    sleep 1
done

# Crear usuario con la password proporcionada como parametro

mongo admin << CREACION_DE_USUARIO
db.createUser({
    user: "${USUARIO}",
    pwd: "${PASSWORD}",
    roles:[{
        role: "root",
        db: "admin"
    },{
        role: "restore",
        db: "admin"
}] })
CREACION_DE_USUARIO

logger "El usuario ${USUARIO} ha sido creado con exito!"

exit -1
