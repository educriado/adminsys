#!/bin/bash
#Cambiar la direccion de ciertas maquinas en /etc/hosts de forma que el ultimo numero
#de la direccion sea igual al sufijo del nombre + 40.
#-------------------------------------------------------------------------------------------
#  Ejemplo:
#	212.128.4.213 gamma03.escet.urjc.es gamma03 -> 192.168.0.43 gamma03.escet.urjc.es gamma03
#
#-------------------------------------------------------------------------------------------

if [ $# -ne 1 ]; then
	echo "Uso: $0 fichero_host"
fi

while read ip dominio host 
do
	echo "$host" | egrep 'gamma' > /dev/null
	if [ $? -eq 0 ]
	then
		numero=$(echo "$host" | sed -r 's/.*(..)/\1/')
		numero=$((40 + $numero))
		nuevaip=192.168.0."$numero"
		echo "$nuevaip $dominio $host"
	fi
done < $1
