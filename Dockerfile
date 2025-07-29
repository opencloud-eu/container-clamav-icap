FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# renovate: datasource=repology depName=debian_12/clamav
ARG CLAMAV_VERSION=1.0.7+dfsg-1~deb12u1

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN groupadd -r clamav && useradd -r -g clamav -s /bin/sh -d /var/lib/clamav clamav

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        c-icap libicapapi-dev \
        clamav=${CLAMAV_VERSION} libc-icap-mod-virus-scan clamav-daemon=${CLAMAV_VERSION} && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Remove HTTPProxy line from freshclam.conf which has been added automatically
# by clamav package installation due to the woodpecker proxy configuration.
# This line needs be removed because the container should be used in a
# non-proxy environment.
RUN sed -i '/^HTTPProxy/d' /etc/clamav/freshclam.conf

RUN freshclam

COPY ./etc /etc
RUN mkdir -p /var/run/c-icap /var/run/clamav /var/log/c-icap && \
    chown -R clamav:clamav /var/run/clamav /var/log/c-icap /var/run/c-icap /etc/c-icap

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV DEBIAN_FRONTEND=""

USER clamav

ENTRYPOINT ["/entrypoint.sh"]
