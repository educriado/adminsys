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
free | tr -s ' ' | cut -d' ' -f2,3,4 | (
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
)
#Espacio ocupado y espacio libre
df
#Puertos y conexiones abiertos
#netstat
