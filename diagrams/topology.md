# Topology

High-level network and service topology.

[ Client devices ]
|
| (WireGuard / Tailscale)
|
[Tailscale tailnet overlay]
|
v
+---------------------------+
| Raspberry Pi 4 (Node) |
| Ubuntu 24.04 |
| |
| Docker runtime |
| ├ Vaultwarden |
| ├ Pi-hole |
| └ Observability stack |
+---------------------------+


## Notes

- All services are reachable only via Tailscale.
- No public ports exposed.
- MagicDNS hostname used as canonical endpoint:
  raspberry-pi-4.tail2ce491.ts.net
