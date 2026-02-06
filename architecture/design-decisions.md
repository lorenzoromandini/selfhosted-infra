\# Design Decisions



This document captures the reasoning behind key architectural choices.



\## Private networking via Tailscale



Decision:

Use Tailscale as the primary access layer instead of exposing services publicly.



Rationale:

\- eliminates need for port forwarding and public reverse proxy

\- reduces attack surface

\- consistent access across LAN and remote devices

\- built-in device identity model



Trade-offs:

\- requires Tailscale client on each device

\- dependency on overlay network availability



---



\## No public exposure



Decision:

All services are accessible only through the tailnet.



Rationale:

\- simplifies threat model

\- avoids external scanning and automated attacks

\- easier TLS management



Trade-offs:

\- services are not directly accessible without VPN



---



\## Self-hosted password manager (Vaultwarden)



Decision:

Use Vaultwarden as internal credential store.



Rationale:

\- central secret management

\- self-controlled data

\- lightweight resource usage suitable for Raspberry Pi



Trade-offs:

\- operational responsibility (backup, updates)



---



\## Single-node architecture



Decision:

Run services on a single Raspberry Pi node.



Rationale:

\- simplicity

\- low operational overhead

\- suitable for learning and experimentation



Trade-offs:

\- single point of failure

\- limited scalability



---



\## Documentation-first approach



Decision:

Maintain architectural documentation alongside configuration.



Rationale:

\- improves reproducibility

\- clarifies intent behind configuration choices

\- enables future refactoring without losing context



