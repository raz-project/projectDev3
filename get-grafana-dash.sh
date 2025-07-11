#!/bin/bash
set -e

GRAFANA_URL="http://localhost:30900"
USER="admin"
PASS="admin"
DASHBOARD_DIR="dashboards"

# Ensure output directory exists
mkdir -p "$DASHBOARD_DIR"

# Fetch all dashboard UIDs
uids=$(curl -s -u "$USER:$PASS" "$GRAFANA_URL/api/search?type=dash-db" | jq -r '.[].uid')

# Loop through each UID and process
for uid in $uids; do
  echo "Downloading dashboard UID: $uid"

  # Fetch full dashboard response
  response=$(curl -s -u "$USER:$PASS" "$GRAFANA_URL/api/dashboards/uid/$uid")

  # Extract and print title
  title=$(echo "$response" | jq -r '.dashboard.title')
  echo "Dashboard Title: $title"

  # Extract dashboard JSON
  dashboard_json=$(echo "$response" | jq '.dashboard')

  # Save JSON to file
  echo "$dashboard_json" > "$DASHBOARD_DIR/$uid.json"

  # Print JSON content to terminal
  echo "Dashboard JSON content:"
  echo "$dashboard_json" | jq

  echo "---------------------------------------------"
done

echo "All dashboards saved and printed."
