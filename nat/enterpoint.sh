#!/bin/sh

set -e
set -x

iptables -t mangle -A PREROUTING -i eth0 -s $NET_LOCAL -d 172.20.0.0/14 -j MARK --set-mark 2
iptables -t nat -A POSTROUTING -m mark --mark 2 -j MASQUERADE

ip6tables -t mangle -A PREROUTING -i eth0 ! -s fd00::/8 -d fd00::/8 -j MARK --set-mark 2
ip6tables -t nat -A POSTROUTING -m mark --mark 2 -j MASQUERADE

ip -f inet route del default
ip -f inet6 route del default

ip -f inet route add default dev eth0 via $DN42_GATEWAY_V4
ip -f inet6 route add default dev eth0 via $DN42_GATEWAY_V6

exec "$@"
