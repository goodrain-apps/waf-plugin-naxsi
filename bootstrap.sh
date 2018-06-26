#!/bin/bash

confd --template /etc/nginx/nginx.conf.template --out /etc/nginx/nginx.conf &

exec nginx -g "daemon off;"
