# Testing Patterns

**Analysis Date:** 2026-02-26

## Overview

This repository contains **no test framework** and **no test files**. As a documentation-first infrastructure repository, testing manifests through validation procedures rather than automated test suites.

---

## Testing Philosophy

**Documentation-First Testing:**
- Verification procedures are documented in Markdown
- Manual validation against documented steps
- Integration testing through operational procedures

**Testing Types for This Repository:**

| Type | Approach | Location |
|------|----------|----------|
| Unit | N/A — no application code | — |
| Integration | Manual verification procedures | `operations/` docs |
| E2E | Operational runbooks | `services/*.md` |
| Security | Manual review + documented checks | `architecture/security-model.md` |
| Compliance | Documentation review | All `.md` files |

---

## Test Framework

**Status: Not Applicable**

No test framework is configured. This is intentional for a documentation repository.

**If Added in Future:**

For validation of deployment configurations, consider:

```bash
# YAML validation (docker-compose syntax)
docker-compose -f docker-compose.yml config

# Markdown linting
npx markdownlint-cli "**/*.md"

# Spell checking
cspell "**/*.md"

# Link checking
lychee "**/*.md"
```

---

## Manual Testing Procedures

### Service Verification

Each service documents its verification procedure in `services/{service}.md`:

**Example from `services/vaultwarden.md`:**

```markdown
## Verification

Basic health endpoint:

`/api/alive`

Expected response:

`{"alive":true}`
```

### Backup/Restore Testing

**Location:** `operations/backup-strategy.md`, `operations/restore-procedure.md`

**Pattern:**
1. Follow documented backup procedure
2. Verify archive created at expected path
3. Test restore on isolated environment
4. Verify service functionality post-restore
5. Document any deviations

### Configuration Validation

**Pattern:**
1. Review `.env.example` against actual deployment
2. Verify all required variables documented
3. Check port allocations don't conflict
4. Validate path references exist on target node

---

## Test Data

**Not Applicable** — no test data needed for documentation.

**If Testing Docker Compose Files:**
```bash
# Validate compose syntax
docker-compose config

# Test service startup (dry-run concept)
docker-compose up --no-start
```

---

## Mocking

**Not Applicable** — no application code to mock.

**Infrastructure Mocking (if testing deployment):**
- Use Docker Compose profiles for test environments
- Separate test volumes from production volumes
- Mock external services (Tailscale) via documentation only

---

## Coverage

**Requirements:** None enforced

**Coverage Areas to Monitor:**
- All services documented in `services/`
- All operational procedures in `operations/`
- Complete backup/restore coverage
- Security model coverage

**Coverage Gaps:**
- `services/pihole.md` — empty (0 bytes)
- `services/tailscale.md` — empty (0 bytes)
- `services/observability.md` — empty (0 bytes)
- `operations/backup-strategy.md` — empty (0 bytes)
- `operations/ssh-access.md` — empty (0 bytes)
- `operations/restore-procedure.md` — empty (0 bytes)

---

## Common Testing Patterns

### Documentation Testing

**Pattern: Link Validation**
```bash
# Check all internal links are valid
grep -r "\[.*\](.*\.md)" . --include="*.md" | \
  sed 's/.*(\(.*\.md\)).*/\1/' | \
  while read f; do [ -f "$f" ] || echo "Broken: $f"; done
```

**Pattern: Path Verification**
```bash
# Verify all documented paths follow convention
grep -rn "/srv/edge-lab" . --include="*.md" | \
  grep -v "`/srv/edge-lab"  # Find unquoted paths
```

### Configuration Testing

**Pattern: Compose Validation**
```bash
# Test each compose file
cd docker/vaultwarden && docker-compose config > /dev/null
cd ../pihole && docker-compose config > /dev/null  # Will fail if empty
```

**Pattern: Environment Template Check**
```bash
# Verify .env.example exists where needed
for dir in docker/*/; do
  [ -f "$dir/.env.example" ] || echo "Missing: $dir.env.example"
done
```

---

## Integration Testing

**Manual Integration Tests:**

1. **Service Communication:**
   - Documented in service interdependencies
   - Verified through operational procedures
   - Example: Tailscale → Vaultwarden connectivity

2. **Backup/Restore Integration:**
   - Documented in `operations/`
   - Manual execution and verification
   - Cross-service data integrity checks

3. **Security Integration:**
   - Reviewed via `architecture/security-model.md`
   - Manual access control verification
   - TLS/encryption validation

---

## E2E Testing

**Not Automated** — use operational runbooks:

**End-to-End Scenario Example:**

```markdown
# E2E: Password Manager Workflow

1. Start Tailscale on client device
2. Connect to `raspberry-pi-4.tail2ce491.ts.net`
3. Open browser to `https://...:8222`
4. Log in to Vaultwarden
5. Create a test password entry
6. Verify sync across devices
7. Log out
```

This would be documented in `services/vaultwarden.md` under Operational Procedures.

---

## Test Organization

**If Adding Automated Tests:**

```
[project-root]/
├── tests/
│   ├── validate-links.sh      # Markdown link checker
│   ├── validate-compose.sh    # Docker compose syntax check
│   └── validate-paths.sh      # Path convention checker
├── Makefile                   # Test commands
└── .github/workflows/         # CI for validation
```

**Makefile Example:**
```makefile
test:
	./tests/validate-links.sh
	./tests/validate-compose.sh
	./tests/validate-paths.sh

lint:
	npx markdownlint-cli "**/*.md"

docs: test lint
```

---

## Quality Assurance

**Current QA:**
- Manual review of documentation
- Peer review of architectural decisions
- Security review before committing sensitive paths

**Recommended Additions:**
- Pre-commit hooks for markdown linting
- CI job for link validation
- Spell checking
- YAML validation for docker-compose files

---

*Testing analysis: 2026-02-26*
