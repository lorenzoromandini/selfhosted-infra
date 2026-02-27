# System Monitoring

Push notifications for system health and Docker container status using ntfy.

## Overview

Monitoring scripts run via cron and send alerts to your phone via ntfy when:
- System resources (CPU, RAM, disk) exceed thresholds
- Docker containers become unhealthy or stop
- Container resource usage is high

## Scripts Location

All scripts are in `/home/ubuntu/scripts/monitoring/`

## Configuration

### Scripts

**`ntfy.sh`** - Helper script to send notifications
```bash
./ntfy.sh <topic> <title> <message> <priority> <tags>
```

**`check_system.sh`** - System resource monitoring
- Checks every 5 minutes via cron
- Alerts on:
  - CPU > 90%
  - RAM > 80%
  - Disk > 85%
  - High load average

**`check_docker.sh`** - Docker container health
- Checks every 5 minutes via cron
- Alerts on:
  - Unhealthy containers
  - Exited containers
  - Restarting containers
  - Dead containers

**`check_container_stats.sh`** - Container resource usage
- Checks every 15 minutes via cron
- Alerts on:
  - Memory > 1GB
  - CPU > 80%

**`daily_report.sh`** - Daily health summary
- Runs at 8am daily
- Sends system overview report

## Cron Schedule

```
# System monitoring - check every 5 minutes
*/5 * * * * /home/ubuntu/scripts/monitoring/check_system.sh

# Docker monitoring - check every 5 minutes
*/5 * * * * /home/ubuntu/scripts/monitoring/check_docker.sh

# Container stats - check every 15 minutes
*/15 * * * * /home/ubuntu/scripts/monitoring/check_container_stats.sh

# Daily report at 8am
0 8 * * * /home/ubuntu/scripts/monitoring/daily_report.sh
```

## ntfy Topics

Subscribe to these topics in your ntfy app:

- **system-alerts** - CPU, RAM, disk warnings
- **docker-alerts** - Container problems and resource usage
- **daily-report** - Daily health summary

## Manual Testing

Test notifications:
```bash
/home/ubuntu/scripts/monitoring/ntfy.sh system-alerts "Test" "Monitoring is working!"
```

## Troubleshooting

**No notifications received:**
- Check ntfy container is running: `docker ps | grep ntfy`
- Verify cron jobs: `crontab -l`
- Test manually: `/home/ubuntu/scripts/monitoring/check_system.sh`
- Check ntfy app subscription to correct topics

**Container alerts not working:**
- Ensure scripts are executable: `chmod +x /home/ubuntu/scripts/monitoring/*.sh`
- Check Docker socket access for ubuntu user
- Verify ntfy URL in scripts matches your setup
