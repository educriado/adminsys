#!/bin/bash
#Eduardo Criado - 662844
#Pablo Hernandez - 616923
#Pequeños programas que extraen informacion de monitorizacion de
#la otra maquina.
#Una de las dos maquinas mantienen los logs de las dos maquinas (/var/log/monitorizacion)


#Saber si la maquina está conectada
ping -c1 www.google.es > /dev/null
if [ $? -eq 0 ]
then
	echo La maquina esta conectada
else
	echo La maquina no esta conectada
fi

#Número de usuarios y carga de procesador
uptime | tr -s ' ' | cut -d' ' -f7,8,11

#Memoria ram libre y ocupada
cuenta=0
free | tr -s ' ' | cut -d' ' -f2,3,4 | 
while read info1 info2 info3
do
	if [ $cuenta -eq 0 ]
	then
		echo total	usado	libre
	elif [ $cuenta -eq 1 ]
	then
		echo $info1	$info2	$info3
	fi
	cuenta=$(($cuenta+1))
done

#Espacio ocupado y espacio libre, en MB en este caso
df -m | tr -s ' ' | cut -d ' ' -f1,3,4
#Numero de puertos y conexiones abiertos
#Las conexiones aparecen despues del primer Active y los puertos despues
#del segundo.
active=0
puertos=0
echo "Conexiones activas:"
while read proto recv send local addr faddr state
do
	if [ "$proto" = "Active" ]
	then 
		active=$(($active + 1))
	elif [ "$proto" != "Proto" ]
	then
		if [ "$active" -eq 1 ]
		then
			#Tenemos conexiones
			echo "$proto $recv $send $addr $faddr $state"
		else
			#Tenemos puertos
			puertos=$(($puertos + 1))
		fi
	fi
done <<< $(netstat)
#Hay que solucionar que la variable no se actualiza (proceso hijo)
echo "Tenemos $puertos puertos."

