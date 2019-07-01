#!/bin/bash

nginx
tail -f /var/log/nginx/access.log -f /var/log/nginx/error.log
