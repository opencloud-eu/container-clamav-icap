FROM debian:bullseye-slim

RUN /bin/sh -c set -eux && apt-get update \
    && apt-get install -y --no-install-recommends \
    ca-certificates \
    c-icap \
    libc-icap-mod-virus-scan \
    clamav \
    && rm -rf /var/lib/apt/lists/*

ADD config/c-icap.conf /etc/c-icap/c-icap.conf
ADD config/virus_scan.conf /etc/c-icap/virus_scan.conf
ADD config/clamav_mod.conf /etc/c-icap/clamav_mod.conf

RUN usermod -a -G c-icap c-icap \
    && mkdir -p /var/run/c-icap \
    && touch /var/run/c-icap/c-icap.id \
    && chown -R c-icap.c-icap /var/run/c-icap/

RUN /usr/bin/freshclam

CMD ["/bin/bash"]
ADD entrypoint.sh /entrypoint.sh
EXPOSE 1344
ENTRYPOINT /entrypoint.sh
