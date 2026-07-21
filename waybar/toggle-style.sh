#!/usr/bin/env bash
# 同时切换 Waybar 与 Wofi 的 dark / light（同色系）
set -euo pipefail

CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
WB="$CFG/waybar"
WF="$CFG/wofi"
# 以 Waybar 状态为准
STATE="$WB/.style-theme"

current="$(cat "$STATE" 2>/dev/null || echo dark)"
if [[ "$current" == "dark" ]]; then
  next="light"
else
  next="dark"
fi

cp "$WB/styles/${next}.css" "$WB/style.css"
cp "$WF/styles/${next}.css" "$WF/style.css"
echo "$next" > "$STATE"
echo "$next" > "$WF/.style-theme"

# 重载 Waybar 样式；Wofi 下次打开即用新 style.css
killall -SIGUSR2 waybar 2>/dev/null || true
notify-send "主题" "Waybar + Wofi → $next" 2>/dev/null || true
