# ntfy

Push notifications to your phone via simple HTTP requests.

## Purpose

ntfy allows you to send notifications to your phone or other devices from your scripts and services via simple HTTP POST requests. Perfect for monitoring, cron jobs, and automation alerts.

## Features

- Simple HTTP-based notifications
- No authentication required (uses Tailscale security)
- Topic-based subscriptions
- Mobile apps for iOS and Android
- Web-based message viewing
- File attachments support
- Lightweight (~20MB RAM)

## Access Model

- **Network**: Tailscale-only
- **Transport**: HTTP
- **URL**: `http://raspberry-pi-4.tail2ce491.ts.net:8081`
- **No authentication**: Relies on Tailscale network security

**Note**: HTTP access only. Browser notifications require HTTPS, but Tailscale's security model makes this acceptable for internal use.

## Deployment Model

- **Runtime**: Docker Compose
- **Compose location**: `/srv/edge-lab/docker/ntfy/docker-compose.yml`
- **Persistent data**: `/srv/edge-lab/volumes/ntfy`
- **Configuration**: Minimal - no login required

## Configuration

Docker Compose:
```yaml
services:
  ntfy:
    image: binwiederhier/ntfy:latest
    container_name: ntfy
    restart: unless-stopped
    command:
      - serve
    environment:
      - NTFY_BASE_URL=http://raspberry-pi-4.tail2ce491.ts.net:8081
      - NTFY_BEHIND_PROXY=false
      - NTFY_CACHE_FILE=/var/cache/ntfy/cache.db
      - NTFY_KEEPALIVE_INTERVAL=45s
      - NTFY_ATTACHMENT_CACHE_DIR=/var/cache/ntfy/attachments
      - NTFY_ENABLE_LOGIN=false
    volumes:
      - /srv/edge-lab/volumes/ntfy:/var/cache/ntfy
    ports:
      - "8081:80"
```

## Usage Examples

### Basic notification:
```bash
curl -d "Backup completed" raspberry-pi-4.tail2ce491.ts.net:8081/daily-report
```

### With title:
```bash
curl \
  -d "Server backup successful" \
  -H "Title: Backup Status" \
  raspberry-pi-4.tail2ce491.ts.net:8081/daily-report
```

### With priority:
```bash
curl \
  -d "Disk space low on server" \
  -H "Priority: urgent" \
  raspberry-pi-4.tail2ce491.ts.net:8081/system-alerts
```

## Mobile App Setup

1. Download ntfy app (iOS/Android)
2. Add server: `http://raspberry-pi-4.tail2ce491.ts.net:8081`
3. Subscribe to topics:
   - **system-alerts** - CPU, RAM, disk warnings
   - **docker-alerts** - Container problems and resource usage
   - **daily-report** - Backup completion and daily summaries
4. Test with: `curl -d "Hello" raspberry-pi-4.tail2ce491.ts.net:8081/system-alerts`

## Common Use Cases

- **Backup completion**: `curl -d "Backup finished" .../daily-report`
- **Service restarts**: Add to systemd service units
- **Cron job status**: Append to cron scripts
- **Uptime alerts**: Use with Uptime Kuma webhooks to system-alerts
- **System health**: Low disk, high CPU → system-alerts
- **Container issues**: High resource usage → docker-alerts

## Operational Procedures

### Update

```bash
cd /srv/edge-lab/docker/ntfy
docker compose pull
docker compose up -d
```

### Backup

```bash
sudo tar czf backup_ntfy_$(date +%Y%m%d_%H%M%S).tar.gz \
  /srv/edge-lab/volumes/ntfy/
```

## Security Considerations

- No authentication configured (Tailscale-only access)
- Anyone on Tailscale network can publish to any topic
- Messages are not encrypted at rest
- For production use, consider enabling authentication

## Related

- [Uptime Kuma](./uptime-kuma.md) - Can send webhook notifications to ntfy
- [Dozzle](./dozzle.md) - View logs of services sending notifications
- ntfy documentation: https://ntfy.sh
