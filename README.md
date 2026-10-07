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
- The versioning follows the ClamAV version used in the base image

---

## 🔍 Service Details

The container exposes two ICAP services on port 1344:

- **`avscan`** - Main antivirus scanning service
- **`srv_clamav`** - Legacy service name (maintained for backward compatibility)

## 🚀 Usage

Once the container is running, you can access the ICAP services at:

- `icap://localhost:1344/avscan`
- `icap://localhost:1344/srv_clamav`

## ⚙️ Configuration Options

### Environment Variables

Following variables are available:
- **FRESHCLAM_DISABLE** - Disable Freshclam
- **FRESHCLAM_DATABASEMIRROR** - The mirrorserver for freshcalm to be used. Multible server are supported, they need to be sperated by space
- **FRESHCLAM_ARGS** - Args passed to Freshclam
- **CLAMD_DISABLE** - Disable Clamd
- **CLAMD_ARGS** - Args passed to Clamd
- **C_ICAP_DISABLE** - Disable c-icap
- **C_ICAP_ARGS** - Args passed to c-icap

### 🔌 Port Mapping
By default, the c-icap service runs on port 1344, the clamav is also available at port 3310. To use a different port:

```bash
docker run -d \
  --name clamav-icap \
  -p 8080:1344 \
  opencloudeu/clamav-icap
```

### 🛠 Build

```bash
docker build -t clamav-c-icap .
```

