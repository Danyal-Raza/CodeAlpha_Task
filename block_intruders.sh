#!/bin/bash

# === Configuration ===
ALERT_LOG="/var/log/suricata/fast.log"
BLOCKED_IPS_FILE="/tmp/blocked_ips.txt"

# === Initialization ===
touch "$BLOCKED_IPS_FILE"
echo "[INFO] Starting Intrusion Response Script..."
echo "[INFO] Watching: $ALERT_LOG"

# === Start Monitoring ===
tail -Fn0 "$ALERT_LOG" | while read -r line; do
    # Check if the line contains any of the alert messages
    if echo "$line" | grep -Eiq "SSH Brute Force Attempt|Telnet Connection Detected|FTP Connection Attempt|Possible HTTP Connection|ICMP Ping Detected"; then
        # Extract IP address (assumes IP is present in the log line)
        ip=$(echo "$line" | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | head -n 1)

        if [ -n "$ip" ]; then
            # Check if IP is already blocked
            if ! grep -q "$ip" "$BLOCKED_IPS_FILE"; then
                echo "[ALERT] Blocking IP: $ip (Reason: $(echo "$line" | cut -d']' -f2))"
                iptables -A INPUT -s "$ip" -j DROP
                echo "$ip" >> "$BLOCKED_IPS_FILE"
            else
                echo "[INFO] IP $ip already blocked. Skipping..."
            fi
        fi
    fi
done
