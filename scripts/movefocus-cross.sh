#!/usr/bin/env bash
# movefocus；同屏该方向已无窗口时跨到几何邻屏（容忍屏间空隙）
set -euo pipefail

dir=${1:-}
case "$dir" in
  l | r | u | d) ;;
  *)
    echo "usage: $0 l|r|u|d" >&2
    exit 1
    ;;
esac

# 同工作区、同屏是否还有「更靠该方向」的窗口；没有则跨屏
cross=$(
  python3 - "$dir" <<'PY'
import json, subprocess, sys

dir = sys.argv[1]
active = json.loads(subprocess.check_output(["hyprctl", "activewindow", "-j"], text=True))
if not active.get("address"):
    print("1")
    raise SystemExit
clients = json.loads(subprocess.check_output(["hyprctl", "clients", "-j"], text=True))

ws = active.get("workspace", {}).get("id")
mon = active.get("monitor")
ax = active["at"][0] + active["size"][0] / 2
ay = active["at"][1] + active["size"][1] / 2
# 忽略浮点抖动
eps = 8

def further(c):
    cx = c["at"][0] + c["size"][0] / 2
    cy = c["at"][1] + c["size"][1] / 2
    if dir == "l":
        return cx < ax - eps
    if dir == "r":
        return cx > ax + eps
    if dir == "u":
        return cy < ay - eps
    if dir == "d":
        return cy > ay + eps
    return False

for c in clients:
    if c.get("address") == active.get("address"):
        continue
    if c.get("monitor") != mon:
        continue
    if c.get("workspace", {}).get("id") != ws:
        continue
    if not c.get("mapped") or c.get("hidden"):
        continue
    if further(c):
        print("0")
        raise SystemExit

print("1")
PY
)

if [[ "$cross" != "1" ]]; then
  hyprctl dispatch movefocus "$dir" >/dev/null
  exit 0
fi

neighbor=$(
  hyprctl monitors -j | python3 -c '
import json, sys
dir = sys.argv[1]
mons = json.load(sys.stdin)
cur = next((m for m in mons if m.get("focused")), None)
if cur is None:
    raise SystemExit
key = "x" if dir in ("l", "r") else "y"
ordered = sorted(mons, key=lambda m: (m[key], m["y"] if key == "x" else m["x"]))
idx = next(i for i, m in enumerate(ordered) if m["id"] == cur["id"])
if dir in ("l", "u") and idx > 0:
    print(ordered[idx - 1]["name"])
elif dir in ("r", "d") and idx + 1 < len(ordered):
    print(ordered[idx + 1]["name"])
' "$dir"
)

if [[ -n "${neighbor:-}" ]]; then
  hyprctl dispatch focusmonitor "$neighbor" >/dev/null
else
  # 无邻屏时仍走原生 movefocus（组/全屏等边角情况）
  hyprctl dispatch movefocus "$dir" >/dev/null
fi
