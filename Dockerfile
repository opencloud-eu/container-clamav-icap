from ubuntu/squid

RUN apt-get update && apt-get install -y build-essential c-icap libicapapi-dev libssl-dev
RUN mkdir -p /build-squid-clamav/
WORKDIR /build-squid-clamav/
COPY squidclamav/ .
RUN ./configure --with-c-icap=/usr
RUN make
RUN make install
