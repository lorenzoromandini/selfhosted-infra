\# Security Model



This document describes the security assumptions and controls applied to the self-hosted infrastructure.



\## Threat Model



Primary assumptions:



\- Services are NOT exposed to the public internet.

\- Access is restricted to authenticated devices through Tailscale.

\- The Raspberry Pi operates as a private node within a trusted tailnet.



Main risks considered:



\- unauthorized remote access

\- credential compromise

\- data loss due to operational mistakes



---



\## Network Security



Decision:

Use Tailscale as the only access layer.



Properties:



\- WireGuard-based encrypted tunnel

\- device identity enforced by tailnet authentication

\- no inbound ports exposed publicly



Benefits:



\- reduced attack surface

\- no need for reverse proxy or firewall rules exposed externally

\- consistent access across networks



---



\## Transport Security



TLS is enabled for internal services.



Purpose:



\- satisfy client requirements (e.g. Bitwarden secure context)

\- protect traffic inside overlay network

\- avoid accidental plaintext exposure



Certificates are internal-only and not intended for public trust.



---



\## Authentication



SSH:



\- key-based authentication preferred

\- password login disabled (where possible)



Application access:



\- Vaultwarden protected by master password model

\- Admin panel protected via dedicated token



---



\## Data Protection



Persistent data is stored under:



/srv/edge-lab/volumes/



Controls:



\- separation between configuration and runtime data

\- regular backups

\- restore procedure documented



---



\## Operational Security Principles



\- least exposure (private networking only)

\- minimal service surface

\- clear separation between secrets and documentation

\- no sensitive data committed to repository

