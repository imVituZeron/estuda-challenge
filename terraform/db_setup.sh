#!/bin/bash

if [ -e terraform.tfstate ]; then
    IP_ADDRESS=$(cat terraform.tfstate | grep public_ip_address | cut -d : -f 2 | cut -d "\"" -f 2)
else
    IP_ADDRESS=$1
fi

# decompress the sql file
cd ../base
gunzip estuda_clients_dump.sql.gz

# Connect to the database and execute SQL file
mysql -h $IP_ADDRESS -u root -p'bi7d2lyFNV9ZwjB3' estuda_clients < ../base/estuda_clients_dump.sql