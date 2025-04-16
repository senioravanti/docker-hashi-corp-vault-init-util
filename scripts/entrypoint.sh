#!/bin/bash
set -e

# Даем время контейнеру инициализироваться
sleep 30s

curl -sS \
  -X GET \
  'http://vault:8200/v1/sys/health' > /tmp/healthcheck.json

IS_INITIALIZED=$(cat /tmp/healthcheck.json | jq -r '.initialized')
IS_SEALED=$(cat /tmp/healthcheck.json | jq -r '.sealed')

cd /usr/local/bin/init-vault/

if [ $IS_INITIALIZED = 'false' ]; then
    printf "initialize vault ...\n"
    /bin/sh "./gen-token.sh"
fi

if [ $IS_SEALED = 'true' ]; then
    printf "unseal vault ...\n"
    /bin/sh "./unseal.sh"
fi

if [ $IS_INITIALIZED = 'false' ]; then
    if [ $(ls -A /docker-entrypoint-init.d) ]; then
        printf "executing scripts from /docker-entrypoint-init.d ...\n"
        find /docker-entrypoint-init.d -maxdepth 1 -type f -name '*.sh' | sort | xargs -n 1 /bin/sh
    else
        printf "/docker-entrypoint-init.d is empty :(\n"
    fi
fi