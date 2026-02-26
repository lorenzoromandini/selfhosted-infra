# Codebase Structure

**Analysis Date:** 2026-02-26

## Directory Layout

```
[project-root]/
├── architecture/          # High-level design documents
│   ├── design-decisions.md
│   ├── networking.md
│   ├── overview.md
│   └── security-model.md
├── deployment/            # Deployment and bootstrap docs
│   ├── bootstrap.md
│   └── directory-layout.md
├── diagrams/              # Architecture diagrams
│   └── topology.md
├── docker/                # Service deployment configs
│   └── vaultwarden/
│       ├── .env.example
│       ├── docker-compose.yml
│       └── README.md
├── operations/            # Operational runbooks
│   ├── backup-strategy.md
│   ├── restore-procedure.md
│   └── ssh-access.md
├── services/              # Per-service documentation
│   ├── observability.md
│   ├── pihole.md
│   ├── tailscale.md
│   └── vaultwarden.md
└── README.md              # Entry point documentation
```

## Directory Purposes

**`architecture/`:**
- Purpose: System design, security model, networking, design rationale
- Contains: Markdown documentation files
- Key files: `architecture/overview.md`, `architecture/security-model.md`

**`deployment/`:**
- Purpose: Filesystem layout, bootstrap procedures, installation guides
- Contains: Markdown documentation files
- Key files: `deployment/directory-layout.md`

**`diagrams/`:**
- Purpose: Visual representations of network topology and architecture
- Contains: Text-based diagrams (ASCII art in markdown)
- Key files: `diagrams/topology.md`

**`docker/`:**
- Purpose: Docker Compose configurations and environment templates
- Contains: Subdirectories per service with compose files
- Key files: `docker/vaultwarden/docker-compose.yml`, `docker/vaultwarden/.env.example`

**`operations/`:**
- Purpose: Day-to-day operational procedures and runbooks
- Contains: Markdown documentation for maintenance tasks
- Key files: `operations/backup-strategy.md`, `operations/restore-procedure.md`

**`services/`:**
- Purpose: Per-service documentation covering purpose, access, configuration, and operations
- Contains: Markdown documentation files per service
- Key files: `services/vaultwarden.md` (most complete example)

**`.planning/codebase/`:**
- Purpose: Generated codebase analysis for GSD tooling
- Contains: Auto-generated documentation (STACK.md, ARCHITECTURE.md, STRUCTURE.md, etc.)

## Key File Locations

**Entry Points:**
- `README.md`: Main repository overview and navigation
- `architecture/overview.md`: System architecture documentation

**Configuration:**
- `docker/vaultwarden/docker-compose.yml`: Vaultwarden service definition
- `docker/vaultwarden/.env.example`: Environment variable template

**Core Documentation:**
- `architecture/design-decisions.md`: Architectural decision records (ADRs)
- `architecture/security-model.md`: Threat model and security controls
- `deployment/directory-layout.md`: Filesystem structure on target node
- `services/vaultwarden.md`: Complete service documentation example

**Diagrams:**
- `diagrams/topology.md`: Network and service topology diagram

## Naming Conventions

**Files:**
- All lowercase with hyphens for multi-word names
- Extensions: `.md` for documentation, `.yml` for Docker Compose
- Examples: `design-decisions.md`, `docker-compose.yml`, `.env.example`

**Directories:**
- All lowercase, descriptive names
- Examples: `architecture/`, `services/`, `operations/`

**Service Subdirectories:**
- Service name as directory under `docker/`
- Examples: `docker/vaultwarden/`

**Backup Archives:**
- Pattern: `backup_YYYY-MM-DD_HHMMSS.tar.gz`
- Example: `backup_2025-02-26_143022.tar.gz`

## Where to Add New Code

**New Service Documentation:**
- Primary documentation: `services/{service-name}.md`
- Use `services/vaultwarden.md` as reference template

**New Service Configuration:**
- Docker Compose: `docker/{service-name}/docker-compose.yml`
- Environment template: `docker/{service-name}/.env.example`
- Service-specific README: `docker/{service-name}/README.md`

**New Architecture Documentation:**
- Design decisions: `architecture/design-decisions.md` (append new decisions)
- New security docs: `architecture/`
- Network docs: `architecture/networking.md`

**New Operational Procedures:**
- Location: `operations/{procedure-name}.md`
- Reference existing structure in `operations/backup-strategy.md`

**New Diagrams:**
- Location: `diagrams/{diagram-name}.md`
- Format: ASCII art in markdown code blocks

## Special Directories

**`.planning/codebase/`:**
- Purpose: GSD tooling workspace for codebase analysis
- Generated: Yes (by GSD commands)
- Committed: Optional (excluded from normal workflow)
- Contains: `STACK.md`, `ARCHITECTURE.md`, `STRUCTURE.md`, `CONCERNS.md`

**`docker/`:**
- Purpose: Service deployment configurations (sanitized)
- Generated: No (manually maintained)
- Committed: Yes (without secrets)
- Contains: Only `.env.example` files, never `.env` files with real values

**`operations/`:**
- Purpose: Operational runbooks and procedures
- Generated: No (manually maintained)
- Committed: Yes
- Contains: Step-by-step procedures for backup, restore, SSH access

---

*Structure analysis: 2026-02-26*
