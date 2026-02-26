# Coding Conventions

**Analysis Date:** 2026-02-26

## Overview

This is a **documentation-first infrastructure repository** — it contains no application code. All "code" consists of Markdown documentation and YAML configuration files. Conventions focus on documentation structure, file organization, and configuration patterns.

---

## File Naming Patterns

**Markdown Documentation:**
- All lowercase with hyphens for word separation
- Pattern: `{topic}-{subtopic}.md`
- Examples: `design-decisions.md`, `backup-strategy.md`, `restore-procedure.md`

**Configuration Files:**
- Docker Compose: `docker-compose.yml`
- Environment templates: `.env.example`
- Never commit: `.env` (live configuration with secrets)

**Backup Archives:**
- Pattern: `backup_YYYY-MM-DD_HHMMSS.tar.gz`
- Example: `backup_2025-02-26_143022.tar.gz`

---

## Directory Naming

**All lowercase, singular descriptive names:**
- `architecture/` — not `architectures/` or `Architecture/`
- `services/`, `operations/`, `deployment/`, `diagrams/`

---

## Markdown Conventions

**Headings:**
- Use ATX style (`#`) not Setext style
- Document title: single `#`
- Major sections: `##`
- Subsections: `###`
- Use 2 newlines before headings (visible in rendered output)

**Lists:**
- Use `-` for unordered lists (not `*`)
- Use `1. 2. 3.` for ordered lists
- Indent nested lists with 2 spaces

**Links and References:**
- Prefer relative links: `architecture/security-model.md`
- Backticks around file paths: `` `docker/vaultwarden/docker-compose.yml` ``

**Escape Characters:**
- Some documents use backslash escapes for newlines: `\n` becomes actual newlines
- This appears to be an artifact of document generation, not intentional style

---

## YAML Conventions (Docker Compose)

**Docker Compose Version:**
```yaml
version: "3.8"
```

**Service Definition Pattern:**
```yaml
services:
  service-name:
    image: image:tag
    container_name: service-name
    restart: unless-stopped
    env_file:
      - .env
    ports:
      - "host:container"
    volumes:
      - /host/path:/container/path
```

**Indentation:**
- 2 spaces per indentation level
- Align list items with parent key

**String Quoting:**
- Quote port mappings: `"8222:80"`
- Unquoted strings for simple values where possible

---

## Environment File Conventions

**Format:**
```bash
# Section header (capitalized)
KEY=value

# Another section
ANOTHER_KEY=value
```

**Security Rules:**
- `.env.example` — committed, contains placeholder values
- `.env` — never committed, contains real secrets
- `ADMIN_TOKEN=CHANGE_ME` — clear placeholder pattern

**Key Naming:**
- UPPER_SNAKE_CASE for environment variables
- Examples: `WEBSOCKET_ENABLED`, `SIGNUPS_ALLOWED`, `ADMIN_TOKEN`

---

## Documentation Structure

**Required Sections (for service docs):**
1. `# Service Name` — H1 title
2. `## Purpose` — Why the service exists
3. `## Access Model` — How to reach it
4. `## Deployment Model` — How it's deployed
5. `## Configuration` — Key settings
6. `## Operational Procedures` — Backup, restore, troubleshooting

**Reference Template:**
- `services/vaultwarden.md` — most complete example
- Follow its structure for new service documentation

---

## Security Conventions

**Explicit Exclusions:**
- `.env` files
- TLS private keys and certificates
- Persistent volumes and databases
- Backup archives

**Sanitization:**
- Only `.env.example` files committed
- Redacted configuration only
- Never include real credentials, tokens, or hostnames in examples

---

## Path Conventions

**On-node Paths:**
- Root: `/srv/edge-lab/`
- Service configs: `/srv/edge-lab/docker/{service}/`
- Persistent data: `/srv/edge-lab/volumes/{service}/`

**In Documentation:**
- Always use backticks: `` `/srv/edge-lab/volumes/vaultwarden/data` ``
- Relative paths for repo-internal references

---

## Port Allocation Conventions

**Pattern:** High-numbered ports to avoid conflicts
- Vaultwarden: `8222` (HTTP), `3012` (WebSocket)
- Avoid standard ports (80, 443, 8080) for services

---

## Diagram Conventions

**ASCII Art in Markdown:**
- Use code blocks with no language specifier
- Simple box-and-line diagrams for network topology
- Indent with spaces for hierarchy

Example:
```
Clients
   |
Tailscale
   |
Raspberry Pi
```

---

## Commenting

**Code Comments:**
- YAML: `# Comment text` (minimal use)
- `.env.example`: Use section headers with `#`

**Documentation Comments:**
- No inline comments in Markdown
- Use callout sections like `## Notes` or `## Rationale`

---

## Version Control Conventions

**Commit Messages:**
- Not explicitly defined (no `.gitmessage` template found)
- Follow conventional commits pattern: `type(scope): description`

**Branch Strategy:**
- Single branch (main) based on repository structure
- No feature branches or release branches evident

---

## Error Handling Approach

Since this is a documentation repository, "error handling" manifests as:
- **Validation:** Manual review of documentation accuracy
- **Safety:** Explicit warnings about security (what NOT to commit)
- **Recovery:** Restore procedures documented in `operations/`

---

## Where to Apply Conventions

**Adding a new service:**
1. Create `services/{service}.md` following `services/vaultwarden.md` structure
2. Create `docker/{service}/docker-compose.yml` with standard service block
3. Create `docker/{service}/.env.example` with placeholder values
4. Update `architecture/overview.md` if adding to system architecture

**Modifying existing docs:**
- Maintain heading structure
- Keep file paths in backticks
- Preserve newline conventions (2 newlines before headings)

---

*Convention analysis: 2026-02-26*
