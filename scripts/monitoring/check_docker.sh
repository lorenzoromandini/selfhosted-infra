#!/bin/bash
# Check Docker containers and notify on state changes

NTFY_URL="http://raspberry-pi-4.tail2ce491.ts.net:8081"
TOPIC="docker-alerts"
STATE_FILE="/tmp/docker_container_state.json"

get_container_state() {
    local container="$1"
    local status=$(docker inspect --format='{{.State.Status}}' "$container" 2>/dev/null)
    local health=$(docker inspect --format='{{.State.Health.Status}}' "$container" 2>/dev/null)
    
    if [ "$status" = "running" ]; then
        if [ "$health" = "unhealthy" ]; then
            echo "unhealthy"
        else
            echo "running"
        fi
    elif [ "$status" = "exited" ]; then
        echo "exited"
    elif [ "$status" = "restarting" ]; then
        echo "restarting"
    elif [ "$status" = "dead" ]; then
        echo "dead"
    else
        echo "unknown"
    fi
}

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

get_problem_containers() {
    local state="$1"
    local problem_containers=""
    
    unhealthy=$(docker ps -a --filter health=unhealthy --format '{{.Names}}')
    if [ -n "$unhealthy" ]; then
        problem_containers="${problem_containers}Unhealthy: ${unhealthy}\n"
    fi
    
    exited=$(docker ps -a --filter status=exited --format '{{.Names}}')
    if [ -n "$exited" ]; then
        problem_containers="${problem_containers}Exited: ${exited}\n"
    fi
    
    restarting=$(docker ps -a --filter status=restarting --format '{{.Names}}')
    if [ -n "$restarting" ]; then
        problem_containers="${problem_containers}Restarting: ${restarting}\n"
    fi
    
    dead=$(docker ps -a --filter status=dead --format '{{.Names}}')
    if [ -n "$dead" ]; then
        problem_containers="${problem_containers}Dead: ${dead}\n"
    fi
    
    echo -e "$problem_containers"
}

previous_state=$(load_state)
current_state="{}"

all_containers=$(docker ps -a --format '{{.Names}}')

new_problems=""
resolved=""

for container in $all_containers; do
    current_container_state=$(get_container_state "$container")
    
    previous_container_state=$(echo "$previous_state" | python3 -c "import sys, json; print(json.load(sys.stdin).get('$container', 'unknown'))" 2>/dev/null || echo "unknown")
    
    current_state=$(echo "$current_state" | python3 -c "
import sys, json
data = json.load(sys.stdin)
data['$container'] = '$current_container_state'
print(json.dumps(data))
" 2>/dev/null || echo "{}")
    
    if [ "$previous_container_state" = "unknown" ] || [ "$previous_container_state" = "running" ]; then
        if [ "$current_container_state" = "unhealthy" ]; then
            new_problems="${new_problems}${container} became unhealthy\n"
        elif [ "$current_container_state" = "exited" ]; then
            new_problems="${new_problems}${container} stopped\n"
        elif [ "$current_container_state" = "restarting" ]; then
            new_problems="${new_problems}${container} is restarting\n"
        elif [ "$current_container_state" = "dead" ]; then
            new_problems="${new_problems}${container} is dead\n"
        fi
    fi
    
    if [ "$previous_container_state" != "unknown" ] && [ "$previous_container_state" != "running" ]; then
        if [ "$current_container_state" = "running" ]; then
            resolved="${resolved}${container} is back up (was ${previous_container_state})\n"
        fi
    fi
done

save_state "$current_state"

if [ -n "$new_problems" ]; then
    send_notification "Docker Alert" "4" "docker,error" "$new_problems"
fi

if [ -n "$resolved" ]; then
    send_notification "Docker Resolved" "3" "docker,white_check_mark" "$resolved"
fi
