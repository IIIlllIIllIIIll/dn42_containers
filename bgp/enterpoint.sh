#!/bin/bash

set -e
set -x

cleanup() {
    echo "Shutting down!"

    birdc down

    # 关闭所有基于wg的peers连接
    if ls /etc/wireguard/*.conf; then
        for i in /etc/wireguard/*.conf; do wg-quick down $i; done
    fi
    exit 0
}

#Trap SIGTERM
trap 'cleanup' SIGTERM

# 初始化所有基于wg的peers连接
if ls /etc/wireguard/*.conf; then
    for i in /etc/wireguard/*.conf; do wg-quick up $i; done
fi

# 先更新一次bird的roa文件
curl -sfSLR -o/etc/bird/roa_dn42.conf -z/etc/bird/roa_dn42.conf https://dn42.burble.com/roa/dn42_roa_bird2_4.conf
curl -sfSLR -o/etc/bird/roa_dn42_v6.conf -z/etc/bird/roa_dn42_v6.conf https://dn42.burble.com/roa/dn42_roa_bird2_6.conf

# 启动bird
bird -c /etc/bird/bird.conf

# 启动cron
cron -f &

#Wait
wait $!

echo "cron error!"

cleanup
