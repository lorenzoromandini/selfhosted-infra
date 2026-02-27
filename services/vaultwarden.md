# Vaultwarden

Self-hosted password manager compatible with Bitwarden clients.

## Purpose

Vaultwarden is used as the self-hosted password manager and primary secret store for the lab. It is reachable only over the private Tailscale network and is not exposed publicly.

## Access Model

- Network: Tailscale-only (MagicDNS hostname)
- Transport security: TLS enabled
- Canonical URL (used by clients and server config):

```
https://raspberry-pi-4.tail2ce491.ts.net:8222
```

Rationale:
- a single stable endpoint is used across all clients
- avoids LAN IP drift and mixed-domain issues (websocket, redirects)

## Deployment Model

- Runtime: Docker Compose
- Compose location: `/srv/edge-lab/docker/vaultwarden`
- Persistent data: `/srv/edge-lab/volumes/vaultwarden/data`

Persisted components include:
- SQLite database (`db.sqlite3`)
- server keys (`rsa_key*`)
- attachments and icon cache

## Configuration

Key environment settings (conceptual):

- `DOMAIN` set to the canonical URL
- `ADMIN_TOKEN` set to a long random secret
- `SIGNUPS_ALLOWED=false` after initial bootstrap
- `WEBSOCKET_ENABLED=true`

Notes:
- `DOMAIN` should remain stable over time; changing it may require client relogin.
- Admin panel is available at `/admin` and protected by `ADMIN_TOKEN`.

## TLS Notes

TLS is required for Bitwarden clients and for browser WebCrypto to operate in a secure context.

Certificates are treated as internal-only since the service is not publicly exposed.

## Operational Procedures

### Backup

Authoritative data lives under:

```
/srv/edge-lab/volumes/vaultwarden/data
```

Backup is a cold archive (container is stopped for consistency), producing:

```
/srv/edge-lab/volumes/vaultwarden/backup_YYYY-MM-DD_HHMMSS.tar.gz
```

Retention is time-based (e.g., keep 14 days).

### Restore

Restore requires BOTH:
- the database (`db.sqlite3`)
- the RSA keys (`rsa_key*`)

If RSA keys are missing, clients will not be able to decrypt existing data.

High-level restore steps:
1. stop container
2. replace `data/` with the archived copy
3. start container
4. verify `/api/alive` and client sync

## Verification

Basic health endpoint:

```
/api/alive
```

Expected response:

```json
{"alive":true}
```

## Related

- [Uptime Kuma](./uptime-kuma.md) - Can monitor Vaultwarden availability
