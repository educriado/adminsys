#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Extiende las capacidades de un grupo volumen (parametro) con las particiones (parametros)
# usar lvextend y luego agrandar el filesystem

if [ #? -lt 2]
then
	echo "Uso: $0 grupo {particion}"
	exit 1
fi

grupovolum=$1


