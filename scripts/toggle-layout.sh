#!/usr/bin/env bash
# dwindle ↔ master 布局切换（Super+Alt+Return）
set -euo pipefail

layout=$(hyprctl -j getoption general:layout | jq -r '.str')

if [[ "$layout" == "dwindle" ]]; then
  hyprctl keyword general:layout master
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
    "布局" "master" 2>/dev/null || true
else
  hyprctl keyword general:layout dwindle
  notify-send -h string:x-canonical-private-synchronous:sys-notify -u low \
    "布局" "dwindle" 2>/dev/null || true
fi
