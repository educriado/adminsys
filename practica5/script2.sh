#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Extiende las capacidades de un grupo volumen (parametro) con las particiones (parametros)
# usar lvextend 

if [ "$#" -lt 2 ]
then
	echo "Error en el uso de parametros."
	echo "Uso: $0 grupo {particion}"
	exit 1
fi

for arg in "$@"
do
	if [ "$arg" != "$0" ] && [ "$arg" != "$1" ]
	then
		#Añadimos las particiones al grupo indicado
		sudo vgextend "$1" "$arg"	
	fi
done

