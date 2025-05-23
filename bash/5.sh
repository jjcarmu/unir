#!/bin/bash
: << 'FIN'
Escribid un script que renombre todos los ficheros con extension jpg del directorio
actual, añadiendo un prefijo con la fecha en formato año, mes, día. Por ejemplo, 
un fichero con nombre imagen1.jpg pasaria a llamarse 20240413-image1.jpg, si el script se ejecuta el 
13 de abril de 2024 
FIN

##Obtener fecha formato YYYYMMDD
fecha=$(date +%Y%m%d)

##recorrer archivos jpg
for archivo in *.jpg *.JPG ; do
    if [ -e "$archivo" ]; then
        nombre_archivo="${fecha}-${archivo}"
        
        # Validación que tiene en cuenta si ya se nombro con la fecha actual ( solo ejecutando ./5.sh )
        if [[ "$archivo" == ${fecha}* ]]; then
            echo "Saltando '$archivo' (ya renombrado hoy)"
            continue
        fi
        # Renombrar el archivo
        mv "$archivo" "$nombre_archivo"

        echo "Renombrado: $archivo a $nombre_archivo"
    fi
done
