#!/bin/bash
set -e -u

KEYS_REQUEST=$(cat <<EOF | jq -c
{
    "secret_shares": 4,
    "secret_threshold": 2  
}
EOF
)

curl -sS --max-time 120 \
    -X POST \
    --json "$KEYS_REQUEST" \
    -o /tmp/keys.json \
    'http://vault:8200/v1/sys/init'

printf "fetch keys ...\n"
# Обработка ключей
cat /tmp/keys.json | jq '.keys' > "/usr/local/share/vault/secrets/unseal-keys.json"
cat /tmp/keys.json | jq '.keys_base64' > "/usr/local/share/vault/secrets/unseal-keys-base64.json"
cat /tmp/keys.json | jq -r '.root_token' > "/usr/local/share/vault/secrets/root-token.txt"