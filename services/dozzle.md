# Dozzle

Real-time web UI for viewing Docker container logs.

## Purpose

Dozzle provides a simple, lightweight web interface to view logs from all Docker containers in real-time. Unlike Grafana/Loki which requires queries and configuration, Dozzle auto-discovers containers and shows logs instantly.

## Features

- Auto-discovers all running containers
- Real-time log streaming (like `docker logs -f`)
- Search and filter logs by container
- Split view to compare logs from multiple containers
- No database or persistence required
- Lightweight (~10-20MB RAM)

## Access Model

- **Network**: Tailscale-only
- **Transport**: HTTP (TLS optional)
- **URL**: `http://raspberry-pi-4.tail2ce491.ts.net:8888`
- **No authentication**: Relies on Tailscale network security

## Deployment Model

- **Runtime**: Docker Compose
- **Compose location**: `/srv/edge-lab/docker/dozzle/docker-compose.yml`
- **Configuration**: Minimal - just needs Docker socket access
- **Persistent data**: None (stateless)

## Configuration

Docker Compose:
```yaml
services:
  dozzle:
    image: amir20/dozzle:latest
    container_name: dozzle
    restart: unless-stopped
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      - "8888:8080"
    environment:
      - DOZZLE_LEVEL=info
```

## Security Considerations

- Requires read access to Docker socket
- Exposes container logs - ensure Tailscale-only access
- No built-in authentication - network-level security only

## Operational Procedures

### Update

```bash
cd /srv/edge-lab/docker/dozzle
docker compose pull
docker compose up -d
```

### Troubleshooting

- **Can't see containers**: Check Docker socket permissions
- **No logs showing**: Verify container is running and producing output
- **Connection refused**: Ensure port is not in use

## Migration from Grafana/Loki

Dozzle replaces Grafana/Loki for log viewing with trade-offs:

| Feature | Grafana+Loki | Dozzle |
|---------|-------------|---------|
| Real-time logs | Yes | Yes |
| Historical logs | Days/weeks | None (live only) |
| Log queries | LogQL | Simple search/filter |
| Resource usage | ~300MB | ~20MB |
| Configuration | Complex | Minimal |

## Related

- [Uptime Kuma](./uptime-kuma.md) - Service uptime monitoring
- [Observability Migration](../operations/observability-migration.md) - Migration guide
