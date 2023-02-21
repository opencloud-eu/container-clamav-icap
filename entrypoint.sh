#!/bin/bash

/usr/bin/freshclam && /usr/bin/c-icap -f /etc/c-icap/c-icap.conf -D -N
