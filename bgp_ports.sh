#!/usr/bin/env sh

set -e
set -x

V4=<bgp ipv4 地址>
V6=<bgp ipv6 地址>

iptables -t nat -A DOCKER -p udp --dport 20000:29999 -j DNAT --to-destination $V4
iptables -t nat -A POSTROUTING -p udp --dport 20000:29999 --source $V4 --destination $V4 -j MASQUERADE
iptables -t filter -I DOCKER-USER -p udp --dport 20000:29999 --destination $V4 -j ACCEPT

ip6tables -t nat -A OUTPUT -p udp --dport 20000:29999 -j DNAT --to-destination $V6
ip6tables -t nat -A PREROUTING -p udp --dport 20000:29999 -j DNAT --to-destination $V6
ip6tables -t nat -A POSTROUTING -p udp --dport 20000:29999 --source $V6 --destination $V6 -j MASQUERADE
ip6tables -t filter -I FORWARD -p udp --dport 20000:29999 --destination $V6 -j ACCEPT
