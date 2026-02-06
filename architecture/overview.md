\# Architecture Overview



\## Purpose



This repository documents a personal self-hosted infrastructure running on a Raspberry Pi 4.

The goal is to design and operate a secure, private, and modular environment focused on learning real-world infrastructure practices.



The system is intentionally designed as a private node, accessible only through a tailnet overlay network.



---



\## High-Level Design



The infrastructure follows a node-centric architecture:



Clients connect through a private network (Tailscale), which exposes services without requiring public internet exposure or traditional port forwarding.



\[ Clients ]

&nbsp;    |

&nbsp;  Tailscale

&nbsp;    |

\[Raspberry Pi Node]

&nbsp;├ Vaultwarden (password manager)

&nbsp;├ Pi-hole (DNS filtering)

&nbsp;├ Observability stack

&nbsp;└ Docker runtime



---



\## Core Principles



\- Private-by-default networking model

\- No direct public exposure

\- Service modularity through Docker Compose

\- Persistent data separation

\- Documentation-driven infrastructure



---



\## Networking Model



All services are reachable only through Tailscale.



MagicDNS hostname:



raspberry-pi-4.tail2ce491.ts.net



---



\## Storage Layout



Infrastructure data is organized under:



/srv/edge-lab/



Structure:



\- docker/ → compose configurations

\- volumes/ → persistent data



---



\## Security Model



\- Access restricted to Tailscale network

\- Self-signed TLS for internal encryption

\- SSH key-based authentication

\- No public ports exposed



---



\## Design Goals



\- reproducible infrastructure design

\- operational simplicity

\- incremental extensibility

\- clear architectural documentation

