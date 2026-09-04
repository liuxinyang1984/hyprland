#!/usr/bin/env bash
# 在指定显示器上切换具名 special 工作区（togglespecialworkspace 默认跟焦点屏走）
# 用法：toggle-special.sh <monitor> <special-name>
#
# 跨屏时只 focusmonitor 来回，不要 focuswindow：否则 Hyprland 偶发把原窗
# 搬到目标屏的 special（例如在 left 上按 Super+] 窗被送到 right）。

set -euo pipefail

if [[ $# -ne 2 ]]; then
	echo "usage: toggle-special.sh <monitor> <special-name>" >&2
	exit 1
fi

target_monitor="$1"
special_name="$2"

current_mon="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

if [[ "$current_mon" == "$target_monitor" ]]; then
	hyprctl dispatch togglespecialworkspace "$special_name"
	exit 0
fi

hyprctl keyword cursor:no_warps true
hyprctl --batch \
	"dispatch focusmonitor ${target_monitor}; dispatch togglespecialworkspace ${special_name}; dispatch focusmonitor ${current_mon}"
hyprctl keyword cursor:no_warps false
