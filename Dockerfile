from ubuntu/squid

WORKDIR /build-squid-clamav/
COPY squidclamav/ .
RUN apt-get update && apt-get install -y build-essential c-icap libicapapi-dev libssl-dev \
 &&  mkdir -p /build-squid-clamav/ \
 &&  ./configure --with-c-icap=/usr \
 &&  make \
 &&  make install \
 &&  apt-get remove -y build-essential \
 &&  apt autoremove -y
