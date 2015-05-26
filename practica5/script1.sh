#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Comprobar remotamente (ssh) la situacion de uso y organizacion de discos mediante
# el comando fdisk -l 

direccion="192.168.56.2"

#Mostar discos duros disponibles
echo "Discos duros disponibles:"
resultado=$(ssh -n user@$direccion sudo sfdisk -s)
echo "$resultado" | egrep '^/dev/' |
while read disco tamanyo
do
	taman=$(($tamanyo/1000))
	echo "$disco $taman MB"

done
#Mostrar la lista de particiones y sus tamanyos
echo "Particiones existentes (con su tamaño en bytes):"
particiones=$(ssh -n user@$direccion sudo sfdisk -l | egrep '^/dev/' | tr -d '*' | tr -s ' ' | cut -d' ' -f 1,5)
echo "$particiones" |
while read particion tamanyo
do
	tamanyo=$((tamanyo/1000))
	echo "$particion $tamanyo MB"
done

#Mostramos los grupos y volumenes logicos

grupos=$(ssh -n user@$direccion sudo vgs | tr -s ' ' | cut -d' ' -f 2,7,8)
discos=$(ssh -n user@$direccion sudo pvs | tr -s ' ' | cut -d' ' -f 2,3,6,7)
logicos=$(ssh -n user@$direccion sudo lvs | tr -s ' ' | cut -d' ' -f 2,3,5)
cuenta=0
echo "$grupos" |
while read nombreg tamg esplg
do
	if [ "$cuenta" != "0" ]
	then
		echo "Grupo:$nombreg con tamaño:$tamg y espacio libre:$esplg"
		echo "$discos" |
		while read nombred grupod tamd lind
		do
			if [ "$grupod" == "$nombreg" ]
			then
			 echo "	$nombred $tamd $lind"
			fi
		done
		echo "$logicos" |
		while read nombrel grupol taml
		do
			if [ "$grupol" == "$nombreg" ]
			then
			 echo "	$nombrel $taml"
			fi
		done
		echo " "
	fi
	cuenta=$(($cuenta + 1))
done

#Informacion del sistema de montaje de ficheros, salvo tmpfs

monta=$(ssh -n user@$direccion df -hT)
#Con la opcion -e para interpretar los tabuladores
echo -e 'Particion \t Tipo \t Montado en \t Tamanyo \t Disponible'
echo "$monta" | 
while read nombre tipo tamanyo usados disp uso montado
do
	
	if [ "$nombre" != "tmpfs" ] && [ "$nombre" != "S.ficheros" ]
	then
		echo -e "$nombre \t $tipo \t $montado \t $tamanyo \t $disp"
	fi
done 
