FROM debian:bookworm-slim
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y c-icap libicapapi-dev clamav libc-icap-mod-virus-scan clamav-daemon

RUN freshclam

COPY ./etc /etc
RUN mkdir -p /var/run/c-icap /var/run/clamav && \
    chown -R c-icap:c-icap /var/run/c-icap /etc/c-icap/ && \
    chown clamav:clamav /var/run/clamav

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
