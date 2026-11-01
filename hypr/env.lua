-- ============================================================
-- 环境 overlay — DP-1 主屏 + DP-2 在左（scale 1.25）
-- ============================================================

hl.on("hyprland.start", function()
    hl.exec_cmd("echo \"Xft.dpi: 120\" | xrdb -merge")
end)

-- 左屏必须从 0x0 起排（勿用负坐标）：否则 XWayland/xrandr 会重排屏幕，
-- 导致 fcitx 在一侧显示器失效。
-- DP-2 scale 1 → 逻辑宽 1600；DP-1 scale 1.25 接在右侧。
hl.monitor({ output = "DP-2", mode = "preferred", position = "0x0", scale = 1 })
hl.monitor({ output = "DP-1", mode = "preferred", position = "1600x0", scale = 1.25 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25 })

-- 主屏 1–5，左屏 6–10
hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2" })
hl.workspace_rule({ workspace = "7", monitor = "DP-2" })
hl.workspace_rule({ workspace = "8", monitor = "DP-2" })
hl.workspace_rule({ workspace = "9", monitor = "DP-2" })
hl.workspace_rule({ workspace = "10", monitor = "DP-2" })
