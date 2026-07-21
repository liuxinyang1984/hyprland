#!/usr/bin/env bash
# 开关 Wofi 应用启动器（样式自洽，不依赖 colors 文件）
set -euo pipefail
CONF="${XDG_CONFIG_HOME:-$HOME/.config}/wofi"
if pidof wofi >/dev/null; then
  pkill wofi
  exit 0
fi
wofi --show drun \
  --prompt '应用' \
  --conf "$CONF/config" \
  --style "$CONF/style.css"
