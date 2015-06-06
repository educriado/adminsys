#!/bin/bash
#Eduardo Criado - 662844
#Pablo Hernandez - 616923
#Pequeños programas que extraen informacion de monitorizacion de
#la otra maquina.
#Una de las dos maquinas mantienen los logs de las dos maquinas (/var/log/monitorizacion)


#Saber si la maquina está conectada a la otra
direccionotra="192.168.56.3"
ping -c1 "$direccionotra" > /dev/null
if [ $? -eq 0 ]
then
	echo La maquina esta conectada
else
	echo La maquina no esta conectada
	exit 1
fi

#Número de usuarios y carga de procesador
uptime | tr -s ' ' | cut -d' ' -f7,8,11

#Memoria ram libre y ocupada
echo -e "Uso de memoria: \nLibre Ocupada";
free | egrep 'Mem' | tr -s ' ' | cut -d ' ' -f3,4

#Swap utilizada
echo "Swap utilizada:"
free | egrep 'Swap' | tr -s ' ' | cut -d ' ' -f3

#Espacio ocupado y espacio libre, en MB en este caso
df -m | tr -s ' ' | cut -d ' ' -f1,3,4

#Numero de puertos y conexiones abiertos
#Consideramos conexion activa la que aparece ESTABLISHED
#Consideramos los puertos con estado LISTENING o CONNECTED
conexiones=$(netstat -a | egrep -c 'ESTABLISHED')
puertos=$(netstat -a | egrep -c 'LISTENING | CONNECTED')
echo "Tenemos $conexiones conexiones y $puertos puertos."

#Numero de programas en ejecucion
programas=$(ps | grep -cv 'PID')
echo "Tenemos $programas programas en ejecucion."