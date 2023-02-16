FROM debian:bullseye-slim

RUN /bin/sh -c set -eux && apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates c-icap \
    && rm -rf /var/lib/apt/lists/*

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
ADD c-icap.conf /etc/c-icap/c-icap.conf

CMD ["/bin/bash"]

RUN usermod -a -G c-icap c-icap \
    && mkdir -p /var/run/c-icap \
    && touch /var/run/c-icap/c-icap.id \
    && chown -R c-icap.c-icap /var/run/c-icap

#clamd_mod
