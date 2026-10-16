# Edge / Chrome 双屏中文输入

本页记录桌面机上 **fcitx5 + 双屏 + Edge/Chrome** 能在两块屏都输入中文的组合。不要靠聊天记录。

权威来源：本文件 + `hypr/env.conf`（`desktop` 分支）+ 本机 `~/.local/share/applications/` 里的桌面项（桌面项不在本仓库）。

---

## 现象

同一个 Edge 或 Chrome 开两个窗口，分别放在左右屏时：只有一边能打中文，另一边英文正常、中文不进字。

本机布局：左屏 Dell `DP-2`（工作区 6–10，scale 1），右屏 ASUS `DP-1`（工作区 1–5，scale 1.25）。

---

## 原因（两件都要避开）

### 1. 左屏负坐标

`xwayland.force_zero_scaling = true`（`hypr/hyprland.conf`）时，Hyprland 若把左屏放在负坐标（例如 `DP-2 @ -1640x0`），XWayland / `xrandr` 会按自己的规则重排屏幕。Wayland 坐标和 X11 坐标对不上，fcitx 焦点会只在一侧正常。

左屏必须从 `0x0` 起排，主屏接在它右边。见 `hypr/env.conf`：

```conf
monitor = DP-2, preferred, 0x0, 1
monitor = DP-1, preferred, 1600x0, 1.25
monitor = , preferred, auto, 1.25
```

`1600` 是 DP-2 在 scale 1 下的逻辑宽度。改分辨率后要按实际逻辑宽度重算，不要改回负坐标。

### 2. Chromium 同时用 `--gtk-version=4` 和 `--enable-wayland-ime`

`--gtk-version=4` 走 Wayland **text-input-v3**。Hyprland 上这个协议在多窗口时经常只有一个窗口能输入中文（分数缩放的那块屏更容易表现为「打不出字」）。

Hyprland 支持 **text-input-v1**。浏览器只用 v1：保留 `--enable-wayland-ime`，加上 `--wayland-text-input-version=1`，不要加 `--gtk-version=4`。

全局 `GTK_IM_MODULE=fcitx`（`hypr/exec.conf`）是给 GTK / X11 用的。原生 Wayland 的 Edge/Chrome 启动时要清掉 `GTK_IM_MODULE` 和 `QT_IM_MODULE`，避免和 wayland-ime 抢。微信等 X11 程序继续用全局变量，不要为了浏览器删掉 `exec.conf` 里那几行。

---

## 桌面项（本机，不在 git 里）

改完必须**完全退出**浏览器再从启动器打开。已经在跑的进程不会吃到新参数。Chrome 要用名为 **Google Chrome(Wayland)** 的项，不要用系统默认的 X11 项。

`~/.local/share/applications/microsoft-edge.desktop`（新建窗口、InPrivate 同样带这些参数；InPrivate 再加 `--inprivate`）：

```desktop
Exec=env -u GTK_IM_MODULE -u QT_IM_MODULE XDG_SESSION_TYPE=wayland /usr/bin/microsoft-edge-stable --ozone-platform=wayland --enable-features=UseOzonePlatform --enable-wayland-ime --wayland-text-input-version=1 %U
```

`~/.local/share/applications/google-chrome-wayland.desktop`（本机主项还带 socks 代理；新建窗口不必重复代理参数）：

```desktop
Exec=env -u GTK_IM_MODULE -u QT_IM_MODULE XDG_SESSION_TYPE=wayland /usr/bin/google-chrome-stable --proxy-server="socks5://127.0.0.1:1080" --ozone-platform=wayland --enable-features=UseOzonePlatform --enable-wayland-ime --wayland-text-input-version=1 %U
```

---

## 验收

1. `hyprctl monitors`：DP-2 在 `0x0`，DP-1 在 `1600x0`，scale 分别是 1 和 1.25。
2. 浏览器主进程命令行含 `--enable-wayland-ime` 和 `--wayland-text-input-version=1`，不含 `--gtk-version=4`。
3. `tr '\0' '\n' < /proc/<pid>/environ` 里没有 `GTK_IM_MODULE` / `QT_IM_MODULE`。
4. 左右屏各一个窗口，两边都能打中文。

---

## 不要做的事

- 把左屏改回负坐标来「看起来在左边」。
- 为了对齐外观重新加上 `--gtk-version=4`（会回到多窗口只有一边能输入）。
- 只改显示器后不重启浏览器。
