#!/usr/bin/env bash
# 开关 Wofi 剪贴板历史（cliphist list → 选中后写回剪贴板）
set -euo pipefail
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/wofi"
if pidof wofi >/dev/null; then
  pkill wofi
  exit 0
fi
cliphist list | wofi --show dmenu \
  --prompt '剪贴板' \
  --conf "$CONF/config-clip" \
  --style "$CONF/style.css" \
  | cliphist decode | wl-copy
