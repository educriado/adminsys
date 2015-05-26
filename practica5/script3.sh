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


#Leemos de entrada estandar
echo -n "Introduce la linea con la información: "
read info

#Separamos en espacios los campos para leerlos por separado
info=$(echo "$info" | tr ',' ' ')
echo "$info" |
while read grupo vol tam tipo dir
do
	#Comprobar la pertenencia
	resultado=$( sudo lvdisplay $grupo )
	#El volumen ya existe, hay que agrandarlo
	busqueda=$( echo "$resultado" | grep -c "$vol" )
	if [ $busqueda -gt 1 ]
	then
		echo "Extendiendo el volumen logico..."
		sudo lvextend -L+$tam $grupo/$vol 
		#Hay que agrandar el filesystem
		tamanterior=$( sudo lvs | grep $vol | tr -s ' ' | cut -d ' ' -f5)
		#Quitamos la unidad
		tamanterior=$(echo "$tamanterior" | tr -d 'm')
		tamnuevo=$(($tamanterior + $tam))
		#Tenemos que saber el tamaño anterior para redimensionarlo correctamente
		sudo umount $dir
		sudo resize2fs /dev/$grupo/$vol $tamnuevo
		sudo mount -t $tipo /dev/$grupo/$vol $dir

	else
		#Tenemos que crear el volumen, montarlo y añadirlo a fstab
		sudo lvcreate -L$tam -n $vol $grupo
		sudo mkfs -t $tipo /dev/$grupo/$vol
		sudo mkdir $dir
		sudo mount /dev/$grupo/$vol $dir
		sudo sed -i -e '$a'"/dev/$grupo/$vol $dir $tipo defaults 0 2" /etc/fstab
	fi
done

