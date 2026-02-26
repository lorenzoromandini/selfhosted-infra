# Observability Stack Migration

Replace Grafana/Prometheus/Loki/Promtail with Dozzle + Uptime Kuma.

## Overview

This migration removes the resource-heavy observability stack (~300-400MB RAM) and replaces it with lightweight alternatives:

- **Dozzle**: Real-time log viewing (~20MB RAM)
- **Uptime Kuma**: Service monitoring and alerts (~100MB RAM)

**Total savings**: ~200-280MB RAM

## Pre-Migration Checklist

- [ ] Document current dashboards in Grafana (if any)
- [ ] Export any custom Prometheus rules
- [ ] Note any active alerts
- [ ] Verify Uptime Kuma and Dozzle are configured
- [ ] Inform any users of the change

## Migration Steps

### 1. Deploy New Services

Deploy Dozzle and Uptime Kuma first (see their service docs):

```bash
# Create directories
mkdir -p /srv/edge-lab/docker/dozzle
mkdir -p /srv/edge-lab/docker/uptime-kuma
mkdir -p /srv/edge-lab/volumes/uptime-kuma

# Deploy (using docker-compose files from service docs)
```

### 2. Configure Uptime Kuma

1. Access Uptime Kuma web UI
2. Create admin account
3. Add monitors for all services:
   - Vaultwarden (HTTPS)
   - NoTracePDF (HTTP)
   - Dozzle (HTTP)
   - Pi-hole (HTTP)
   - Forgejo (HTTP)
   - NetBox (HTTP)
   - Any other services
4. Configure notifications (Telegram/Email/Webhook)
5. Test alerts

### 3. Stop Old Observability Stack

```bash
cd /srv/edge-lab/docker/observability
docker compose down
```

### 4. Verify Services Still Running

```bash
docker ps
# Should see all services except: prometheus, grafana, obs-loki, obs-promtail, node-exporter
```

### 5. Test Dozzle

1. Access Dozzle web UI
2. Verify all containers appear in list
3. Click on a container and view logs
4. Test search/filter functionality

### 6. Remove Old Stack (Optional)

**Wait 1-2 weeks to ensure new setup is working before removing.**

```bash
# Backup data first (optional)
cp -r /srv/edge-lab/volumes/prometheus /backup/
cp -r /srv/edge-lab/volumes/grafana /backup/
cp -r /srv/edge-lab/volumes/loki-data /backup/

# Remove containers and volumes
cd /srv/edge-lab/docker/observability
docker compose down -v

# Remove directories (be careful!)
sudo rm -rf /srv/edge-lab/volumes/prometheus
sudo rm -rf /srv/edge-lab/volumes/grafana
# Note: loki-data is a named volume

# Remove Docker images
docker rmi prom/prometheus:v2.53.1
docker rmi grafana/grafana:11.1.4
docker rmi grafana/loki:2.9.0
docker rmi grafana/promtail:2.9.0
docker rmi prom/node-exporter:v1.8.1

# Remove config directories (backup first if needed)
sudo rm -rf /srv/edge-lab/configs/prometheus
sudo rm -rf /srv/edge-lab/configs/grafana
sudo rm -rf /srv/edge-lab/docker/observability/configs
```

## Post-Migration

### What's Different

| Before (Grafana/Prometheus/Loki) | After (Dozzle/Uptime Kuma) |
|-----------------------------------|----------------------------|
| Historical metrics (CPU, RAM, disk over time) | No metrics history |
| Log queries with LogQL | Simple log search/filter |
| Days/weeks of log retention | Live logs only |
| Complex dashboards | Simple status page |
| ~300-400MB RAM usage | ~120MB RAM usage |

### What You Lose

- **Historical data**: Can't see "CPU was high yesterday at 3pm"
- **Log persistence**: Logs only exist while containers run
- **Custom dashboards**: No Grafana-style visualizations
- **PromQL queries**: No complex metric queries

### What You Gain

- **Simplicity**: No configuration files to manage
- **Resource savings**: ~200-280MB RAM freed
- **Speed**: Instant access to logs, no query language
- **Lower maintenance**: Fewer moving parts

## Rollback Plan

If you need to revert:

```bash
# Stop new services
docker stop dozzle uptime-kuma

# Start old observability stack
cd /srv/edge-lab/docker/observability
docker compose up -d
```

## Verification

Check resource usage:

```bash
# Before migration
docker stats --no-stream prometheus grafana obs-loki obs-promtail node-exporter

# After migration
docker stats --no-stream dozzle uptime-kuma

# Total system memory
free -h
```

## Related

- [Dozzle](../services/dozzle.md)
- [Uptime Kuma](../services/uptime-kuma.md)
- [Backup Strategy](./backup-strategy.md)
