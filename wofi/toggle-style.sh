#!/usr/bin/env bash
# 与 Waybar 共用同一切换逻辑
exec "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/toggle-style.sh"
