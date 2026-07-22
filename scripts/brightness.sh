#!/usr/bin/env bash
# ============================================================
# 屏幕亮度（brightnessctl）
# 用法：--inc | --dec
# 步进 10%，与 Waybar backlight 滚轮一致
# ============================================================
set -euo pipefail

notify_brightness() {
  local pct
  pct=$(brightnessctl -m | cut -d, -f4)
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
    "亮度" "$pct" 2>/dev/null || true
}

case "${1:-}" in
  --inc)
    brightnessctl set +10%
    notify_brightness
    ;;
  --dec)
    brightnessctl set 10%-
    notify_brightness
    ;;
  *)
    echo "用法: $0 [--inc|--dec]" >&2
    exit 2
    ;;
esac
