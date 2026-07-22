#!/usr/bin/env bash
# ============================================================
# 音量 / 麦克风（wpctl + PipeWire）
# 用法：--inc | --dec | --toggle | --toggle-mic
# 步进 5%，与 Waybar pulseaudio 滚轮一致
# ============================================================
set -euo pipefail

SINK="@DEFAULT_AUDIO_SINK@"
SOURCE="@DEFAULT_AUDIO_SOURCE@"
STEP="5%"

notify_vol() {
  local info vol muted=""
  info=$(wpctl get-volume "$SINK")
  vol="$info"
  if [[ "$info" == *MUTED* ]]; then
    muted=" (静音)"
    vol="${info% MUTED*}"
  fi
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
    "音量" "${vol}${muted}" 2>/dev/null || true
}

notify_mic() {
  local info
  info=$(wpctl get-volume "$SOURCE")
  if [[ "$info" == *MUTED* ]]; then
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
      "麦克风" "已静音" 2>/dev/null || true
  else
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
      "麦克风" "已开启" 2>/dev/null || true
  fi
}

case "${1:-}" in
  --inc)
    wpctl set-volume "$SINK" "${STEP}+"
    notify_vol
    ;;
  --dec)
    wpctl set-volume "$SINK" "${STEP}-"
    notify_vol
    ;;
  --toggle)
    wpctl set-mute "$SINK" toggle
    notify_vol
    ;;
  --toggle-mic)
    wpctl set-mute "$SOURCE" toggle
    notify_mic
    ;;
  *)
    echo "用法: $0 [--inc|--dec|--toggle|--toggle-mic]" >&2
    exit 2
    ;;
esac
