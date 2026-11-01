-- ============================================================
-- Hyprland 主配置入口（Lua，Hyprland 0.57+）
-- 文档：https://wiki.hypr.land/configuring/
-- ============================================================

-- 仓库内 scripts/（与 waybar/wofi 并列；勿与旧的 ~/.config/scripts 混淆）
-- 若移动本仓库路径，请同步修改此变量。
scriptsDir = os.getenv("HOME") .. "/git/hyprland/scripts"

-- --- 分文件（公共先加载；env.lua 在文件末尾 require，便于覆盖）---
require("workspaces")
require("keybinds")
require("exec")
require("windowrules")

-- ------------------------------------------------------------
-- 常规：边框、间隙、布局
-- ------------------------------------------------------------
hl.config({
    general = {
        border_size = 5,
        gaps_in = 3,
        gaps_out = 6,
        -- 活动边框：单色（各环境可在 env.lua 覆盖）
        col = {
            active_border = "rgb(0099ff)",
            inactive_border = "rgb(6c7086)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },

    -- ------------------------------------------------------------
    -- 装饰：圆角、透明、模糊
    -- ------------------------------------------------------------
    decoration = {
        rounding = 5,
        active_opacity = 0.9,
        inactive_opacity = 0.8,
        fullscreen_opacity = 1.0,

        blur = {
            enabled = true,
            size = 3,
            passes = 3,
            new_optimizations = true,
            xray = true,
            ignore_opacity = true,
        },

        dim_inactive = false,
        dim_strength = 0.3,
    },

    -- ------------------------------------------------------------
    -- 动画（简单默认曲线，不使用自定义 bezier）
    -- ------------------------------------------------------------
    animations = {
        enabled = true,
    },

    -- ------------------------------------------------------------
    -- 输入设备
    -- 约定：与 Hyprland 默认相同的项不写；仅保留有意偏离默认的设置。
    -- ------------------------------------------------------------
    input = {
        -- I4 float_switch_override_focus：现用默认 1（切换平铺/浮动时焦点跟随光标下窗口）
        -- 原配置为 0（切换时不改焦点）；若手感不对可改回：
        -- float_switch_override_focus = 0

        touchpad = {
            -- 1/2/3 指按下映射为左/右/中键（默认关；原配置为开）
            clickfinger_behavior = true,
            -- 关闭轻触点击，需按下触控板（默认开；原配置为关）
            tap_to_click = false,
        },
    },

    -- ------------------------------------------------------------
    -- 杂项 misc / dwindle / xwayland
    -- 约定：默认不写；仅保留有意偏离默认的项。
    -- ------------------------------------------------------------
    misc = {
        -- 锁屏进程异常退出后可恢复（否则可能卡在无法解锁的 session-lock）
        allow_session_lock_restore = true,
    },

    -- 分数缩放（如 1.25）下：XWayland 应用先以 1× 绘制，再由合成器缩放，
    -- 避免应用自缩放与合成器叠乘导致糊字/碎字（微信等）。需配合应用侧 QT_SCALE_FACTOR。
    xwayland = {
        force_zero_scaling = true,
    },

    -- dwindle：上下/左右由 WM 按容器比例决定；新窗口在右/下；分叉跟随焦点窗口
    dwindle = {
        force_split = 2,
        preserve_split = true,
        use_active_for_splits = true,
        special_scale_factor = 0.8,
    },
})

-- --- 手势（I10，延后）---
-- 以后可最小启用三指切工作区，再对照现网调距离/反转等：
-- hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "default" })

-- 本机 overlay（monitor / DPI / 可选颜色与 workspace 绑定）；须最后加载才能覆盖上文
require("env")
