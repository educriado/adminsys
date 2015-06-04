#!/bin/bash

#Expresiones regulares
sed -r 's/No/XX/g'			#Cambia No por XX
sed -r 's/^/>>/'			#Inserta >> el principio de cada linea
sed -r 's/(*)..$/\1/g' 		#Elimina dos ultimos caracteres de la linea
sed -r 's/(.*)\..*/\1/g' 	#Borrar extension de ficheros
sed -r 's/[AEIOUaeiou]//g'	#Elimina todas las vocales de un texto
sed -r 's/[A-Z]/*/g'		#Sustituye las mayusculas por *
sed -r 's/[ ]+/ /g'			#Espacios repetidos por uno solo
sed -r 's/.{10}//g'			#Elimina los diez primeros caracteres de una linea
							#Detecta los numeros de telefono
egrep '[6-9][0-9]{2} [0-9]{3} [0-9]{3}|[6-9][0-9]{2}-[0-9]{3}-[0-9]{3}'
