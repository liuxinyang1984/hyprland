# 环境 overlay

多机器共用 `master` 上的快捷键、脚本、Waybar/Wofi；**仅 `hypr/env.lua` 随环境变化**。

| 内容 | 所在文件 |
|------|----------|
| DPI（`Xft.dpi` xrdb） | `env.lua` |
| 本机 `hl.monitor({ ... })`、兜底行 | `env.lua` |
| 可选 workspace → monitor 绑定 | `env.lua`（写死输出名） |
| 可选颜色覆盖（`hl.config({ general = ... })` 等） | `env.lua`（须在 `hyprland.lua` 末尾 require 之后才生效） |
| 公共 workspace 策略 | `workspaces.lua`（暂空，占位） |

`hyprland.lua` 加载顺序：

```
workspaces.lua → keybinds → exec → windowrules →（主文件 general/decoration/…）→ env.lua（最后）
```

公共文件 **不引用** `env.lua` 中的变量。`hyprlock.conf` 独立（仍为 hyprlang），暂不接入 overlay。

## 分支策略

- **master**：`env.lua` 为家用笔记本默认
- **office**：rebase master 后，改 **`env.lua`**（参考 `office.lua.example`），可选改 **`waybar/config`**（参考 `../waybar/office.config.example`）

## 部署

将 `hypr/` 链接到 `~/.config/hypr` 后 `hyprctl reload`（需 Hyprland 0.57+，入口为 `hyprland.lua`）。
