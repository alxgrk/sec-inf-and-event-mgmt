#!/bin/bash

SCRIPT_DIR=$(dirname $0)

sysdig -L | cut -d' ' -f2 | cut -d'(' -f1 | sort | uniq | tee $SCRIPT_DIR/supported-syscalls.txt
