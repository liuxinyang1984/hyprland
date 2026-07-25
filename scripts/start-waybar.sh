#!/usr/bin/env bash
# 等 xdg-desktop-portal 上总线后再启 waybar，避免启动期 DBus StartServiceByName 卡死。
# 最长等待约 15s；超时仍启动（waybar 会打日志但通常能出栏）。
set -euo pipefail

wait_portal() {
  local i
  for i in $(seq 1 30); do
    if busctl --user status org.freedesktop.portal.Desktop >/dev/null 2>&1; then
      return 0
    fi
    sleep 0.5
  done
  return 1
}

wait_portal || true
exec waybar "$@"
