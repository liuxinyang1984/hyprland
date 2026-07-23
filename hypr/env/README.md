# 环境 overlay

多机器共用 `main` 上的快捷键、脚本、Waybar/Wofi；**仅 `hypr/env.conf` 随环境变化**。

| 内容 | 所在文件 |
|------|----------|
| DPI（`Xft.dpi` xrdb） | `env.conf` |
| 本机 `monitor = …`、兜底行 | `env.conf` |
| 可选 workspace → monitor 绑定 | `env.conf`（写死输出名） |
| 公共 workspace 策略 | `workspaces.conf`（暂空，占位） |

`hyprland.conf` 加载顺序：

```
workspaces.conf → keybinds → exec → windowrules → env.conf（最后）
```

公共文件 **不引用** `env.conf` 中的变量。`hyprlock.conf` 独立，暂不接入 overlay。

## 分支策略

- **main**：`env.conf` 为家用笔记本默认
- **office**：rebase main 后，改 **`env.conf`**（参考 `office.conf.example`），可选改 **`waybar/config`**（参考 `../waybar/office.config.example`）

## 部署

将 `hypr/` 链接到 `~/.config/hypr` 后 `hyprctl reload`。
