# Pi-hole

Network-wide ad blocking and DNS sinkhole.

## Purpose

Pi-hole blocks ads and trackers at the DNS level, preventing unwanted content from loading on any device connected to the network. It acts as a local DNS server with filtering capabilities.

## Features

- DNS-level ad blocking
- Block lists for ads, trackers, and malware
- Custom allow/deny lists
- Dashboard with statistics
- Query logging
- Lightweight (~100MB RAM typical)

## Access Model

- **Network**: Tailscale-only
- **Transport**: HTTP
- **URL**: `http://<pihole-ip>:80/admin`
- **Authentication**: Web admin password

## Deployment Model

- **Runtime**: Docker Compose
- **Compose location**: `/srv/edge-lab/docker/pihole/docker-compose.yml`
- **Persistent data**: `/srv/edge-lab/volumes/pihole`
- **Configuration**: Environment variables and web UI

## Configuration

Docker Compose:
```yaml
services:
  pihole:
    image: pihole/pihole:latest
    container_name: pihole
    restart: unless-stopped
    environment:
      - TZ=Europe/Rome
      - WEBPASSWORD=<admin-password>
    volumes:
      - /srv/edge-lab/volumes/pihole/etc-pihole:/etc/pihole
      - /srv/edge-lab/volumes/pihole/etc-dnsmasq.d:/etc/dnsmasq.d
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "80:80/tcp"
```

## Operational Procedures

### Update

```bash
cd /srv/edge-lab/docker/pihole
docker compose pull
docker compose up -d
```

### Backup

```bash
sudo tar czf backup_pihole_$(date +%Y%m%d_%H%M%S).tar.gz \
  /srv/edge-lab/volumes/pihole/
```

### Restore

1. Stop container: `docker stop pihole`
2. Restore data: `sudo tar xzf backup_pihole_*.tar.gz`
3. Start container: `docker start pihole`

## Related

- [Uptime Kuma](./uptime-kuma.md) - Can monitor Pi-hole availability
