# Technology Stack

**Analysis Date:** 2025-02-26

## Platform & Hardware

**Primary Node:**
- Raspberry Pi 4 (aarch64 architecture)
- Ubuntu Server 24.04 LTS
- ARM64 architecture

## Runtime Environment

**Container Runtime:**
- Docker (latest stable)
- Docker Compose (version 3.8 syntax)

**Network Infrastructure:**
- Tailscale (WireGuard-based mesh VPN)
- MagicDNS for stable hostnames
- Private tailnet overlay network

## Core Services

**Password Management:**
- Vaultwarden (unofficial Bitwarden Rust implementation)
  - Image: `vaultwarden/server:latest`
  - Storage: SQLite database
  - WebSocket support enabled

**DNS Filtering:**
- Pi-hole (planned, not yet configured)

**Observability Stack:**
- Prometheus (metrics collection)
- Grafana (visualization)
- Loki (log aggregation)
- Promtail (log shipping)

## Storage Architecture

**Filesystem Layout:**
- Root: `/srv/edge-lab/`
- Configurations: `/srv/edge-lab/docker/`
- Persistent data: `/srv/edge-lab/volumes/`
- Scripts: `/srv/edge-lab/scripts/`

**Storage Types:**
- SQLite for Vaultwarden (`db.sqlite3`)
- RSA keypairs for encryption
- Local filesystem for all persistent data

## Network Configuration

**Port Allocation:**
- Vaultwarden: `8222` (HTTP), `3012` (WebSocket)
- Pi-hole: TBD
- Observability: TBD

**Hostname:**
- MagicDNS: `raspberry-pi-4.tail2ce491.ts.net`

## Security Stack

**Transport Security:**
- TLS enabled for all services (self-signed certificates)
- WireGuard encryption (Tailscale)
- No public port exposure

**Authentication:**
- SSH key-based authentication (password login disabled)
- Vaultwarden master password model
- Admin token for Vaultwarden admin panel

## Backup Infrastructure

**Strategy:**
- Cold archive backups (container stopped for consistency)
- Retention: 14 days
- Format: Compressed tar archives (`backup_YYYY-MM-DD_HHMMSS.tar.gz`)

## Documentation Format

**Markup:**
- Markdown (`.md` files)
- Plain text documentation

**Version Control:**
- Git repository
- No secrets committed (excluded: `.env`, TLS keys, persistent volumes)

## Configuration Management

**Environment Configuration:**
- `.env` files per service (not committed)
- Docker Compose with env_file references
- Template/placeholder files for examples

**Deployment Pattern:**
- Docker Compose per service
- Service modularity (one compose file per service)
- Separation of config and runtime data

---

*Stack analysis: 2025-02-26*
