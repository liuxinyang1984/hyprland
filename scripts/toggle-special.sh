#!/usr/bin/env bash
# 在指定显示器上切换具名 special 工作区（toggle_special 默认跟焦点屏走）
# 用法：toggle-special.sh <monitor> <special-name>
#
# Hyprland 0.57+：hyprctl dispatch 使用 hl.dsp.* Lua 语法
# 跨屏时只 focus monitor 来回，不要 focuswindow：否则偶发把原窗搬到目标屏 special。

set -euo pipefail

if [[ $# -ne 2 ]]; then
	echo "usage: toggle-special.sh <monitor> <special-name>" >&2
	exit 1
fi

target_monitor="$1"
special_name="$2"

hl_dispatch() {
	hyprctl dispatch "$1" >/dev/null
}

current_mon="$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')"

if [[ "$current_mon" == "$target_monitor" ]]; then
	hl_dispatch "hl.dsp.workspace.toggle_special(\"${special_name}\")"
	exit 0
fi

hyprctl eval 'hl.config({ cursor = { no_warps = true } })' >/dev/null
hyprctl --batch \
	"dispatch hl.dsp.focus({ monitor = \"${target_monitor}\" }); dispatch hl.dsp.workspace.toggle_special(\"${special_name}\"); dispatch hl.dsp.focus({ monitor = \"${current_mon}\" })"
hyprctl eval 'hl.config({ cursor = { no_warps = false } })' >/dev/null
