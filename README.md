# selfhosted-infra

Architectural and operational documentation for a private self-hosted stack running on a Raspberry Pi 4.

This repository is intentionally documentation-first: it captures system design, security boundaries, storage layout, and runbooks. It is not an install tutorial, and it does not include secrets or runtime data.

## Scope

Node:
- Raspberry Pi 4 (Ubuntu Server 24.04, aarch64)
- Docker / Docker Compose
- Filesystem layout rooted at `/srv/edge-lab`

Network model:
- Private access via Tailscale only
- No public exposure (no port forwarding, no public reverse proxy)

Core services:
- Vaultwarden (password manager / secret store)
- Pi-hole (DNS filtering)
- Observability stack (Prometheus, Grafana, Loki, Promtail)

Self-hosted applications (Docker containers):
- [Calcetto Manager](./projects/calcetto-app.md) - Football match organization (Docker)
- [NoTracePDF](./projects/notrace-pdf.md) - Privacy-focused PDF toolkit (Docker)

## System model

Clients connect through a private overlay network and reach services on the node using a stable MagicDNS hostname.

## High-level architecture

The system follows a node-centric design. All services run on a single Raspberry Pi and are reachable only through a private Tailscale network.

Clients
   |
Tailscale (private overlay network)
   |
Raspberry Pi node
 ├ Vaultwarden
 ├ Pi-hole
 ├ Observability stack
 └ Docker runtime

## Repository map

- `architecture/` — high-level design, networking, security model
- `services/` — per-service documentation (purpose, access model, persistence, operations)
- `deployment/` — directory layout and bootstrap notes
- `operations/` — backup/restore, SSH access, maintenance runbooks
- `docker/` — sanitized deployment examples (no secrets)

## Security and hygiene

This repository excludes by design:
- `.env` files, tokens, credentials
- TLS private keys and certificates
- persistent volumes and databases
- backup archives

Only templates (e.g., `.env.example`) and redacted configuration are committed.
