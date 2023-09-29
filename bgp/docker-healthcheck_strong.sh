#!/bin/bash

set -e

# 检查 wireguard 连接状态
if [ "$(find /etc/wireguard/*.conf | wc -l)" -gt 0 ]; then
    for i in $(wg show interfaces); do
        if [ $(($(date -u +%s) - $(wg show "$i" latest-handshakes | awk '{print $2}'))) -gt 180 ]; then
            wg show "$i"
            exit 1
        fi
    done
fi

# 检查 bird 运行状态
if [ "$(birdc show status | grep -c 'up and running')" -eq 0 ]; then
    birdc show status
    exit 1
fi

# 检查 peer 状态
if [ "$(birdc show protocols | grep -c 'Established')" -lt "$(find /etc/wireguard/*.conf | wc -l)" ]; then
    birdc show protocols
    exit 1
fi
