#!/bin/bash

SCRIPT_DIR=$(dirname $0)

sysdig -L | awk -F'(' '{print $2}' | grep -oE '([a-z])\w+' | sort | uniq | tee $SCRIPT_DIR/syscall_params.txt
