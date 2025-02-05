#!/bin/bash
# execute-sql.sh

if [ -e terraform.tfstate ]; then
    IP_ADDRESS=$(cat terraform.tfstate | grep public_ip_address | cut -d : -f 2 | cut -d "\"" -f 2)
else
    IP_ADDRESS=$1

# discompress the sql file
gunzip ./base/estuda_clients_dump.sql.gz

# Connect to the database and execute SQL file
mysql -h $IP_ADDRESS -u $1 -p$2 $3 < ./base/estuda_clients_dump.sql