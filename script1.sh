#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Comprobar remotamente (ssh) la situacion de uso y organizacion de discos mediante
# el comando fdisk -l tras asegurarnos que el disco añadido es sdb hacemos: 
# sudo fdisk /dev/sdb
# tras esto se pone la opcion n
# se indica que la particion debe ser p de primaria
# numero de particion 1, valor predeterminado, valor predeterminado, valor predeterminado
# se repite con numero de particion 2.
# sudo mkfs -t ext3 /dev/sdb1
# sudo mkfs -t ext4 /dev/sdb2
# sudo mkdir /sdb1
# sudo mkdir /sdb2
# sudo mount -t ext3 /dev/sdb1 /sdb1
# sudo mount -t ext4 /dev/sdb2 /sdb2
# sudo less /etc/mtab  #--para comprobar
# Añadir a /etc/fstab para que se monten al principio
# /dev/sdb1 /sdb1 ext3 defaults  0 2
# /dev/sdb2 /sdb2 ext4 defaults  0 2

#Mostar discos duros disponibles
echo "Discos duros disponibles:"
resultado=$(ssh -n user@192.168.56.2 sudo sfdisk -s)
while read disco tamanyo
do
	if [ "$disco" != "total" ]
	then
		tamanyo=$(($tamanyo/1000000))
		echo "$disco $tamanyo MB"
	fi
done < "$resultado"
#Mostrar la lista de particiones y sus tamanyos
echo "Particiones existentes (con su tamaño en bytes):"
ssh user@192.168.56.2 sudo sfdisk -l | egrep '^/dev/' | tr -d '*' | tr -s ' ' | cut -d ' ' -f1,5
#Guardamos el tamanyo de bloque
blocksize=$(ssh -n user@192.168.56.2 sudo tune2fs -l /dev/sda1 | egrep 'Block size' | cut --characters=27-30)
echo $blocksize
