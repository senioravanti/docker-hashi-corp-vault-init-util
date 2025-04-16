#!/bin/bash
set -e -u

# Распечатываем vault
curl -sS \
    -X POST \
    --json "{ \"key\": \"$(cat "/usr/local/share/vault/secrets/unseal-keys-base64.json" | jq -r '.[0]')\" }" \
    'http://vault:8200/v1/sys/unseal'

curl -sS \
    -X POST \
    --json "{ \"key\": \"$(cat "/usr/local/share/vault/secrets/unseal-keys-base64.json" | jq -r '.[1]')\" }" \
    'http://vault:8200/v1/sys/unseal'