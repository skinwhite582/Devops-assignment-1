
#!/usr/bin/env bash

echo "================================"
echo "     SYSTEM INFORMATION"
echo "================================"

echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date and Time: $(date)"
echo "Operating System: $(uname -s)"
echo "Kernel Version: $(uname -r)"
echo "Uptime: $(uptime)"
echo "CPU Information:"
if command -v lscpu >/dev/null 2>&1; then
    lscpu
else
    echo "CPU information unavailable"
fi

echo "Memory Information:"
if command -v free >/dev/null 2>&1; then
    free -h
else
    echo "Memory information unavailable"
fi

echo "Current Working Directory: $(pwd)"
