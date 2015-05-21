#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Recibiendo informacion desde entrada estandar, crea o extiende los volumenes logicos y sistemas
# de ficheros que residan en dichos volumenes.
# Si los volumenes logicos son nuevos hay que introducir en fstab la linea
# correspondiente para el arranque del sistema.
# La especificacion de la entrada es:
# grupoVolumen,volumenLogico,tamaño,tipoSistFich,directorioMont

direccion="192.168.56.2"

#Leemos de entrada estandar
echo -n "Introduce la linea con la información: "
read info

#Separamos en espacios los campos para leerlos por separado
info=$(echo "$info" | tr ',' ' ')
echo "$info" |
while read grupo vol tam tipo dir
do
	#Comprobar la pertenencia
done

