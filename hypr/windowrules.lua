-- ============================================================
-- 窗口规则
-- 文档：https://wiki.hypr.land/configuring/core/rules/window-rules/
-- ============================================================

-- Chromium/Edge（原生 Wayland）悬停 tooltip：错误做成空 class+title 的短命
-- xdg_toplevel，会抢焦点并参与 tiling（闪一下消失；最大化被打回平铺）。
-- 社区绕过：https://github.com/hyprwm/Hyprland/discussions/14265
hl.window_rule({
    name = "empty-transient-tooltip",
    match = {
        class = "^()$",
        title = "^()$",
    },
    float = true,
    no_initial_focus = true,
    border_size = 0,
    rounding = 0,
    move = "cursor_x+8 cursor_y+20",
})

-- fcitx5 候选窗（XWayland）：special 工作区易被 Electron/微信盖住（能出字看不见框）
-- Hyprland #2439；pin + pseudo 稳定叠层
hl.window_rule({
    name = "fcitx-input-window",
    match = {
        title = "^(Fcitx5 Input Window)$",
    },
    float = true,
    pin = true,
    pseudo = true,
    no_focus = true,
    opaque = true,
    opacity = "1 override 1 override 1 override",
    border_size = 0,
    no_shadow = true,
    no_blur = true,
})

-- 微信主窗：减弱 activate 抢顶，减轻挡住弹出框；保持平铺（不进下方 non-main float）
hl.window_rule({
    name = "wechat-main",
    match = {
        class = "^([Ww]echat)$",
        title = "^(Weixin)$",
    },
    suppress_event = "activate activatefocus",
})

-- 微信非主窗一律浮动（菜单/表情保持应用给的位置，不 center）
-- focus_on_activate：主窗 activate 后仍允许次级窗被抬起/聚焦（减轻 special 上被盖住）
hl.window_rule({
    name = "wechat-non-main-float",
    match = {
        class = "^([Ww]echat)$",
        title = "negative:^(Weixin)$",
    },
    float = true,
    focus_on_activate = true,
})

-- 大块次级窗再居中（title=wechat 的菜单/表情不会命中）
hl.window_rule({
    name = "wechat-secondary-center",
    match = {
        class = "^([Ww]echat)$",
        title = "^(Chat History|Photos and Videos|Moments|Settings).*",
    },
    center = true,
})

-- 微信右键/下拉：title 小写 wechat
-- stay_focused：主窗常立刻抢回焦点导致菜单被盖住；点击也不提升时尤需
-- border_size=0 / no_blur / no_shadow：不渲染装饰，避免衬出窗体透明外圈
hl.window_rule({
    name = "wechat-transient-popup",
    match = {
        class = "^([Ww]echat)$",
        title = "^(wechat)$",
    },
    stay_focused = true,
    focus_on_activate = true,
    border_size = 0,
    no_blur = true,
    no_shadow = true,
})

-- 微信小程序：class 为空、title=WeChat（不进 class=wechat 那条）
hl.window_rule({
    name = "wechat-miniprogram-float",
    match = {
        class = "^()$",
        title = "^(WeChat)$",
    },
    float = true,
    center = true,
    focus_on_activate = true,
})

-- 文件/保存对话框：扣除 reserved 区域居中，固定尺寸
hl.window_rule({
    name = "portal-file-dialog",
    match = {
        class = [[^([Xx]dg-desktop-portal-gtk|org\.freedesktop\.impl\.portal\.desktop\.gtk)$]],
    },
    float = true,
    size = { 800, 480 },
    center = true,
})

hl.window_rule({
    name = "chromium-file-dialog",
    match = {
        class = "^([Mm]icrosoft-edge|[Gg]oogle-chrome)$",
        title = "^([Oo]pen|[Ss]ave|[Cc]hoose|[Ss]elect).*",
    },
    float = true,
    size = { 800, 480 },
    center = true,
})

-- 微信 Open/Save：与 Edge/portal 同尺寸；stay_focused 减轻被主窗盖住
hl.window_rule({
    name = "wechat-file-dialog",
    match = {
        class = "^([Ww]echat)$",
        title = "^([Oo]pen|[Ss]ave|[Cc]hoose|[Ss]elect).*",
    },
    float = true,
    size = { 800, 480 },
    center = true,
    stay_focused = true,
    focus_on_activate = true,
})
