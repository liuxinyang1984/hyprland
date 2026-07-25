#!/usr/bin/env bash
# 在指定显示器上切换具名 special 工作区（togglespecialworkspace 默认跟焦点屏走）
# 用法：toggle-special.sh <monitor> <special-name>

set -euo pipefail

if [[ $# -ne 2 ]]; then
	echo "usage: toggle-special.sh <monitor> <special-name>" >&2
	exit 1
fi

target_monitor="$1"
special_name="$2"

current_win="$(hyprctl activewindow -j 2>/dev/null | jq -r '.address // empty')"
current_mon="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

if [[ "$current_mon" == "$target_monitor" ]]; then
	hyprctl dispatch togglespecialworkspace "$special_name"
	exit 0
fi

hyprctl keyword cursor:no_warps true
if [[ -n "$current_win" && "$current_win" != "null" && "$current_win" != "0x0" ]]; then
	hyprctl --batch \
		"dispatch focusmonitor ${target_monitor}; dispatch togglespecialworkspace ${special_name}; dispatch focuswindow address:${current_win}"
else
	hyprctl --batch \
		"dispatch focusmonitor ${target_monitor}; dispatch togglespecialworkspace ${special_name}; dispatch focusmonitor ${current_mon}"
fi
hyprctl keyword cursor:no_warps false
