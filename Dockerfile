FROM debian:13-slim

ENV DEBIAN_FRONTEND=noninteractive

# renovate: datasource=repology depName=debian_13/clamav
ARG CLAMAV_VERSION=1.4.3+dfsg-1

RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN groupadd -r clamav && useradd -r -g clamav -s /bin/sh -d /var/lib/clamav clamav

# The CI reaches the internet through an authenticated proxy, which buildx
# exports as $http_proxy into every RUN step. clamav-freshclam's maintainer
# scripts copy whatever they find there - credentials included - into
# freshclam.conf, the ucf cache and the debconf database. Pass the proxy to apt
# through its own configuration instead - not with -o, which apt would record
# in /var/log/apt/history.log - and drop it from the environment the scripts
# inherit. "DIRECT" is apt's way of spelling "no proxy".
RUN printf 'Acquire::http::Proxy "%s";\nAcquire::https::Proxy "%s";\n' \
        "${http_proxy:-DIRECT}" "${https_proxy:-${http_proxy:-DIRECT}}" > /etc/apt/apt.conf.d/99-ci-proxy && \
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        c-icap \
        clamav=${CLAMAV_VERSION} libc-icap-mod-virus-scan clamav-daemon=${CLAMAV_VERSION} && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /etc/apt/apt.conf.d/99-ci-proxy

RUN echo 'TCPAddr 0.0.0.0\nTCPSocket 3310' >> /etc/clamav/clamd.conf

# freshclam reads the proxy from libcurl's environment variables and never
# writes it anywhere, so this step keeps them.
RUN freshclam

COPY ./etc /etc
RUN mkdir -p /var/run/c-icap /var/run/clamav /var/log/c-icap && \
    chown -R clamav:clamav /var/run/clamav /var/log/c-icap /var/run/c-icap /etc/c-icap

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV DEBIAN_FRONTEND=""

USER clamav

EXPOSE 1344 3310

ENTRYPOINT ["/entrypoint.sh"]
