#!/bin/bash
#El del correo es muy facil
#Enviar un correo a cada alumno con su nota

if [ $# -ne 1 ]
then
	echo "Uso: $1 fichero_nombres_apellidos"
	exit 1
fi

aprobados=$(grep -c apto $1)
suspendidos=$(grep -c 'no apto' $1)
presentados=$(($aprobados+$suspendidos))
sed -r "s/(^[A-Za-z]+) ([A-Za-z]+) ([A-Za-z ]+)/mailto: direccion@unizar.es body \1 \2 \3. Presentados: $presentados, aprobados: $aprobados./g" $1