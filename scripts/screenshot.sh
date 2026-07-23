#!/usr/bin/env bash
# ============================================================
# 截图（grim + slurp + wl-copy + swappy）
# 用法：
#   screenshot.sh --now   # 全屏
#   screenshot.sh --win   # 当前窗口
#   screenshot.sh --area  # 框选区域
# 保存至 ~/Pictures/Screenshots/，并复制到剪贴板；swappy 预览/标注
# ============================================================
set -euo pipefail

if command -v xdg-user-dir >/dev/null 2>&1; then
  base_dir="$(xdg-user-dir PICTURES)"
else
  base_dir="$HOME/Pictures"
fi

dir="$base_dir/Screenshots"
file="Screenshot_$(date +%Y-%m-%d-%H-%M-%S)_${RANDOM}.png"

notify() {
  notify-send -h string:x-canonical-private-synchronous:shot-notify -u low \
    "截图" "$1" 2>/dev/null || true
}

ensure_dir() {
  mkdir -p "$dir"
}

# 截图 → 存盘 + 剪贴板 → swappy 预览
capture() {
  local -a grim_args=("$@")
  ensure_dir
  (cd "$dir" && grim "${grim_args[@]}" - | tee "$file" | wl-copy)
  notify "已复制到剪贴板"
  swappy -f "$dir/$file"
  if [[ -f "$dir/$file" ]]; then
    notify "已保存"
  else
    notify "已取消"
  fi
}

shot_now() {
  capture
}

shot_win() {
  local geom
  geom=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
  if [[ -z "$geom" || "$geom" == "null,null nullxnull" ]]; then
    notify "无活动窗口"
    exit 1
  fi
  capture -g "$geom"
}

shot_area() {
  local region
  region=$(slurp -b 1B1F28CC -c E06B74ff -s C778DD0D -w 2) || exit 0
  capture -g "$region"
}

case "${1:-}" in
  --now)  shot_now ;;
  --win)  shot_win ;;
  --area) shot_area ;;
  *)
    echo "用法: $0 [--now|--win|--area]" >&2
    exit 2
    ;;
esac
