#!/bin/bash

# extracting all parameters that contain binary data is being used in the Filebeat processor,
# to decode base64 encoding before sending data to elasticsearch

SCRIPT_DIR=$(dirname $0)

sysdig -L | grep -oE "BYTEBUF \w+" | cut -d' ' -f2 | sort | uniq | tee $SCRIPT_DIR/binary_params.txt
