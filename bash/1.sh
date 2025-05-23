#!/bin/bash
# Escribir un scrip en bash qeu acepte una ruta a un fichero o un directorio e 
# imprima por pantalla si es un fichero normal, un directorio u otro tipo de fichero.
# Finalmente el script ejecutará el comando ls sobre esta ruta en formato largo
# Marcelo Guillermo Rosales Taque
# Fidel Herney Palacios Cuacialpud
# Gonzales Reluz Segundo Manuel
# Jhon Javier Cardona Muñoz

if [ -z "$1" ]; then
        echo "Uso: $0 <ruta>"
        exit 1
fi

ruta="$1"

if [ -f "$ruta" ]; then
        echo "Es un fichero normal."
elif [ -d "$1" ]; then
        echo "Es un directorio"
else
        echo "Es otro tipo de fichero"
fi

echo "Contenido de $ruta:"
ls -l "$ruta"
