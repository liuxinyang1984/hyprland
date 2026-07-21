#!/usr/bin/env bash
# ============================================================
# 壁纸（awww）
# 用法：
#   wallpaper.sh          # 随机一张（默认）
#   wallpaper.sh random   # 同上
#   wallpaper.sh restore  # 恢复上次；若无记录则随机
# ============================================================
set -euo pipefail

# 壁纸目录（可用环境变量覆盖）
DIR="${WALLPAPER_DIR:-$HOME/Pictures/wallpapers}"

# 等 awww-daemon 就绪（最多约 5 秒）
ensure_daemon() {
  mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/awww"
  if awww query &>/dev/null; then
    return 0
  fi
  # 已有残留进程则不再重复拉起
  if ! pidof awww-daemon >/dev/null 2>&1; then
    awww-daemon &
  fi
  local i
  for i in $(seq 1 50); do
    if awww query &>/dev/null; then
      return 0
    fi
    sleep 0.1
  done
  echo "wallpaper: awww-daemon 未能就绪" >&2
  return 1
}

# 从目录中随机选一张常见图片
pick_random() {
  local -a pics=()
  mapfile -t pics < <(
    find "$DIR" -type f \( \
      -iname '*.jpg' -o -iname '*.jpeg' -o \
      -iname '*.png' -o -iname '*.gif' -o \
      -iname '*.webp' \
    \) 2>/dev/null
  )
  if ((${#pics[@]} == 0)); then
    echo "wallpaper: 目录为空或无图片：$DIR" >&2
    return 1
  fi
  printf '%s\n' "${pics[RANDOM % ${#pics[@]}]}"
}

# 设置壁纸（裁剪铺满 + 随机过渡）
set_image() {
  local img=$1
  awww img "$img" \
    --resize crop \
    --transition-type random \
    --transition-fps 60 \
    --transition-duration 2
}

cmd_random() {
  ensure_daemon
  local img
  img="$(pick_random)"
  set_image "$img"
}

cmd_restore() {
  ensure_daemon
  # 无上次记录时 restore 会失败，退回随机
  if ! awww restore 2>/dev/null; then
    cmd_random
  fi
}

case "${1:-random}" in
  random)  cmd_random ;;
  restore) cmd_restore ;;
  *)
    echo "用法: $0 [random|restore]" >&2
    exit 2
    ;;
esac
