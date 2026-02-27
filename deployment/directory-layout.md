\# Directory Layout



This document describes how infrastructure files are organized on the Raspberry Pi node.



\## Root path



All infrastructure-related files live under:



/srv/edge-lab/



This separation avoids mixing system files with operational data.



---



\## Structure



/srv/edge-lab/

├ docker/

│ ├ vaultwarden/

│ ├ pihole/

│ ├ dozzle/

│ ├ uptime-kuma/

│ ├ netbox/

│ ├ calcetto/

│ └ ingress/

├ volumes/

│ ├ vaultwarden/

│ ├ uptime-kuma/

│ ├ netbox/

│ ├ calcetto/

│ └ other-services/

└ scripts/





---



\## Design Principles



\### Separation of concerns



\- `docker/` contains deployment definitions (compose files, configs).

\- `volumes/` contains persistent runtime data.



This prevents accidental deletion of data when updating compose stacks.



\### Predictable paths



Using a fixed root directory simplifies:



\- backup procedures

\- documentation

\- automation scripts



\### Portability



The structure allows rebuilding services without losing data, since volumes remain independent from deployment configuration.



---



\## Operational Notes



\- Backups target the `volumes/` directory.

\- Configuration changes should occur in `docker/`, not inside containers.

\- Runtime data should never be committed to version control.



