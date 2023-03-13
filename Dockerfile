FROM debian:bullseye-slim

RUN /bin/bash -c set -eux && mkdir -p /var/lib/clamav/ \
    && chmod 777 /var/lib/clamav/
VOLUME /var/lib/clamav

RUN /bin/bash -c set -eux && apt-get update \
    && apt-get install -y --no-install-recommends \
    c-icap \
    ca-certificates \
    clamav \
    libc-icap-mod-virus-scan \
    && rm -rf /var/lib/apt/lists/*

RUN /bin/bash -c set -eux && usermod -g c-icap c-icap \
    && mkdir -p /run/c-icap/ \
    && chown -R c-icap.c-icap /run/c-icap/ /var/lib/clamav/ \
    && rm /etc/c-icap/clamd_mod.conf

ADD --chown=c-icap:c-icap config/c-icap.conf /etc/c-icap/c-icap.conf
ADD --chown=c-icap:c-icap config/virus_scan.conf /etc/c-icap/virus_scan.conf
ADD --chown=c-icap:c-icap config/clamav_mod.conf /etc/c-icap/clamav_mod.conf
ADD entrypoint.sh /entrypoint.sh

USER c-icap:c-icap
CMD ["/bin/bash"]
EXPOSE 1344
ENTRYPOINT /entrypoint.sh
