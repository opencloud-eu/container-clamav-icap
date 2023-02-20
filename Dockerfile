FROM debian:bullseye-slim

RUN /bin/sh -c set -eux && apt-get update \
    && apt-get install -y --no-install-recommends \
    c-icap \
    libc-icap-mod-virus-scan \
    vim aptitude mlocate \
    && rm -rf /var/lib/apt/lists/*

ADD config/c-icap.conf /etc/c-icap/c-icap.conf
ADD config/virus_scan.conf /etc/c-icap/virus_scan.conf
ADD config/clamd_mod.conf /etc/c-icap/clamd_mod.conf

RUN usermod -a -G c-icap c-icap \
    && mkdir -p /var/run/c-icap \
    && touch /var/run/c-icap/c-icap.id \
    && chown -R c-icap.c-icap /var/run/c-icap/

CMD ["/bin/bash"]
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
