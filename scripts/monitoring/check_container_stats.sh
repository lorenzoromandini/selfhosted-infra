#!/bin/bash
# Check Docker container stats and notify on state changes

NTFY_URL="http://raspberry-pi-4.tail2ce491.ts.net:8081"
TOPIC="docker-alerts"
STATE_FILE="/tmp/container_stats_state.json"

load_state() {
    if [ -f "$STATE_FILE" ]; then
        cat "$STATE_FILE"
    else
        echo "{}"
    fi
}

save_state() {
    echo "$1" > "$STATE_FILE"
}

send_notification() {
    local title="$1"
    local priority="$2"
    local tags="$3"
    local message="$4"
    
    curl -s \
        -H "Title: $title" \
        -H "Priority: $priority" \
        -H "Tags: $tags" \
        -d "$message" \
        "$NTFY_URL/$TOPIC" &
}

previous_state=$(load_state)
current_state_json="{}"

docker stats --no-stream --format "{{.Name}}|{{.MemUsage}}|{{.CPUPerc}}" 2>/dev/null > /tmp/docker_stats.txt

while IFS='|' read -r CONTAINER MEM_INFO CPU_INFO; do
    [ -z "$CONTAINER" ] && continue
    
    CPU_PCT=$(echo "$CPU_INFO" | sed 's/%//g' | tr -d ' ')
    
    MEM_RAW=$(echo "$MEM_INFO" | sed 's/\/.*//' | tr -d ' ')
    MEM_VALUE=$(echo "$MEM_RAW" | sed -E 's/[^0-9.]//g')
    MEM_UNIT=$(echo "$MEM_RAW" | sed -E 's/[0-9.]//g')
    
    case "$MEM_UNIT" in
        "GiB"|"GB") MEM_MB=$(echo "$MEM_VALUE * 1024" | bc 2>/dev/null || echo "0") ;;
        "MiB"|"MB") MEM_MB=$MEM_VALUE ;;
        "KiB"|"KB") MEM_MB=$(echo "$MEM_VALUE / 1024" | bc 2>/dev/null || echo "0") ;;
        *) MEM_MB=0 ;;
    esac
    
    prev_cpu_state=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$CONTAINER', {}).get('cpu_state', 'ok'))" 2>/dev/null || echo "ok")
    prev_mem_state=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$CONTAINER', {}).get('mem_state', 'ok'))" 2>/dev/null || echo "ok")
    
    cpu_state="ok"
    mem_state="ok"
    
    if [ -n "$MEM_MB" ] && [ "$MEM_MB" -gt 1024 ] 2>/dev/null; then
        mem_state="alert"
    fi
    
    if [ -n "$CPU_PCT" ]; then
        if awk "BEGIN {exit !($CPU_PCT > 80)}" 2>/dev/null; then
            cpu_state="alert"
        fi
    fi
    
    if [ "$prev_mem_state" = "ok" ] && [ "$mem_state" = "alert" ]; then
        send_notification "High Memory Usage" "3" "docker,memory" "Container $CONTAINER using $MEM_INFO" &
    elif [ "$prev_mem_state" = "alert" ] && [ "$mem_state" = "ok" ]; then
        prev_mem=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$CONTAINER', {}).get('mem', '0'))" 2>/dev/null || echo "0")
        send_notification "Memory Normal" "3" "docker,memory,white_check_mark" "Container $CONTAINER memory back to normal (was ${prev_mem}MB, now ${MEM_MB}MB)" &
    fi
    
    if [ "$prev_cpu_state" = "ok" ] && [ "$cpu_state" = "alert" ]; then
        send_notification "High CPU Usage" "3" "docker,cpu" "Container $CONTAINER using ${CPU_PCT}% CPU" &
    elif [ "$prev_cpu_state" = "alert" ] && [ "$cpu_state" = "ok" ]; then
        prev_cpu=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$CONTAINER', {}).get('cpu', '0'))" 2>/dev/null || echo "0")
        send_notification "CPU Normal" "3" "docker,cpu,white_check_mark" "Container $CONTAINER CPU back to normal (was ${prev_cpu}%, now ${CPU_PCT}%)" &
    fi
    
    current_state_json=$(echo "$current_state_json" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['$CONTAINER'] = {'cpu_state': '$cpu_state', 'mem_state': '$mem_state', 'cpu': '$CPU_PCT', 'mem': '$MEM_MB'}
print(json.dumps(data))
" 2>/dev/null || echo "{}")

done < /tmp/docker_stats.txt

save_state "$current_state_json"
rm -f /tmp/docker_stats.txt
wait
