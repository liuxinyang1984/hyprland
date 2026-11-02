-- ============================================================
-- 环境 overlay — 办公室台式机（DP-1 + DVI-D-1 竖屏）
-- ============================================================

local mainMod = "SUPER"

-- --- DPI（scale 1.0 → 96）---
hl.on("hyprland.start", function()
    hl.exec_cmd('echo "Xft.dpi: 96" | xrdb -merge')
    -- 竖屏顶部分割区 pin 终端
    hl.exec_cmd(scriptsDir .. "/topterm.sh")
end)

-- --- 本机显示器（缩放 1.0）---
hl.monitor({ output = "DP-1", mode = "1920x1200", position = "0x0", scale = 1 })
-- 1940：与左屏留 20px 空隙，鼠标过界有阻尼（故切屏不能用 focusmonitor l/r）
hl.monitor({
    output = "DVI-D-1",
    mode = "1600x1200",
    position = "1940x0",
    scale = 1,
    transform = 1,
    -- 竖屏顶部分割：预留 300px（平铺从下方开始；与 topterm 高度独立）
    reserved = { top = 300, right = 0, bottom = 0, left = 0 },
})
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- --- 工作区：主屏 1–5，副屏 6–10 ---
hl.workspace_rule({ workspace = "1", monitor = "DP-1" })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DVI-D-1" })
hl.workspace_rule({ workspace = "7", monitor = "DVI-D-1" })
hl.workspace_rule({ workspace = "8", monitor = "DVI-D-1" })
hl.workspace_rule({ workspace = "9", monitor = "DVI-D-1" })
hl.workspace_rule({ workspace = "10", monitor = "DVI-D-1" })

-- --- special：left / right / backspace ---
hl.workspace_rule({ workspace = "special:left", monitor = "DP-1" })
hl.workspace_rule({ workspace = "special:right", monitor = "DVI-D-1" })
hl.workspace_rule({ workspace = "special:backspace", monitor = "DVI-D-1" })

hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd(scriptsDir .. "/toggle-special.sh DP-1 left"))
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "special:left", follow = false }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "special:left", follow = true }))

hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd(scriptsDir .. "/toggle-special.sh DVI-D-1 right"))
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "special:right", follow = false }))
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "special:right", follow = true }))

-- Super+Shift+,/. ：覆盖 keybinds 的 l/r（屏间有空隙时方向查找会失败）
hl.unbind(mainMod .. " + SHIFT + comma")
hl.unbind(mainMod .. " + SHIFT + period")
hl.unbind(mainMod .. " + SHIFT + less")
hl.unbind(mainMod .. " + SHIFT + greater")
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.focus({ monitor = "DP-1" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.focus({ monitor = "DVI-D-1" }))
hl.bind(mainMod .. " + SHIFT + less", hl.dsp.focus({ monitor = "DP-1" }))
hl.bind(mainMod .. " + SHIFT + greater", hl.dsp.focus({ monitor = "DVI-D-1" }))

-- backspace 仅右屏（覆盖 keybinds 里跟焦点屏走的 toggle_special）
hl.unbind(mainMod .. " + BackSpace")
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd(scriptsDir .. "/toggle-special.sh DVI-D-1 backspace"))

-- 竖屏顶部分割区：pin 浮动终端（始终可见；grave 聚焦）
hl.window_rule({
    name = "topterm-foot",
    match = { class = "^(topterm)$" },
    monitor = "DVI-D-1",
    pin = true,
    float = true,
    size = "(monitor_w - 10) 288",
    move = "5 5",
    rounding = 0,
    no_initial_focus = true,
    opacity = "1 override 1 override 1 override",
    animation = "slide top",
})

hl.bind(mainMod .. " + grave", hl.dsp.exec_cmd(scriptsDir .. "/topterm.sh --focus"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.exec_cmd(scriptsDir .. "/topterm.sh --focus"))

-- topterm 打开：slide top 幕布降落 + Q 弹
hl.curve("curtainBounce", { type = "bezier", points = { {0.28, 1.65}, {0.88, 1.0} } })
hl.animation({ leaf = "windows", enabled = false, speed = 1, bezier = "default" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "curtainBounce" })
hl.animation({ leaf = "fade", enabled = false, speed = 1, bezier = "default" })
hl.animation({ leaf = "fadeIn", enabled = false, speed = 1, bezier = "default" })
hl.animation({ leaf = "fadeSwitch", enabled = false, speed = 1, bezier = "default" })
hl.animation({ leaf = "windowsMove", enabled = false, speed = 1, bezier = "default" })
-- special 缩放（覆盖公共 dwindle.special_scale_factor）
hl.config({
    dwindle = {
        special_scale_factor = 0.9,
    },
})

-- 微信进 special:backspace；主窗 Weixin 仍平铺（float 在公共 windowrules）
hl.window_rule({
    name = "wechat-to-backspace",
    match = {
        class = "^([Ww]echat)$",
        title = "^(Weixin)$",
    },
    workspace = "special:backspace",
})

hl.window_rule({
    name = "wechat-miniprogram-to-backspace",
    match = {
        class = "^()$",
        title = "^(WeChat)$",
    },
    workspace = "special:backspace",
})

-- Xephyr → special:backslash，启动即最大化
hl.window_rule({
    name = "xephyr-to-backslash-maximize",
    match = { class = "^(Xephyr)$" },
    workspace = "special:backslash",
    maximize = true,
})
