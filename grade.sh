#!/usr/bin/env bash

set -u

PASS=0
FAIL=0

pass() {
    echo "PASS: $1"
    PASS=$((PASS + 1))
}

fail() {
    echo "FAIL: $1"
    FAIL=$((FAIL + 1))
}

echo "=================================="
echo "Assignment 1 - Diagnostic Toolkit"
echo "=================================="

mkdir -p logs

for file in README.md system-info.sh disk-check.sh network-check.sh; do
    if [[ -f "$file" ]]; then
        pass "Required file exists: $file"
    else
        fail "Missing required file: $file"
    fi
done

for file in system-info.sh disk-check.sh network-check.sh; do
    if [[ -f "$file" ]]; then
        if bash -n "$file"; then
            pass "Bash syntax: $file"
        else
            fail "Bash syntax error: $file"
        fi
    fi
done

if [[ -f system-info.sh ]]; then
    output=$(bash system-info.sh 2>&1)
    if [[ $? -eq 0 ]] &&
       grep -qi "hostname" <<< "$output" &&
       grep -qi "uptime" <<< "$output"; then
        pass "System information output"
    else
        fail "System information output"
    fi
fi

if [[ -f disk-check.sh ]]; then
    bash disk-check.sh invalid >/dev/null 2>&1
    rc=$?
    if [[ $rc -eq 2 ]]; then
        pass "Disk checker rejects invalid input"
    else
        fail "Disk checker input validation"
    fi
fi

if [[ -f network-check.sh ]]; then
    bash network-check.sh >/dev/null 2>&1
    rc=$?
    if [[ $rc -ne 0 ]]; then
        pass "Network checker rejects missing host"
    else
        fail "Network checker input validation"
    fi
fi

echo
echo "Passed: $PASS"
echo "Failed: $FAIL"

if [[ $FAIL -eq 0 ]]; then
    echo "All available checks passed."
    exit 0
else
    echo "Some checks failed. Review the messages above."
    exit 1
fi
