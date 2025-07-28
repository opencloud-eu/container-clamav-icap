# ClamAV + c-icap Docker Container

This container provides a lightweight Debian-based image that runs [ClamAV](https://www.clamav.net/) integrated with [c-icap](http://c-icap.sourceforge.net/) for virus scanning over ICAP. It's suitable for use with proxies (like Squid) that support ICAP for content filtering.

## 🧰 Features

- Based on `debian:bookworm-slim`
- Installs:
    - `clamav`
    - `clamav-daemon`
    - `c-icap`
    - `libicapapi-dev`
    - `libc-icap-mod-virus-scan`
- Fresh virus definitions via `freshclam` at build time
- Handles headless install issues (debconf, service start)
- Proper permissions for ClamAV and c-icap runtime
- Simple `entrypoint.sh` for container initialization

---

## 🚀 Usage

### 🛠 Build

```bash
docker build -t clamav-c-icap .

