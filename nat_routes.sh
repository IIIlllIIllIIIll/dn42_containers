#!/usr/bin/env sh

set -e
set -x

V4=<nat 的 IPV4>
V6=<nat 的 IPV6>

ip route add 172.20.0.0/14 via $V4
ip route add fd00::/8 via $V6
