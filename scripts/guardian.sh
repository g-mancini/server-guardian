#!/bin/bash
set -euo pipefail
# ==============================
# Server Guardian Script
# ==============================

# Carica configurazione
CONFIG_FILE="$(dirname "$0")/../config/config.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Config file not found!"
    exit 1
fi

source "$CONFIG_FILE"

# Timestamp
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# Logging
log() {
    echo "[$(timestamp)] $1" | tee -a "$LOG_FILE"
}

# Check root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Run as root"
        exit 1
    fi
}

# Init
init() {
    mkdir -p "$BACKUP_DIR"
    touch "$LOG_FILE"
}

# Test funzione base
test_run() {
    log "Server Guardian started"
    export_metrics
}

# ==============================
# Resource Monitoring
# ==============================

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'
}

get_ram_usage() {
    free | grep Mem | awk '{print $3/$2 * 100.0}'
}

get_disk_usage() {
    df / | tail -1 | awk '{print $5}' | sed 's/%//'
}

# ==============================
# Export metrics to JSON
# ==============================

export_metrics() {
    CPU=$(get_cpu_usage)
    RAM=$(get_ram_usage)
    DISK=$(get_disk_usage)

    log "CPU: $CPU% | RAM: $RAM% | DISK: $DISK%"

    cat <<EOF > "$JSON_METRICS"
{
    "cpu": $CPU,
    "ram": $RAM,
    "disk": $DISK,
    "timestamp": "$(timestamp)"
}
EOF
}

main() {
    check_root
    init
    test_run
}

main
