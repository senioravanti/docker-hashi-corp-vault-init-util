# Утилита, инициализирующая HashiCorp Vault

## Сборка и развертывание

```sh
clear ; docker build . \
    -f ./Dockerfile \
    -t 'stradiavanti/init-vault:0.1' \
    --push
```

```sh
CONTAINER_NAME=''
SCRIPT_DIR=''
SECRET_DIR=''
VAULT_NETWORK=''

clear ; docker run -d --name $CONTAINER_NAME \
    -v "$SCRIPT_DIR:/docker-entrypoint-initdb.d" \
    -v "$SECRET_DIR:/usr/local/share/vault/secrets" \
    --network "$VAULT_NETWORK" \
    'stradiavanti/init-vault:0.1'
```


## Пример compose-файла

```yaml
name: my-vault

volumes:
  my-vault-vault-data:


networks:
  my-vault-vault-net:


services:
  vault:
    image: 'hashicorp/vault:1.19'
    container_name: 'my-vault-vault'

    volumes:
      - 'my-vault-vault-data:/vault/file'
      - './vault/config/:/vault/config/'

    cap_add:
      - IPC_LOCK

    healthcheck:
      test: [ "CMD", "wget", "-nv", "--spider", "http://127.0.0.1:8200/v1/sys/health" ]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 5s

    command: 'server'

    ports:
      - '8200:8200' # api
      - '8201:8201'

    networks:
      my-vault-vault-net:


  init-vault:
    image: 'stradiavanti/init-vault:0.1'
    container_name: 'my-vault-init-vault'

    # сервис "распечатывает" vault, а healthcheck возвращает true только в том случае, если vault распечатан
    depends_on:
      vault:
        condition: service_started

    volumes:
      - './vault/secrets:/usr/local/share/vault/secrets'
      - './vault/scripts:/docker-entrypoint-init.d'

    networks:
      my-vault-vault-net:
```