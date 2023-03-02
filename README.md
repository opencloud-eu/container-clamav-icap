# Docker image of c-icap and clamav

This repository provides a Docker image containing a [c-icap](https://c-icap.sourceforge.net/)
server that uses [clamav](http://www.clamav.net/) for virus detection.  

Since c-icap seems to be the only Open Source implementation of the [ICAP](https://en.wikipedia.org/wiki/Internet_Content_Adaptation_Protocol)
a stable container image was required.

In the Kubernetes context scalability is a key feature. To prevent every clamav
to download and update its own virus database, the container image uses a
volume to mount that db. That way a separate container with a freshclam can take
care of the database and keep it uptodate.

The c-icap image is tagged __c-icap-clamav__ and is based on the official
__debian:bullseye-slim__ image.

## Configuration
All config files are locate in the folder __config__.

The _c-icap_ server is configured with the file c-icap.conf. In that config for
the virus detection engine is included:

```bash
Include virus_scan.conf
```

In that virus_scan module the file clamav_mod.conf is included:

```bash
Include clamav_mod.conf
```

There are two possibilities to use clamav via c-icap. One is as a library that
performs the scan directly, the other is to send the file to be scanned to a
clamav server, called __clamd__. This could be done via a socket, or via
host:tcp-port. Sending the file to another host could not be tested successfully
c-icap seems not very stable/ tested in that use case. That is the reason why
clamav is used directly inside the c-icap container and the module defined in
__virus_scan.conf__ is clamav and not clamd.

The config files are copied into the container during building.

## Building

The image can be built locally using the ```build```script, or by triggering the
gittlab-ci pipeline.

## Testing

If the image was built and is available locally it can be tested with:

```bash
./test-icap-clamav
```

This script starts a clamav container that downloads the clamav virus database
into a volume. As soon as this db is completely downloaded a __c-icap-clamav__
container is started which mounts the db and uses it for virus detection.

A _c-icap-client_ is installed in a third container that can be used to send
files to the c-icap-server for detection. Two files are then sent, one without a
virus and the second with the [eicar test file](https://www.eicar.org/download-anti-malware-testfile/).

