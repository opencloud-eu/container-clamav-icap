# SPDX-FileCopyrightText: 2023 Bundesministerium des Innern und für Heimat, PG ZenDiS "Projektgruppe für Aufbau ZenDiS"
# SPDX-License-Identifier: Apache-2.0
FROM external-registry.souvap-univention.de/sovereign-workplace/alpine:3.22.1

ENV TZ=Etc/UTC

WORKDIR /src

# Version of Clamav ICAP server
# renovate: datasource=github-tags depName=c-icap/c-icap-server
ARG VERSION=C_ICAP_0.6.4

ARG ICAP_ARTIFACT=https://netcologne.dl.sourceforge.net/project/c-icap/c-icap/0.6.x/c_icap-${VERSION#C_ICAP_}.tar.gz
ARG ICAP_MODULES_ARTIFACT=https://netcologne.dl.sourceforge.net/project/c-icap/c-icap-modules/0.5.x/c_icap_modules-0.5.7.tar.gz

# hadolint ignore=DL3008  We want the latest stable versions
RUN apk update && apk upgrade \
 && apk add --no-cache \
        make \
        cmake \
        g++ \
        wget \
        tzdata \
        file \
        zlib-dev \
        zlib \
        bzip2-dev \
        libbz2 \
        brotli-dev \
        brotli \
        bind-tools \
        sed \
 # Download ICAP
 && wget -q ${ICAP_ARTIFACT} -O icap.tar.gz \
 && tar -xf icap.tar.gz -C /src --strip-components=1 \
 # Build ICAP
 && ./configure --prefix=/var/lib/clamav \
 && make -s \
 && make install \
 # Remove src
 && rm -rf /src/* \
 # Download ICAP Modules
 && wget -q ${ICAP_MODULES_ARTIFACT} -O icap-modules.tar.gz \
 && tar -xf icap-modules.tar.gz -C /src --strip-components=1 \
 # Build ICAP Modules
 && ./configure --with-c-icap=/var/lib/clamav --prefix=/var/lib/clamav \
 && make -s \
 && make install \
 # Remove src
 && rm -rf /src/* \
 # Create user
 && addgroup -S "clamav" \
 && adduser -D -G "clamav" -h "/var/lib/clamav" -s "/bin/false" -u 100 -S "clamav" \
 && chown -R clamav:clamav /var/lib/clamav \
 # Remove builder tools
 && apk del \
    make \
    cmake \
    g++ \
    wget \
    zlib-dev \
    brotli-dev \
    bzip2-dev \
    apk-tools

EXPOSE 1344

CMD [ "/var/lib/clamav/bin/c-icap", "-N"]
