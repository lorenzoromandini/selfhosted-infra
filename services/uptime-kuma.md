# Uptime Kuma

Self-hosted monitoring tool for service uptime and alerting.

## Purpose

Uptime Kuma monitors HTTP(S)/TCP services and sends alerts when they go down. It provides a simple dashboard showing the status of all monitored services with historical uptime statistics.

## Features

- HTTP/HTTPS/TCP/Ping/DNS monitoring
- Real-time status dashboard
- Alert notifications via:
  - Email (SMTP)
  - Telegram
  - Discord
  - Slack
  - Pushover
  - Webhooks
- Historical uptime statistics
- Response time graphs
- Lightweight (~100MB RAM typical)

## Access Model

- **Network**: Tailscale-only
- **Transport**: HTTP (TLS optional)
- **URL**: `http://raspberry-pi-4.tail2ce491.ts.net:3002`
- **Authentication**: Built-in (set up on first run)

## Deployment Model

- **Runtime**: Docker Compose
- **Compose location**: `/srv/edge-lab/docker/uptime-kuma/docker-compose.yml`
- **Persistent data**: `/srv/edge-lab/volumes/uptime-kuma`
- **Configuration**: Web UI for all settings

## Configuration

Docker Compose:
```yaml
services:
  uptime-kuma:
    image: louislam/uptime-kuma:latest
    container_name: uptime-kuma
    restart: unless-stopped
    volumes:
      - /srv/edge-lab/volumes/uptime-kuma:/app/data
    ports:
      - "3002:3001"
    environment:
      - TZ=Europe/Rome
```

## First Run Setup

1. Access `http://raspberry-pi-4.tail2ce491.ts.net:3002`
2. Create admin user
3. Add monitors for your services:
   - Vaultwarden: `https://raspberry-pi-4.tail2ce491.ts.net:8222`
   - NoTracePDF: `http://raspberry-pi-4.tail2ce491.ts.net:8000`
   - Dozzle: `http://raspberry-pi-4.tail2ce491.ts.net:8888`
   - Uptime Kuma: `http://localhost:3002`
   - ntfy: `http://raspberry-pi-4.tail2ce491.ts.net:8081`
   - Pi-hole: `http://<pihole-ip>:80` (or admin interface)
   - NetBox: `http://<netbox-url>`

## Monitoring Targets

### Services to Monitor

| Service | Type | Endpoint | Expected |
|---------|------|----------|----------|
| Vaultwarden | HTTPS | raspberry-pi-4.tail2ce491.ts.net:8222 | 200 OK |
| NoTracePDF | HTTP | raspberry-pi-4.tail2ce491.ts.net:8000 | 200 OK |
| Dozzle | HTTP | raspberry-pi-4.tail2ce491.ts.net:8888 | 200 OK |
| Uptime Kuma | HTTP | localhost:3002 | 200 OK (self-monitor) |
| ntfy | HTTP | raspberry-pi-4.tail2ce491.ts.net:8081 | 200 OK |
| Pi-hole | HTTP | <pihole-ip>:80 | 200 OK |
| NetBox | HTTP | <netbox-url> | 200 OK |

### System Health

- **Docker daemon**: TCP check on `/var/run/docker.sock` (if exposed)
- **Disk space**: Manual script or node-exporter (optional)
- **Memory usage**: Manual script (optional)

## Alert Configuration

### Recommended Alerts

- **Email via SMTP** (if you have SMTP server)
- **Telegram bot** (free, reliable)
- **Webhook** to another service

### Alert Rules

- Down for 60 seconds: Warning
- Down for 5 minutes: Alert
- Certificate expiry < 14 days: Warning

## Operational Procedures

### Backup

Data location: `/srv/edge-lab/volumes/uptime-kuma`

Backup:
```bash
sudo tar czf backup_uptime-kuma_$(date +%Y%m%d_%H%M%S).tar.gz \
  /srv/edge-lab/volumes/uptime-kuma/
```

### Restore

1. Stop container: `docker stop uptime-kuma`
2. Restore data: `sudo tar xzf backup_uptime-kuma_*.tar.gz`
3. Start container: `docker start uptime-kuma`

### Update

```bash
cd /srv/edge-lab/docker/uptime-kuma
docker compose pull
docker compose up -d
```

## Notes

- First user created becomes admin
- Can create multiple users with different access levels
- Supports 2FA for additional security
- Status page can be made public (if needed)

## Related

- [Dozzle](./dozzle.md) - Log viewing companion
- [Observability Migration](../operations/observability-migration.md) - Migration guide
