#!/bin/bash
set -e

# === DISK USAGE ALERT LOGIC ===
echo "Checking for disk usage over 90%..."
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 90 ]; then
  echo "❌ ALERT: Root partition usage is at ${DISK_USAGE}% — threshold exceeded!"
  exit 1  # Fails the GitHub Actions job
else
  echo "✅ Disk usage is OK: ${DISK_USAGE}%"
fi

# === LOGGING SYS INFO ===
mkdir -p logs
LOGFILE="logs/$(date +%F).log"

{
  echo "===== Daily System Monitor ====="
  echo "Date: $(date)"
  echo
  echo ">>> UPTIME"
  uptime
  echo
  echo ">>> DISK USAGE"
  df -h
  echo
  echo ">>> MEMORY USAGE"
  free -h || vm_stat
  echo
  echo ">>> CPU LOAD"
  top -bn1 | head -n 5 || echo "top not available"
  echo
  echo ">>> NETWORK"
  (ip a || ifconfig) 2>/dev/null
  echo
  echo ">>> PROCESSES"
  ps aux | head -n 10
  echo
} >> "$LOGFILE"
