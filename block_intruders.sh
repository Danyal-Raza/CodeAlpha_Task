#!/bin/bash

tail -n0 -F /var/log/suricata/fast.log | while read line; do
    echo "$line" | grep -E "Possible HTTP Connection" > /dev/null
    if [ $? -eq 0 ]; then
        ip=$(echo "$line" | grep -oP '\d+\.\d+\.d+\.\d+')
	echo "Blocking IP: $ip "
	iptables -A INPUT -s $ip -j DROP
    fi
done
