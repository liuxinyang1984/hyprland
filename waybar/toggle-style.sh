#!/usr/bin/env bash
# 在 dark / light 之间切换 Waybar 样式，并通知 waybar 重载样式
set -euo pipefail

CONF="${XDG_CONFIG_HOME:-$HOME/.config}/waybar"
STATE="$CONF/.style-theme"
DARK="$CONF/styles/dark.css"
LIGHT="$CONF/styles/light.css"
TARGET="$CONF/style.css"

current="$(cat "$STATE" 2>/dev/null || echo dark)"

if [[ "$current" == "dark" ]]; then
  next="light"
  cp "$LIGHT" "$TARGET"
else
  next="dark"
  cp "$DARK" "$TARGET"
fi

echo "$next" > "$STATE"
# SIGUSR2：重载样式（无需整进程重启）
killall -SIGUSR2 waybar 2>/dev/null || true
notify-send "Waybar" "主题色：$next"
