#!/bin/bash
# Eduardo Criado - 662844
# Pablo Hernandez - 616923
# Recibiendo informacion desde entrada estandar, crea o extiende los volumenes logicos y sistemas
# de ficheros que residan en dichos volumenes.
# Si los volumenes logicos son nuevos hay que introducir en fstab la linea
# correspondiente para el arranque del sistema.
# La especificacion de la entrada es:
# grupoVolumen,volumenLogico,tamaño,tipoSistFich,directorioMont
# Vamos a restringir que el tamaño venga en MB

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
	resultado=$(ssh -n user@$direccion sudo lvdisplay grupo)
	#El volumen ya existe, hay que agrandarlo
	if [ echo "$resultado" | grep $vol ]
	then
		echo "Extendiendo el volumen logico..."
		ssh -n user@$direccion sudo lvextend -L+ $tam $grupo/$vol 
		#Hay que agrandar el filesystem
		tamanterior=$(ssh -n user@$direccion sudo lvs | grep $vol | tr -s ' ' | cut -d ' ' -f5)
		#Quitamos la unidad
		tamanterior=$(echo "$tamanterior" | tr -d 'm')
		tamnuevo=$(($tamanterior + $tam))
		#Tenemos que saber el tamaño anterior para redimensionarlo correctamente
		ssh -n user@$direccion sudo umount /dev/$grupo/$vol
		ssh -n user@$direccion sudo resize2fs /dev/$grupo/$vol $tamnuevo
		ssh -n user@$direccion sudo mount -t $tipo /dev/$grupo/$vol

	else
		#Tenemos que crear el volumen, montarlo y añadirlo a fstab
		ssh -n user@$direccion sudo lvcreate -L$tam -n $vol $grupo
		ssh -n user@$direccion sudo mkfs -t $tipo /dev/$grupo/$vol
		ssh -n user@$direccion sudo mount /dev/$grupo/$vol $dir
		ssh -n user@$direccion sudo echo /dev/$grupo/$vol $dir $tipo defaults 0 2 >> sudo /etc/fstab

	fi
done

