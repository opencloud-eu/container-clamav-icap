#!/bin/sh

echo "INFO: Starting freshclam"
freshclam -d -c 6

echo "INFO: Starting clamd"
clamd

echo "INFO: Starting c-icap"
c-icap -f /etc/c-icap/c-icap.conf -D -N
