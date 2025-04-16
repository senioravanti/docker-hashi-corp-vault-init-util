FROM alpine:3.21

VOLUME [ "/docker-entrypoint-init.d", "/usr/local/share/vault/secrets" ]

RUN apk add --no-cache --update \
    openssh-keygen \
    openssl \
    curl \
    jq \
    pwgen

RUN mkdir /docker-entrypoint-init.d

COPY ./scripts/* /usr/local/bin/init-vault/
RUN chmod +x /usr/local/bin/init-vault/*.sh

ENTRYPOINT [ "/bin/sh" ]
CMD [ "/usr/local/bin/init-vault/entrypoint.sh" ]