#!/bin/bash
: << 'FIN'
Escribid un script que imprima en este orden y en linea diferentes:
* El nombre del script que se está ejecutando 
* El número de argumentos que se han pasado al script
* El primer y segundo argumento , ambos en la misma linea
* Si hay mas de dos argumentos, los argumentos a partir del tercero [este incluido] cada uno en una linea
FIN

echo "Nombre del script: $0"
echo "Numero de argumentos: $#"

if [ $# -gt 0 ]; then

    echo "Primer argumento: $1 y Segundo argumento: $2"

    if [ $# -gt 2 ]; then
        echo "Argumentos adicionales: "
        contador=1
        for var in "$@"
        do
            if [ $contador -gt 2 ]; then
                echo "Argumento $contador: $var"            
            fi
            contador=$((contador + 1))
        done
        # iteración que no se ejecuta con sh         
        #contador=3
        #while [ $contador -le $# ]; do
        #    echo "Argumento $contador: ${!contador}"
        #    contador=$((contador + 1))
        #done
    fi
fi