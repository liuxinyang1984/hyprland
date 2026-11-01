-- ============================================================
-- 环境 overlay — ThinkPad X1C（eDP-1 + headless）
-- ============================================================

-- --- DPI（scale 1.25 → 120）---
hl.on("hyprland.start", function()
    hl.exec_cmd("echo \"Xft.dpi: 120\" | xrdb -merge")
end)

-- --- 本机显示器 ---
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1.25 })
hl.monitor({ output = "headless", mode = "1920x1080@120", position = "auto", scale = 2 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1.25 })

-- --- 工作区：主屏 1–5，headless 6–10（Super+0 → 10）---
hl.workspace_rule({ workspace = "1", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "2", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "3", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "4", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "5", monitor = "eDP-1" })
hl.workspace_rule({ workspace = "6", monitor = "headless" })
hl.workspace_rule({ workspace = "7", monitor = "headless" })
hl.workspace_rule({ workspace = "8", monitor = "headless" })
hl.workspace_rule({ workspace = "9", monitor = "headless" })
hl.workspace_rule({ workspace = "10", monitor = "headless" })

-- --- 蓝色主题 ---
hl.config({
    general = {
        col = {
            active_border = "rgb(0099ff)",
        },
    },
})
