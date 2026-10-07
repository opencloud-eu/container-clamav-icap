#!/bin/sh

if [ -n "$FRESHCLAM_DATABASEMIRROR" ]; then
    sed -i '/^DatabaseMirror/d' /etc/clamav/freshclam.conf
    MIRRORS=$(echo $FRESHCLAM_DATABASEMIRROR | tr " " "\n")
    for MIRROR in $MIRRORS; do
        echo "DatabaseMirror ${MIRROR}" >> /etc/clamav/freshclam.conf
    done
fi

if [ -n "$FRESHCLAM_DISABLE" ] && [ $FRESHCLAM_DISABLE -eq 1 ]; then
    echo "INFO: freshclam is disabled"
else
    echo "INFO: Starting freshclam"
    freshclam -d -c 6 ${FRESHCLAM_ARGS}
fi

if [ -n "$C_ICAP_DISABLE" ] && [ $C_ICAP_DISABLE -eq 1 ]; then
    echo "INFO: c-icap is disabled"
    CLAMD_ARGS="${CLAMD_ARGS} --foreground"
fi

if [ -n "$CLAMD_DISABLE" ] && [ $CLAMD_DISABLE -eq 1 ]; then
    echo "INFO: clamd is disabled"
else
    echo "INFO: Starting clamd"
    clamd ${CLAMD_ARGS}
fi

if !([ -n "$C_ICAP_DISABLE" ] && [ $C_ICAP_DISABLE -eq 1 ]); then
    echo "INFO: Starting c-icap"
    c-icap -f /etc/c-icap/c-icap.conf -D -N ${C_ICAP_ARGS}
fi
