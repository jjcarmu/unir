# Escribid un script que ejecute cierta accion en funcion de la extensión de un archivo que recibe como parametro.
# Si se trata de un JPG, copiar dicho archivo en la carpeta ~/fotos. Si resulta ser de otro formato, avisar al usuario sin 
# hacer nada.
#/bin/bash

##verificar parametro
if [ -z "$1" ]; then
  echo "Usage: $0 <path_to_file>"
  exit 1
fi

##asignar archivo
archivo="$1"

##Verificar si el archivo existe
if [ ! -f "$archivo" ]; then
  echo "No existe el archivo $archivo"
  exit 1
fi

##Extraer extension del archivo

extension="${archivo##*.}"


##Verificar si la extension es .jpg

if [ "$extension" == "jpg" ]  || [ "$extension" == "JPG" ] || [ "$extension" == "jpeg" ]; then
  ##Crear directorio fotos en ruta actua
  mkdir -p ~/fotos
  ##Copiar el archivo a ~/fotos
  cp "$archivo" ~/fotos
  echo "el archivo se copio a ~/fotos"
else
  echo "El archivo no es una jpg, JPG, jpeg no se hara nada"
fi
