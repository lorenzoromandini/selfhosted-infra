#!/bin/bash
# Send notification via ntfy

NTFY_URL="http://raspberry-pi-4.tail2ce491.ts.net:8081"
TOPIC="${1:-service-alerts}"
TITLE="${2:-System Alert}"
MESSAGE="${3:-Notification}"
PRIORITY="${4:-3}"
TAGS="${5:-warning}"

curl -s \
    -H "Title: $TITLE" \
    -H "Priority: $PRIORITY" \
    -H "Tags: $TAGS" \
    -d "$MESSAGE" \
    "$NTFY_URL/$TOPIC"
