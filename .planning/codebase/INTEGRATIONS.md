# External Integrations

**Analysis Date:** 2025-02-26

## Network Infrastructure

**Tailscale (Primary Access Layer):**
- Purpose: Private mesh VPN and overlay network
- Technology: WireGuard-based encrypted tunnels
- Features: MagicDNS for stable hostnames
- Hostname: `raspberry-pi-4.tail2ce491.ts.net`
- Access: Requires Tailscale client on all devices

## Core Services

**Vaultwarden (Password Manager):**
- Image Source: Docker Hub (`vaultwarden/server:latest`)
- Client Compatibility: Bitwarden clients (browser extensions, mobile apps, CLI)
- API: Bitwarden-compatible REST API
- WebSocket: Enabled for real-time sync (`/notifications/hub`)
- Health Endpoint: `/api/alive` (returns `{"alive":true}`)

**Pi-hole (DNS Filtering):**
- Status: Planned/placeholder (no configuration yet)
- Purpose: Network-wide ad blocking and DNS filtering

**Observability Stack:**
- **Prometheus**: Metrics collection
- **Grafana**: Dashboards and visualization
- **Loki**: Log aggregation
- **Promtail**: Log shipping agent
- Status: Planned/placeholder (no configuration yet)

## Data Storage

**Primary Database:**
- Type: SQLite (file-based)
- Used by: Vaultwarden
- Location: `/srv/edge-lab/volumes/vaultwarden/data/db.sqlite3`

**File Storage:**
- Type: Local filesystem only
- Attachments: Stored in Vaultwarden data directory
- Icons: Cached in Vaultwarden data directory

**Encryption:**
- RSA keypairs for Vaultwarden data encryption
- Location: `/srv/edge-lab/volumes/vaultwarden/data/rsa_key*`

## Authentication & Identity

**Device Identity:**
- Provider: Tailscale
- Model: Device-based authentication via tailnet
- SSH Access: Key-based authentication only

**Application Authentication:**
- Vaultwarden: Master password model with optional 2FA
- Vaultwarden Admin: Dedicated `ADMIN_TOKEN` (long random secret)

## Certificate Management

**TLS:**
- Type: Self-signed certificates
- Purpose: Internal encryption and secure context for browser WebCrypto
- Scope: Internal-only, not publicly trusted
- Required for: Bitwarden clients and WebSocket secure context

## Monitoring & Health Checks

**Vaultwarden:**
- Health endpoint: `/api/alive`
- Expected response: JSON with `alive: true`

**Planned Observability:**
- Prometheus metrics scraping
- Grafana dashboards
- Loki log aggregation
- Promtail log shipping

## Backup & Data Protection

**Backup Target:**
- Method: Cold archive (service stopped during backup)
- Location: `/srv/edge-lab/volumes/vaultwarden/`
- Format: `backup_YYYY-MM-DD_HHMMSS.tar.gz`
- Retention: 14 days
- Critical data: Database + RSA keys (both required for restore)

## Outbound Dependencies

**Docker Hub:**
- Required for: Vaultwarden image pulls
- Image: `vaultwarden/server:latest`
- Network: Requires outbound internet access

**Tailscale Control Plane:**
- Required for: Network coordination and key exchange
- Network: Requires outbound access to Tailscale servers

## Environment Configuration

**Required Secrets (not committed):**
- `ADMIN_TOKEN`: Vaultwarden admin panel access
- `DOMAIN`: Canonical URL (`https://raspberry-pi-4.tail2ce491.ts.net:8222`)
- Database encryption keys (auto-generated RSA keypairs)

**Configuration Files (templates only):**
- `docker/vaultwarden/docker-compose.yml`: Service definition
- `.env.example`: Environment variable template (not present but referenced)

## Webhooks & Callbacks

**Incoming:**
- None (private network, no public endpoints)

**Outgoing:**
- None currently configured

## Integration Summary

| Service | External Dependency | Purpose |
|---------|---------------------|---------|
| Tailscale | Tailscale control plane | Network mesh coordination |
| Vaultwarden | Docker Hub | Image distribution |
| Vaultwarden | Bitwarden clients | Client applications |

---

*Integration audit: 2025-02-26*
