#!/bin/bash

# waiting until db is ready
while ! [ -e "/var/lib/clamav/main.cvd" ]
do
  sleep 2
  echo "waiting until clamav has downloaded its db ..."
done

/usr/bin/c-icap -f /etc/c-icap/c-icap.conf -D -N
