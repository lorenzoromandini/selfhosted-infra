# Architecture

**Analysis Date:** 2026-02-26

## Pattern Overview

**Overall:** Documentation-First Infrastructure Repository

This is not a code repository—it's a documentation repository describing a self-hosted infrastructure deployment. The "architecture" exists as physical infrastructure (Raspberry Pi 4) and documented design decisions, not as software components.

**Key Characteristics:**
- Node-centric single-node architecture
- Private networking via Tailscale overlay network
- Containerized services using Docker Compose
- Secrets and configuration separated from documentation
- Reproducible, documented infrastructure design

## Layers

**Documentation Layer:**
- Purpose: Captures design decisions, security model, and operational procedures
- Location: `README.md`, `architecture/`, `services/`, `operations/`, `deployment/`
- Contains: Markdown documentation, diagrams, design rationale
- Depends on: None (documentation is source of truth)
- Used by: Human operators during infrastructure setup and maintenance

**Service Configuration Layer:**
- Purpose: Docker Compose definitions and environment templates
- Location: `docker/{service}/`
- Contains: `docker-compose.yml`, `.env.example` files
- Depends on: Docker runtime, images from Docker Hub
- Used by: Docker Compose to instantiate containers

**Storage Layer:**
- Purpose: Persistent data for services
- Location: `/srv/edge-lab/volumes/` (on the physical Raspberry Pi)
- Contains: SQLite databases, RSA keys, application data
- Depends on: Filesystem on Raspberry Pi
- Used by: Container volumes (bind-mounted)

**Runtime Layer:**
- Purpose: Container execution environment
- Location: Raspberry Pi 4 hardware
- Contains: Docker daemon, running containers
- Depends on: Ubuntu 24.04, Docker, Tailscale daemon
- Used by: Services (Vaultwarden, Pi-hole, Observability stack)

## Data Flow

**Client Access Flow:**

1. Client device connects via Tailscale client (WireGuard tunnel)
2. MagicDNS resolves `raspberry-pi-4.tail2ce491.ts.net` to Tailscale IP
3. Request traverses encrypted tailnet overlay network
4. Raspberry Pi receives request on service port (e.g., `8222` for Vaultwarden)
5. Docker forwards port to container
6. Service responds through same path

**Backup Flow:**

1. Operator executes backup procedure
2. Container stopped for data consistency
3. Data archived from `/srv/edge-lab/volumes/{service}/`
4. Compressed to `backup_YYYY-MM-DD_HHMMSS.tar.gz`
5. Container restarted
6. Archive stored per retention policy (14 days)

**Configuration Deployment Flow:**

1. Edit compose file or environment template
2. Copy to `/srv/edge-lab/docker/{service}/`
3. Populate `.env` from secure source (not this repo)
4. Run `docker-compose up -d`
5. Service starts with new configuration

## Key Abstractions

**Service Definition:**
- Purpose: Complete documentation of a single deployable service
- Examples: `services/vaultwarden.md`, `services/pihole.md`
- Pattern: Standardized sections (Purpose, Access Model, Deployment, Configuration, Operations)

**Security Boundary:**
- Purpose: Define trust and exposure levels
- Files: `architecture/security-model.md`
- Pattern: Threat model → Controls → Principles

**Storage Contract:**
- Purpose: Guarantee data persistence across container restarts
- Path: `/srv/edge-lab/volumes/{service}/`
- Pattern: Bind-mounted volume from host to container

## Entry Points

**Primary Documentation Entry:**
- Location: `README.md`
- Triggers: Initial repository exploration
- Responsibilities: System overview, repository map, security policy

**Architecture Entry:**
- Location: `architecture/overview.md`
- Triggers: Understanding system design
- Responsibilities: High-level design, networking model, storage layout

**Service-Specific Entry:**
- Location: `services/vaultwarden.md`
- Triggers: Operating a specific service
- Responsibilities: Access URL, persistence details, backup/restore procedures

**Operational Entry:**
- Location: `operations/backup-strategy.md`, `operations/restore-procedure.md`
- Triggers: Maintenance tasks
- Responsibilities: Step-by-step procedures

**Configuration Entry:**
- Location: `docker/vaultwarden/docker-compose.yml`
- Triggers: Service deployment
- Responsibilities: Container definition, port mappings, volume mounts

## Error Handling

**Strategy:** Documentation-driven operational procedures

**Patterns:**
- Procedures documented in `operations/` directory
- Service health endpoints documented per service (e.g., `/api/alive` for Vaultwarden)
- Backup/restore procedures for data recovery
- No automated error handling (operator-mediated)

## Cross-Cutting Concerns

**Logging:**
- Approach: Observability stack (Prometheus, Grafana, Loki, Promtail)
- Documentation: `services/observability.md` (planned)

**Validation:**
- Approach: Manual verification against documentation
- Pattern: Check `/api/alive` or equivalent health endpoints

**Authentication:**
- Approach: Layered - Tailscale for network, service-specific for application
- Pattern: SSH keys → Tailscale auth → Service credentials

---

*Architecture analysis: 2026-02-26*
