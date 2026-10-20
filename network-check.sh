#!/usr/bin/env bash

set -u

LOG_DIR="logs"
mkdir -p "$LOG_DIR"

HOST="${1:-}"
PORT="${2:-}"

if [[ -z "$HOST" ]]; then
    echo "Usage: $0 <hostname-or-ip> [port]"
    exit 2
fi

if [[ ! "$HOST" =~ ^[a-zA-Z0-9.-]+$ ]]; then
    echo "Error: Invalid hostname or IP address."
    exit 2
fi

if [[ -n "$PORT" ]]; then
    if [[ ! "$PORT" =~ ^[0-9]+$ ]] ||
       (( PORT < 1 || PORT > 65535 )); then
        echo "Error: Port must be an integer between 1 and 65535."
        exit 2
    fi
fi

echo "Checking host: $HOST"

if command -v getent >/dev/null 2>&1; then
    ADDRESS=$(getent ahosts "$HOST" | awk 'NR==1 {print $1}')
elif command -v nslookup >/dev/null 2>&1; then
    ADDRESS=$(nslookup "$HOST" 2>/dev/null |
        awk '/^Address: / {print $2; exit}')
else
    echo "Error: No supported DNS lookup command found."
    exit 1
fi

if [[ -z "${ADDRESS:-}" ]]; then
    echo "Error: Could not resolve host."
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Host resolution failed: $HOST" >> "$LOG_DIR/network-check.log"
    exit 1
fi

echo "Resolved address: $ADDRESS"

if command -v ping >/dev/null 2>&1; then
    if ping -c 1 -W 2 "$HOST" >/dev/null 2>&1; then
        echo "Connectivity: Ping successful"
    else
        echo "Connectivity: Ping failed or blocked"
    fi
else
    echo "Connectivity: Ping command unavailable"
fi

if command -v ip >/dev/null 2>&1; then
    echo "Network interfaces:"
    ip -brief address
elif command -v ifconfig >/dev/null 2>&1; then
    ifconfig
else
    echo "Network interface information unavailable"
fi

if [[ -n "$PORT" ]]; then
    if command -v nc >/dev/null 2>&1; then
        if nc -z -w 3 "$HOST" "$PORT"; then
            echo "TCP port $PORT: Open"
        else
            echo "TCP port $PORT: Closed or unreachable"
            exit 1
        fi
    elif command -v timeout >/dev/null 2>&1 &&
         timeout 3 bash -c 'echo >/dev/tcp/$1/$2' _ "$HOST" "$PORT" 2>/dev/null; then
        echo "TCP port $PORT: Open"
    else
        echo "TCP port $PORT: Closed, unreachable, or check unavailable"
        exit 1
    fi
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') - Network check completed for $HOST" >> "$LOG_DIR/network-check.log"
