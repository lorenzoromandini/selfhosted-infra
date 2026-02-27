# Tailscale

Zero-config VPN for secure access to services.

## Purpose

Tailscale creates a secure mesh network (tailnet) between devices using WireGuard. It provides seamless, encrypted access to all services without exposing them to the public internet.

## Features

- Zero-config mesh VPN
- Automatic NAT traversal
- MagicDNS for host discovery
- ACLs for access control
- Device authorization required
- Cross-platform support
- MagicDNE for seamless name resolution

## Access Model

- **Network**: Tailscale tailnet only
- **Transport**: WireGuard tunnel
- **Authentication**: Tailscale login required
- **Device approval**: Manual authorization required

## Deployment Model

- **Runtime**: Native install (not Docker)
- **Install location**: System package
- **Configuration**: Tailscale CLI and web console

## Configuration

### Install on Raspberry Pi

```bash
# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh

# Authenticate
sudo tailscale up

# Enable IP forwarding (for subnet routing if needed)
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### Key Settings

- **Device name**: Set via `sudo tailscale set --hostname=<name>`
- **MagicDNS**: Enabled in admin console
- **Exit node**: Optional, for routing all traffic
- **Subnet routes**: Optional, for accessing LAN devices

## Operational Procedures

### Update

```bash
# Debian/Ubuntu/Raspbian
sudo apt update && sudo apt install tailscale

# Or use Tailscale's update command
sudo tailscale update
```

### Check Status

```bash
# Device status
sudo tailscale status

# Network connectivity
sudo tailscale ping <hostname>
```

### Troubleshooting

- **Cannot connect**: Check if device is approved in admin console
- **DNS not working**: Verify MagicDNS is enabled
- **Slow speeds**: Check if using DERP relay vs direct connection

## Security Considerations

- Devices must be approved before joining tailnet
- ACLs control which devices can communicate
- All traffic is encrypted with WireGuard
- No open ports required (NAT traversal)

## Related

- All services rely on Tailscale for secure access
- [Vaultwarden](./vaultwarden.md) - Uses Tailscale for TLS endpoint
- [Uptime Kuma](./uptime-kuma.md) - Monitors services via Tailscale addresses
