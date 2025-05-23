#!/bin/bash
: << 'FIN'
Escribid un script que copie un archivo sobre otro, garantizando que solo reciba dos parametros
FIN
##verificar que solo haya dos argumentos
if [ $# -ne 2 ]; then
    echo "Deben ser dos argumentos"
    exit 1
fi

##asignar argumentos
archivo1="$1"
archivo2="$2"
##Verificar si los archivos existen
if [ ! -f "$archivo1" ]; then
    echo "No existe el archivo $archivo1"
    exit 1
fi
if [ ! -f "$archivo2" ]; then
    echo "No existe el archivo $archivo2"
    exit 1
fi

##copiar el archivo1 a archivo2
cp "$archivo1" "$archivo2"
