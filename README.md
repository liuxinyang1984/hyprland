# Hyprland 桌面配置

通过问答逐步重建的配置仓库，不直接搬迁旧目录。

## 目录

| 路径 | 用途 |
|------|------|
| `hypr/` | Hyprland 主配置（含 hyprlock、环境 overlay） |
| `hypr/env/` | 多机器差异说明与示例（如 `office.conf.example`） |
| `docs/` | 复现说明（如 `title` 分支的 `hyprbars-titlebar.md`） |
| `waybar/` | 状态栏（dark / light） |
| `wofi/` | 应用 / 命令启动器 |
| `scripts/` | 壁纸、音量、亮度、截图、布局切换等 |

## 分支

| 分支 | 说明 |
|------|------|
| `master` | 公共基线；家用 `env.conf`；布局快捷键、dwindle 选项 |
| `title` | `master` + hyprbars 标题栏（见 `docs/hyprbars-titlebar.md`） |
| `office` | `title` + 办公室 `env.conf` 与 topterm / special 脚本 |

## 常用快捷键（节选）

完整列表见 `hypr/keybinds.conf`。

| 快捷键 | 作用 |
|--------|------|
| `Super+Return` | 打开 foot |
| `Super+Alt+Return` | dwindle ↔ master 布局切换 |
| `Super+Ctrl+Return` | dwindle 横/竖分屏切换（需 `preserve_split = true`） |
| `Super+Alt+H/J/K/L` | 调整平铺窗口大小 |
| `Super+T` | 浮动 / 平铺 |
| `Super+Space` | Wofi 启动器 |
| `Super+V` | 剪贴板历史 |

## 当前进度

1. **快捷键** ✓（媒体键、截图、剪贴板、布局切换、resize；部分笔记本键仍延后）
2. 显示器 / overlay 骨架 ✓（`env.conf` 最后加载；办公室见 `office` 分支）
3. 外观 / 输入 / 启动项 ✓（hyprbars 见 `title`；手势、GTK/Qt 外观部分延后）
4. Waybar ✓
5. Wofi ✓
6. 脚本：壁纸（awww）、音量、亮度、截图、`toggle-layout.sh` ✓
7. 锁屏（hyprlock）✓；剪贴板历史（cliphist + Wofi）✓
8. 后续：foot server、zsh、install.sh 等

## 多环境（overlay）

公共配置在 `master`，**不依赖 env**；机器相关 **仅改 `hypr/env.conf`**。

`office` 分支 rebase `title` 后维护办公室 `env.conf` 与脚本。详见 `hypr/env/README.md`。

## 部署

将本仓库的 `hypr/` 链接或同步到 `~/.config/hypr` 后执行 `hyprctl reload`。

需要 hyprbars 时使用 `title` 或 `office` 分支，并按 `docs/hyprbars-titlebar.md` 安装插件与字体。
