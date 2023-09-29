#!/bin/sh

set -e

ip r del default
ip r add default via $DN42_GATEWAY_V4

ip -6 r del default
ip -6 r add default via $DN42_GATEWAY_V6

exec docker-entrypoint.sh
