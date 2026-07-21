#!/usr/bin/env bash
# 开关 Wofi「运行命令」模式
set -euo pipefail
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/wofi"
if pidof wofi >/dev/null; then
  pkill wofi
  exit 0
fi
wofi --show run \
  --prompt '命令' \
  --conf "$CONF/config-run" \
  --style "$CONF/style.css"
