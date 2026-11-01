-- ============================================================
-- 快捷键绑定
-- 说明：本文件通过问答逐项建立；未确认的绑定请勿擅自添加。
-- 文档：https://wiki.hypr.land/configuring/core/binds/
-- ============================================================

local mainMod = "SUPER"

-- ------------------------------------------------------------
-- 1. 窗口与会话
-- ------------------------------------------------------------

-- 打开终端（foot）
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("foot"))

-- 关闭当前窗口
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- 强制杀窗（进入点选杀窗模式）
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl kill"))

-- 退出 Hyprland
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())

-- 切换浮动 / 平铺
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- dwindle：切换当前容器横/竖分屏（需 preserve_split = true）
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("togglesplit"))

-- dwindle ↔ master 布局切换
hl.bind(mainMod .. " + ALT + Return", hl.dsp.exec_cmd(scriptsDir .. "/toggle-layout.sh"))

-- 伪全屏（最大化类，保留间隙/栏等行为依版本而定）
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- 真全屏
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- 重载 Hyprland 配置
hl.bind(mainMod .. " + CTRL + SHIFT + R", hl.dsp.reload_config())

-- ------------------------------------------------------------
-- 2. 焦点与移动
-- ------------------------------------------------------------

-- 移动焦点（HJKL；到边缘时跨屏，容忍屏间空隙）
hl.bind(mainMod .. " + H", hl.dsp.exec_cmd(scriptsDir .. "/movefocus-cross.sh l"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(scriptsDir .. "/movefocus-cross.sh r"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(scriptsDir .. "/movefocus-cross.sh u"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd(scriptsDir .. "/movefocus-cross.sh d"))

-- 浮动 ↔ 平铺 焦点层切换（movefocus 不跨这两层）
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(
    [[sh -c 'if [ "$(hyprctl activewindow -j | jq -r .floating)" = "true" ]; then hyprctl dispatch focuswindow tiled; else hyprctl dispatch focuswindow floating; fi']]
))

-- 切换焦点显示器（贴边双屏用 l/r；有空隙的办公室在 env.lua 里 unbind 后改绑输出名）
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + less", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + greater", hl.dsp.focus({ monitor = "r" }))

-- 移动窗口（HJKL）
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

-- 调整窗口大小（按住重复；Super+Alt 与旧 hyprconfig 一致）
hl.bind(mainMod .. " + ALT + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- 鼠标：Super + 左键拖移 / 右键缩放
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ------------------------------------------------------------
-- 3. 工作区
-- ------------------------------------------------------------

-- 切换到工作区 1–10（0 表示 10）
-- 将窗口带到目标工作区并跟随切换
-- 将窗口静默移到目标工作区（不跟随）
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = true }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- 相对切换：下一个 / 上一个已有工作区
-- e±1 会跨屏跳到其它监视器上的工作区；m±1 仅当前屏
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "m-1" }))

-- 多显示器：在显示器之间切换工作区
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "m-1" }))

-- --- 具名特殊工作区：BackSpace ---
-- Super：切换显示；Shift：静默移入；Ctrl：移入并跟随
hl.bind(mainMod .. " + BackSpace", hl.dsp.workspace.toggle_special("backspace"))
hl.bind(mainMod .. " + SHIFT + BackSpace", hl.dsp.window.move({ workspace = "special:backspace", follow = false }))
hl.bind(mainMod .. " + CTRL + BackSpace", hl.dsp.window.move({ workspace = "special:backspace", follow = true }))

-- --- 具名特殊工作区：backslash ---
hl.bind(mainMod .. " + backslash", hl.dsp.workspace.toggle_special("backslash"))
hl.bind(mainMod .. " + SHIFT + backslash", hl.dsp.window.move({ workspace = "special:backslash", follow = false }))
hl.bind(mainMod .. " + CTRL + backslash", hl.dsp.window.move({ workspace = "special:backslash", follow = true }))

-- ------------------------------------------------------------
-- 4. 媒体与笔记本功能键
-- 状态：基础媒体键已接；键盘背光、触控板、飞行模式、合盖仍延后
-- ------------------------------------------------------------

-- 锁屏（hyprlock；空闲自动锁未启用）
-- 仅 eDP-1 + 纯色背景（见 hyprlock.conf）；勿对 headless 截屏模糊。
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))

-- 休眠键 → 锁屏（与 Ctrl+Alt+L 相同）
hl.bind("XF86Sleep", hl.dsp.exec_cmd("hyprlock"))

-- 音量 / 麦克风（wpctl；步进 5%，与 Waybar 滚轮一致）
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --inc"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --dec"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(scriptsDir .. "/volume.sh --toggle-mic"), { locked = true })

-- 屏幕亮度（brightnessctl；步进 10%，与 Waybar 一致）
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/brightness.sh --inc"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/brightness.sh --dec"), { locked = true })

-- 媒体播放（playerctl）
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })

-- --- 延后（需问答确认后再加）---
-- 键盘背光：XF86KbdBrightnessUp/Down → brightnessKbd.sh
-- 触控板开关：XF86TouchpadToggle → 需 hyprctl devices 里的设备名
-- 飞行模式：XF86Rfkill
-- 合盖：switch:Lid Switch
-- ASUS 专用：XF86Launch1/3/4 → rog-control-center / asusctl

-- ------------------------------------------------------------
-- 5. 启动器 / 壁纸 / 截图 / 剪贴板等
-- ------------------------------------------------------------

-- Wofi 应用启动器（再按一次关闭）
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/wofi/launch.sh"))

-- Wofi 运行命令
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/wofi/launch-run.sh"))

-- 随机切换壁纸（awww）
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(scriptsDir .. "/wallpaper.sh random"))

-- 截图（grim + swappy；P 键避免与 paste 冲突故用 P）
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(scriptsDir .. "/screenshot.sh --now"))
hl.bind(mainMod .. " + ALT + P", hl.dsp.exec_cmd(scriptsDir .. "/screenshot.sh --win"))
hl.bind(mainMod .. " + SHIFT + ALT + P", hl.dsp.exec_cmd(scriptsDir .. "/screenshot.sh --area"))

-- 剪贴板历史（cliphist + Wofi）
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(os.getenv("HOME") .. "/.config/wofi/launch-clip.sh"))
