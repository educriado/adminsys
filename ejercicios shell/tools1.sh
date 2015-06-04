#!/bin/bash
#Buscar en /etc/passwd usuarios con id mayor a 99
cat /etc/passwd | 
egrep '^.*:.*:[0-9][0-9][0-9]:' #Deberia de funcionar con {3} despues de la expresion

#Para ordenarlos:
cat /etc/passwd | 
egrep '^.*:.*:[0-9][0-9][0-9]:' | 
sort -t : -k 3 -n

#Dados dos ficheros, juntarlos pero solo 1 apellido y contar cuantos apellidos iguales hay


#Extraer hora y minuto de la fecha
date | cut -d ' ' -f 5 | cut -d : -f 1,2
