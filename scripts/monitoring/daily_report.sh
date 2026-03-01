#!/bin/bash
# Daily health report

NTFY_URL="http://raspberry-pi-4.tail2ce491.ts.net:8081"
TOPIC="daily-report"

# Get system stats
UPTIME=$(uptime -p)
LOAD=$(uptime | grep -oP 'load average: \K[0-9.]+' | head -1)
MEM=$(free -h | awk '/^Mem:/ {print $3"/"$2" ("int($3/$2*100)"%)"}')
DISK=$(df -h / | tail -1 | awk '{print $3"/"$2" ("$5")"}')
CONTAINERS=$(docker ps --format '{{.Names}}' | wc -l)

REPORT="📊 Daily Health Report

⏱️ Uptime: $UPTIME
💾 Memory: $MEM
💿 Disk: $DISK
⚡ Load: $LOAD
🐳 Containers: $CONTAINERS running"

curl -s \
    -H "Title: Daily Report" \
    -H "Priority: 2" \
    -H "Tags: report" \
    -d "$REPORT" \
    "$NTFY_URL/$TOPIC"
