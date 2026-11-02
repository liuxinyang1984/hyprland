#!/usr/bin/env bash
# 竖屏顶部分割区 foot topterm：不存在则拉起，钉到 DVI-D-1 顶边，可选聚焦
# Hyprland 0.57+：hyprctl dispatch 使用 hl.dsp.* Lua 语法

set -euo pipefail

readonly CLASS='topterm'
readonly TITLE='topterm'
readonly MONITOR='DVI-D-1'
readonly HEIGHT=288
readonly TOP=5
readonly CLOCK_CMD='tty-clock -c -s -C 2'

hl_exec() {
	hyprctl eval "hl.exec_cmd([=[${1}]=])" >/dev/null
}

hl_dispatch() {
	hyprctl dispatch "$1" >/dev/null
}

topterm_exists() {
	hyprctl clients -j 2>/dev/null | jq -e --arg c "$CLASS" '.[] | select(.class == $c)' >/dev/null
}

# 输出：content_w monitor_x monitor_y border
topterm_geom() {
	local mw mx my border w
	read -r mw mx my < <(
		hyprctl monitors -j | jq -r --arg m "$MONITOR" '
			.[] | select(.name == $m) |
			if (.transform == 1 or .transform == 3 or .transform == 5 or .transform == 7) then
				"\(.height) \(.x) \(.y)"
			else
				"\(.width) \(.x) \(.y)"
			end
		'
	)
	border="$(hyprctl getoption general:border_size -j | jq -r '.int')"
	w=$((mw - border * 2))
	echo "$w $mx $my $border"
}

ensure_topterm() {
	if topterm_exists; then
		return 0
	fi
	local w mx my border
	read -r w mx my border < <(topterm_geom)
	hl_exec "foot -a ${CLASS} -T ${TITLE} -w ${w}x${HEIGHT} -- sh -c '${CLOCK_CMD}; exec \"\${SHELL:-bash}\" -i'"
	for _ in $(seq 1 30); do
		sleep 0.05
		topterm_exists && return 0
	done
	echo "topterm: foot did not appear" >&2
	return 1
}

# 校正位置；新开窗口已用 -w 定好尺寸，仅 reposition，避免 resize 闪一下
layout_topterm() {
	local resize="${1:-1}"
	local w mx my border
	read -r w mx my border < <(topterm_geom)
	if [[ "$resize" == 1 ]]; then
		hl_dispatch "hl.dsp.window.resize({ x = ${w}, y = ${HEIGHT}, relative = false, window = \"class:${CLASS}\" })" || true
	fi
	hl_dispatch "hl.dsp.window.move({ x = $((mx + border)), y = ${TOP}, relative = false, window = \"class:${CLASS}\" })" || true
}

focus_topterm() {
	hl_dispatch "hl.dsp.focus({ window = \"class:${CLASS}\" })" || true
}

mode='pin'
if [[ "${1:-}" == '--focus' ]]; then
	mode='focus'
fi

had_topterm=false
if topterm_exists; then
	had_topterm=true
fi

ensure_topterm
if [[ "$had_topterm" == true ]]; then
	layout_topterm 1
else
	layout_topterm 0
fi
if [[ "$mode" == 'focus' ]]; then
	focus_topterm
fi
