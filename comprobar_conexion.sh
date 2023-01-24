#!/bin/sh

IPS=$(cat /workspace/output/ips)

echo
for IP in $IPS; do
    echo "Comprobando conectividad con $IP..."
    nc -vz "$IP" 22 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "Conectado con $IP"
        echo $IP >/workspace/remote_host_ip
        exit
    fi
done
