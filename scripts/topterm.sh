#!/usr/bin/env bash
# 竖屏顶部分割区 foot topterm：不存在则拉起，钉到 DVI-D-1 顶边，可选聚焦
#

set -euo pipefail

readonly CLASS='topterm'
readonly TITLE='topterm'
readonly MONITOR='DVI-D-1'
readonly HEIGHT=288
readonly TOP=5
readonly CLOCK_CMD='tty-clock -c -s -C 2'

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
	hyprctl dispatch exec "foot -a $CLASS -T $TITLE -w ${w}x${HEIGHT} -- sh -c '${CLOCK_CMD}; exec \"\${SHELL:-bash}\" -i'"
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
		hyprctl dispatch resizewindowpixel "exact ${w} ${HEIGHT},class:$CLASS" 2>/dev/null || true
	fi
	hyprctl dispatch movewindowpixel "exact $((mx + border)) ${TOP},class:$CLASS" 2>/dev/null || true
}

focus_topterm() {
	hyprctl dispatch focuswindow "class:$CLASS" 2>/dev/null || true
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
