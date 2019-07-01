#!/bin/bash

set -x

# fix potential error when running elk
if [ $(sysctl vm.max_map_count | awk '{print $3}') -lt 262144 ] 
then 
	sudo sysctl -w vm.max_map_count=262144
fi

docker-compose up -d --build

sudo sysdig -j -pc container.name!=host > logs/sysdig/syscalls.log
