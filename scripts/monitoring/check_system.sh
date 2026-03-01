#!/bin/bash
# Check system resources and notify on state changes

NTFY_URL="http://raspberry-pi-4.tail2ce491.ts.net:8081"
TOPIC="service-alerts"
STATE_FILE="/tmp/system_metrics_state.json"

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

check_and_notify() {
    local metric="$1"
    local current_value="$2"
    local threshold="$3"
    local unit="$4"
    
    local prev_state=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$metric', {}).get('state', 'ok'))" 2>/dev/null || echo "ok")
    local prev_value=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$metric', {}).get('value', '0'))" 2>/dev/null || echo "0")
    
    local current_state="ok"
    if [ "$current_value" -gt "$threshold" ]; then
        current_state="alert"
    fi
    
    if [ "$prev_state" = "ok" ] && [ "$current_state" = "alert" ]; then
        curl -s \
            -H "Title: High $metric" \
            -H "Priority: 4" \
            -H "Tags: warning" \
            -d "$metric usage is ${current_value}${unit} (threshold: ${threshold}${unit})" \
            "$NTFY_URL/$TOPIC" &
    elif [ "$prev_state" = "alert" ] && [ "$current_state" = "ok" ]; then
        curl -s \
            -H "Title: $metric Normal" \
            -H "Priority: 3" \
            -H "Tags: white_check_mark" \
            -d "$metric usage back to normal (was ${prev_value}${unit}, now ${current_value}${unit})" \
            "$NTFY_URL/$TOPIC" &
    fi
    
    current_state_json=$(echo "$current_state_json" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['$metric'] = {'state': '$current_state', 'value': '$current_value'}
print(json.dumps(data))
" 2>/dev/null || echo "{}")
}

previous_state=$(load_state)
current_state_json="{}"

CPU_USAGE=$(top -bn2 -d 1 | grep "Cpu(s)" | tail -1 | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
CPU_INT=${CPU_USAGE%.*}
check_and_notify "CPU" "$CPU_INT" "90" "%"

MEM_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
check_and_notify "Memory" "$MEM_USAGE" "80" "%"

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
check_and_notify "Disk" "$DISK_USAGE" "85" "%"

LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
CPU_CORES=$(nproc)
LOAD_THRESHOLD=$(echo "$CPU_CORES * 2" | bc | cut -d. -f1)
LOAD_INT=${LOAD%.*}
check_and_notify "Load" "$LOAD_INT" "$LOAD_THRESHOLD" ""

save_state "$current_state_json"
wait
