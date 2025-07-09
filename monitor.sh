#!/bin/bash
set -e

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
