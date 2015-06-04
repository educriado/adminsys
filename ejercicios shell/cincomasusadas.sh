#!/bin/bash
#Muestra las cinco palabras mas usadas de un texto
cat "$1" | sed -e 's/\s\+/\n/g' -e '/^$/d' | sort | uniq -c | sort -n -r -k 1 | head -n 5