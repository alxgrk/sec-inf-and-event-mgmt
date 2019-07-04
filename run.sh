#!/bin/bash

set -x

# fix potential error when running elk
if [ $(sysctl vm.max_map_count | awk '{print $3}') -lt 262144 ] 
then 
	sudo sysctl -w vm.max_map_count=262144
fi

docker-compose up -d --build
# waiting for ELK to be up and running
until [ -n "$(curl http://localhost:9200/_cat/indices)" ]; do
    sleep 10;
done;


# -------- CONFIGURING ELASTICSEARCH --------
curl -X PUT http://localhost:9200/filebeat-default
curl -X PUT http://localhost:9200/filebeat-default/_mappings -H "Content-Type:application/json" -d@elasticsearch-default-filebeat-mapping.json

# -------- CONFIGURING KIBANA --------
# define the kibana index pattern
KIBANA_INDEX_PATTERN_ID=$(curl http://localhost:5601/api/saved_objects/index-pattern \
	-H "Content-Type:application/json" \
	-H "kbn-version:7.2.0" \
	-d '{"attributes":{"title":"filebeat*","timeFieldName":"@timestamp"}}' \
	| jq '.id')
# set this index pattern as default
curl http://localhost:5601/api/kibana/settings -H "Content-Type:application/json" -H "kbn-version:7.2.0" -d '{"changes":{"defaultIndex":'${KIBANA_INDEX_PATTERN_ID}'}}'

# add visualizations
curl http://localhost:5601/api/saved_objects/_import -H kbn-version:7.2.0 --form file=@evt-type-pie-chart.ndjson

# TODO re-enable
# sudo sysdig -j -pc container.name!=host > logs/sysdig/syscalls.log
