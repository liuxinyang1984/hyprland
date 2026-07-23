# Hyprland 桌面配置

通过问答逐步重建的配置仓库，不直接搬迁旧目录。

## 目录

| 路径 | 用途 |
|------|------|
| `hypr/` | Hyprland 主配置（含 hyprlock、环境 overlay） |
| `hypr/env/` | 多机器差异说明与示例（如 `office.conf.example`） |
| `waybar/` | 状态栏（dark / light） |
| `wofi/` | 应用 / 命令启动器 |
| `scripts/` | 壁纸、音量、亮度等脚本 |

## 当前进度

1. **快捷键**（进行中：媒体键、截图 / 剪贴板已接；部分笔记本键仍延后）
2. 显示器 / overlay 骨架 ✓（`env.conf` 最后加载；办公室差异见 `office` 分支）
3. 外观 / 输入 / 启动项（基础已有；手势、GTK/Qt 外观延后）
4. Waybar ✓
5. Wofi ✓
6. 脚本：壁纸（awww）、音量、亮度、截图 ✓
7. 锁屏（hyprlock，暂写死 eDP-1；多环境方案推后）✓；剪贴板历史（cliphist + Wofi）✓
8. 后续：foot、zsh、办公室 env 落地等

## 多环境（overlay）

公共配置在 `main`，**不依赖 env**；机器相关 **仅改 `hypr/env.conf`**（DPI、monitor、可选 workspace 绑定）。

`office` 分支还可改 **`waybar/config`**（如 `"output"`、双栏）；见 `waybar/office.config.example`。

`workspaces.conf` 暂为空占位；workspace 绑定写在各环境 `env.conf`。

`office` 分支 rebase `main` 后只维护 `env.conf`。详见 `hypr/env/README.md`。

## 部署

将本仓库的 `hypr/` 链接或同步到 `~/.config/hypr` 后执行 `hyprctl reload`。具体 `install.sh` 稍后补充。
