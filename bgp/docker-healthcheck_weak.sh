#!/bin/bash

set -e

# 检查 bird 运行状态
if [ "$(birdc show status | grep -c 'up and running')" -eq 0 ]; then
    birdc show status
    exit 1
fi
