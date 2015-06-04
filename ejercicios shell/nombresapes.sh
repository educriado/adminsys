#!/bin/bash
#Junta los nombres y apellidos y sin repetir quedate con un nombre e indica el numero de repetidos

paste -d ' ' $1 $2 |  sort -k 2 | uniq -c -f1