# Codebase Concerns

**Analysis Date:** 2026-02-26

## Tech Debt

**Incomplete Documentation:**
- Issue: Multiple service documentation files are empty placeholders
- Files:
  - `services/pihole.md`
  - `services/tailscale.md`
  - `services/observability.md`
  - `operations/backup-strategy.md`
  - `operations/restore-procedure.md`
  - `operations/ssh-access.md`
  - `deployment/bootstrap.md`
  - `architecture/networking.md`
- Impact: Critical operational knowledge exists only in README or not documented at all
- Fix approach: Populate these files with actual operational procedures

**Hardcoded Configuration:**
- Issue: Tailscale MagicDNS hostname hardcoded in multiple locations
- Files:
  - `docker/vaultwarden/.env.example` (line 2)
  - `services/vaultwarden.md` (line 27)
  - `diagrams/topology.md` (line 28)
  - `architecture/overview.md` (line 91)
- Impact: Changing hostname requires manual updates across multiple files; risk of configuration drift
- Fix approach: Create a single configuration source or document hostname change procedure

**Unpinned Docker Image:**
- Issue: `vaultwarden/server:latest` used without version pinning
- File: `docker/vaultwarden/docker-compose.yml` (line 5)
- Impact: Updates may introduce breaking changes unexpectedly; non-reproducible deployments
- Fix approach: Pin to specific version (e.g., `1.30.5`) and document upgrade process

## Known Issues

**Empty Port Binding:**
- Issue: Docker Compose port bindings expose on all interfaces by default
- File: `docker/vaultwarden/docker-compose.yml` (lines 13-14)
- Current: `"8222:80"` and `"3012:3012"` bind to 0.0.0.0
- Risk: If UFW/firewall rules fail or are bypassed, services could be exposed
- Fix approach: Explicitly bind to localhost or Tailscale interface: `"127.0.0.1:8222:80"`

**Missing Health Checks:**
- Issue: No Docker health checks defined in compose file
- File: `docker/vaultwarden/docker-compose.yml`
- Impact: Docker cannot detect unhealthy containers automatically
- Fix approach: Add `healthcheck` section using `/api/alive` endpoint

**No Automated Backup:**
- Issue: Backup procedure exists in documentation but no automation implemented
- Files: `services/vaultwarden.md` (lines 100-122)
- Impact: Relies on manual execution; risk of missed backups
- Fix approach: Implement cron job or systemd timer with scripts

## Security Considerations

**Admin Token Placeholder:**
- Issue: `.env.example` contains placeholder that may be copy-pasted without change
- File: `docker/vaultwarden/.env.example` (line 5)
- Current: `ADMIN_TOKEN=CHANGE_ME`
- Risk: If deployed without change, admin panel is accessible with trivial password
- Current mitigation: Documented as "generate your own"
- Recommendations: Add validation script or stronger warning in documentation

**No Network Segmentation:**
- Issue: All services run in default Docker bridge network
- File: `docker/vaultwarden/docker-compose.yml`
- Impact: Container-to-container communication not restricted; lateral movement possible if one container compromised
- Recommendations: Define custom networks with explicit access controls

**Self-Signed TLS:**
- Issue: TLS certificates are self-signed (internal-only)
- Files: `architecture/security-model.md` (lines 79-99)
- Current mitigation: Service not publicly exposed
- Risk: Certificate validation warnings may train users to ignore security warnings
- Recommendations: Document certificate trust installation for clients

## Performance Bottlenecks

**Single Node Architecture:**
- Problem: All services on single Raspberry Pi 4
- File: `architecture/design-decisions.md` (lines 103-128)
- Cause: Documented as intentional trade-off for simplicity
- Limitation: 4GB RAM constraint, limited CPU (ARM64), SD card I/O for storage
- Improvement path: Document resource monitoring; plan for external USB SSD

**SQLite for Vaultwarden:**
- Problem: Database uses SQLite on local filesystem
- Files: `services/vaultwarden.md` (line 53)
- Cause: Simplicity and single-node design
- Limitation: Concurrent write limitations; no horizontal scaling
- Improvement path: Accept limitation for personal use; document backup frequency

**Cold Archive Backups:**
- Problem: Backup requires stopping container
- File: `services/vaultwarden.md` (lines 113-118)
- Cause: SQLite consistency requirements
- Impact: Service downtime during backup window
- Improvement path: Accept for personal use; implement live backup with SQLite backup mode if needed

## Fragile Areas

**RSA Key Dependency:**
- Issue: Vaultwarden encryption tied to RSA keys
- File: `services/vaultwarden.md` (lines 129-138)
- Why fragile: Keys must be backed up WITH database; losing keys makes data unrecoverable
- Safe modification: Always backup both `db.sqlite3` and `rsa_key*` together
- Test coverage: No automated test for restore procedure

**MagicDNS Hostname Stability:**
- Issue: All client configurations depend on single MagicDNS hostname
- Files: Multiple references to `raspberry-pi-4.tail2ce491.ts.net`
- Why fragile: Tailscale reconfiguration or tailnet changes break all clients
- Safe modification: Document hostname change procedure; consider custom domain
- Risk: Domain changes require reconfiguring all Bitwarden clients

**Manual Bootstrap Process:**
- Issue: No automated deployment or bootstrap scripts
- File: `deployment/bootstrap.md` (empty)
- Why fragile: Manual steps prone to error; environment setup not reproducible
- Safe modification: Create Ansible playbook or bash scripts
- Risk: New node setup requires recalling undocumented steps

## Scaling Limits

**Current Capacity:**
- Resource: Raspberry Pi 4 (4GB RAM typical)
- Current capacity: ~3-4 containerized services (estimated)
- Limit: Memory and CPU bound
- Scaling path: Document resource limits; plan migration to larger hardware if needed

**Storage:**
- Resource: SD card or external SSD
- Current capacity: Dependent on media size
- Limit: SD cards have limited write endurance
- Scaling path: Document migration to external SSD; implement storage monitoring

## Dependencies at Risk

**Tailscale Dependency:**
- Risk: Single vendor for all network access
- Impact: If Tailscale service unavailable, no remote access to infrastructure
- Migration plan: Document fallback VPN (WireGuard manual) or local network access

**Vaultwarden Unofficial:**
- Risk: Unofficial Bitwarden implementation
- Impact: Security updates dependent on community maintainers
- Migration plan: Monitor upstream; document official Bitwarden migration path if needed

**Docker Latest Tag:**
- Risk: Uncontrolled updates
- Impact: Breaking changes on image pull
- Migration plan: Pin versions; test updates in staging (document staging procedure)

## Missing Critical Features

**Monitoring and Alerting:**
- Feature gap: No documented alerting on backup failures, disk full, or service down
- Impact: Problems discovered manually
- Blocks: Proactive maintenance

**SSL Certificate Management:**
- Feature gap: No automated certificate renewal documented
- Impact: Certificate expiry breaks clients
- Blocks: Long-term unattended operation

**Log Rotation:**
- Feature gap: No documented log rotation for Docker containers
- Impact: Disk fill-up over time
- Blocks: Long-term stability

## Test Coverage Gaps

**No Automated Tests:**
- What's not tested: All operational procedures
- Files: Entire repository has no test suite
- Risk: Documentation errors, procedure failures
- Priority: Low (documentation repo) but operational scripts should be tested

**No Restore Validation:**
- What's not tested: Backup/restore procedures
- Files: `services/vaultwarden.md` restore procedure
- Risk: Backup may not be restorable when needed
- Priority: High - critical for disaster recovery

---

*Concerns audit: 2026-02-26*
