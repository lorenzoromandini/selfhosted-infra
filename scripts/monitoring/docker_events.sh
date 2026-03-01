#!/bin/bash
# Monitor Docker events in real-time

NTFY_URL="https://raspberry-pi-4.tail2ce491.ts.net/ntfy"
TOPIC="docker-alerts"

docker events --filter 'event=die' --filter 'event=kill' --filter 'event=stop' --format '{{.Actor.Attributes.name}} {{.Status}}' | while read -r event; do
    CONTAINER=$(echo $event | awk '{print $1}')
    ACTION=$(echo $event | awk '{print $2}')
    
    curl -s \
        -H "Title: Container $ACTION" \
        -H "Priority: 3" \
        -H "Tags: docker" \
        -d "Container $CONTAINER $ACTION" \
        "$NTFY_URL/$TOPIC"
done
