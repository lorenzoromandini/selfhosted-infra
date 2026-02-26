# Projects

Self-hosted applications running on this node.

## Overview

This directory documents applications developed by the owner that are deployed and hosted on this Raspberry Pi, alongside the infrastructure services.

## Self-Hosted Applications

| Project | Repository | Description | Status |
|---------|-----------|-------------|--------|
| [Calcetto Manager](./calcetto-app.md) | [GitHub](https://github.com/lorenzoromandini/CalcettoApp) | Football match organization web app | In Development |
| [NoTracePDF](./notrace-pdf.md) | [GitHub](https://github.com/lorenzoromandini/NoTracePDF) | Self-hosted ephemeral PDF toolkit | Active |

## Access

All projects are reachable via Tailscale:

- **Calcetto Manager**: `https://raspberry-pi-4.tail2ce491.ts.net:3000` (example)
- **NoTracePDF**: `https://raspberry-pi-4.tail2ce491.ts.net:8000` (example)

## Directory Layout

```
projects/
├── README.md              # This file - projects index
├── calcetto-app.md        # Calcetto Manager documentation
└── notrace-pdf.md         # NoTracePDF documentation
```

## Local Paths

Source code:
- `/home/ubuntu/projects/CalcettoApp/`
- `/home/ubuntu/projects/NoTracePDF/`

Deployment configs:
- `/srv/edge-lab/docker/calcetto-app/` (when deployed)
- `/srv/edge-lab/docker/notrace-pdf/` (when deployed)

## Related

- [Infrastructure Services](../services/) - Core services (Vaultwarden, Pi-hole, etc.)
- [Architecture](../architecture/overview.md) - System design and network model
- [Docker](../docker/) - Deployment configurations
