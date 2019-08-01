#!/bin/bash

# set -x

TRACKED_CONTAINER=dvwa-sql-app_victim_1 #${1:-pratikum-sec-inf-and-event-mgmt_dummy-app_1}

if [ -z "$(which jq)" ]
then
    echo "please install 'jq' first (e.g. 'sudo apt install jq')"
    exit 1
fi

if [ -n "$1" ] 
then
    if [ "--track" != "$1" ]
    then
        echo "specify '--track' to enable sysdig syscall tracking"
        exit 1
    else
        TRACK_SYSCALLS=true
    fi
else
    TRACK_SYSCALLS=false
fi

# fix potential error when running elk
if [ $(sysctl vm.max_map_count | awk '{print $3}') -lt 262144 ] 
then 
	sudo sysctl -w vm.max_map_count=262144
fi

docker-compose up -d --build
# waiting for ELK to be up and running
until [ -n "$(curl --silent -w "\n" http://localhost:9200/_cat/indices)" -a "$(curl --silent -w "\n" http://localhost:5601/api/kibana/settings -H "kbn-version:7.2.0")" != "Kibana server is not ready yet" ]; do
    echo "waiting for ELK to come up..."
    sleep 5;
done;


# -------- CONFIGURING ELASTICSEARCH --------
echo "create default ES index: "
curl --silent -w "\n" -X PUT http://localhost:9200/filebeat-default
echo "define index mapping: "
curl --silent -w "\n" -X PUT http://localhost:9200/filebeat-default/_mappings -H "Content-Type:application/json" -d@elasticsearch-default-filebeat-mapping.json

# -------- CONFIGURING KIBANA --------
KIBANA_INDEX_PATTERN_ID=8098fa00-9e67-11e9-a82b-7bda944bfa90
echo "define the kibana index pattern with id $KIBANA_INDEX_PATTERN_ID: "
curl --silent -w "\n" http://localhost:5601/api/saved_objects/index-pattern/8098fa00-9e67-11e9-a82b-7bda944bfa90?overwrite=true \
	-H "Content-Type:application/json" \
	-H "kbn-version:7.2.0" \
	-d '{"attributes":{"title":"filebeat*","timeFieldName":"@timestamp"}}'
echo "set this index pattern as default: "
curl --silent -w "\n" http://localhost:5601/api/kibana/settings -H "Content-Type:application/json" -H "kbn-version:7.2.0" -d '{"changes":{"defaultIndex":'${KIBANA_INDEX_PATTERN_ID}'}}'

echo "add visualizations & dashboard: "
curl --silent -w "\n" http://localhost:5601/api/saved_objects/_import?overwrite=true -H kbn-version:7.2.0 --form file=@dashboard_and_visualizations.ndjson

if [ $TRACK_SYSCALLS == true ]
then
    echo "now running sysdig to log syscalls";

    # query the dummy app
    trap "kill 0" EXIT
    while true; do curl --silent localhost:8080 > /dev/null; sleep 0.5; done &

    sudo sysdig -j -s 8000 -pc container.name=${TRACKED_CONTAINER} > logs/sysdig/syscalls.log 
fi

