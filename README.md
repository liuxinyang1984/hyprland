# Hyprland 桌面配置

通过问答逐步重建的配置仓库，不直接搬迁旧目录。

## 目录

| 路径 | 用途 |
|------|------|
| `hypr/` | Hyprland 主配置（含 hyprlock） |
| `waybar/` | 状态栏（dark / light） |
| `wofi/` | 应用 / 命令启动器 |
| `scripts/` | 壁纸、音量、亮度等脚本 |

## 当前进度

1. **快捷键**（进行中：媒体键、截图 / 剪贴板已接；部分笔记本键仍延后）
2. 显示器 / 外观 / 输入 / 启动项（基础已有；手势、GTK/Qt 外观延后）
3. Waybar ✓
4. Wofi ✓
5. 脚本：壁纸（awww）、音量、亮度、截图 ✓
6. 锁屏（hyprlock）✓；剪贴板历史（cliphist + Wofi）✓
7. 后续：foot、zsh 等

## 部署

将本仓库的 `hypr/` 链接或同步到 `~/.config/hypr` 后执行 `hyprctl reload`。具体 `install.sh` 稍后补充。
