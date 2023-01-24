#!/bin/sh

IP=$(cat /root/remote_host_ip)

ssh-keyscan "$IP" >~/.ssh/known_hosts 2>/dev/null

echo
if [ -s ~/.ssh/known_hosts ]; then
    echo "Fichero de claves conocidas actualizado para el host: $IP"
else
    echo "ERROR: No se ha podido actualizar el fichero de claves conocidas del host: $IP"
fi
