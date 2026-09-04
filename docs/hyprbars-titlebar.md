# 复现：hyprbars 标题栏外观

本页目标：在**没有历史对话**的情况下，把机器恢复到与 `title` 分支（及基于其的 `office` 分支）一致的标题栏 / 字体 / 切角边框效果。

权威来源：本仓库 `hypr/` 配置 + 本文件。不要依赖聊天记录。

配置目录约定：`~/.config/hypr` → 本仓库 `hypr/`（symlink 或同步）。

---

## 复现后应呈现的效果

| 项目 | 期望 |
|------|------|
| 窗口边框 | `border_size = 5`，活动色 `rgb(40a02b)`，非活动 `rgb(6c7086)` |
| 圆角 | `rounding = 4`，`rounding_power = 1.0`（直角切角） |
| 标题栏 | hyprbars 开启；**默认不显示**；白名单程序才显示 |
| 标题文字 | 字体 `Saira Condensed Thin`，字号 18，`bold`，左对齐，`bar_text_y_offset = -2` |
| 非激活标题栏底色 | `rgb(6c7086)`（windowrule） |
| 白名单示例 | foot / kitty / Alacritty / ghostty / qutebrowser / zathura / scrcpy |
| Waybar | 顶栏自启 |

---

## 仓库内已固化的配置

| 路径 | 用途 |
|------|------|
| `hypr/hyprland.conf` | `decoration` + `plugin { hyprbars { } }`；活动边框色与 `bar_color` 一致 |
| `hypr/windowrules.conf` | `hyprbars-default-off`；`source hyprbars-show.conf`；`hyprbars-inactive` |
| `hypr/hyprbars-whitelist.txt` | **手改**白名单 class 列表 |
| `hypr/hyprbars-show.conf` | 由脚本生成，勿手改 |
| `scripts/hyprbars-whitelist.sh` | txt → show.conf |
| `hypr/exec.conf` | 启动时生成白名单规则后 `hyprpm reload` + `hyprctl reload` |

字体与 hyprbars 补丁**不在本分支仓库内**，需按下方手动步骤安装。

**重要：** `hyprbars:*` 窗口规则在插件 `.so` 加载后才可注册。必须 **先** `hyprpm reload`，**再** `hyprctl reload`（已写在 `exec.conf`；手动改规则后亦同）。

---

## 手动复现步骤

### A. 配置文件

确保 `~/.config/hypr` 使用本仓库 `hypr/`（checkout `title` 或 rebase 后的 `office`）。

关键片段（完整内容见仓库文件）：

**`general` + `decoration`**

```conf
general {
    col.active_border = rgb(40a02b)
    col.inactive_border = rgb(6c7086)
    ...
}

decoration {
    rounding = 4
    rounding_power = 1.0
    ...
}
```

**`plugin:hyprbars`**

```conf
plugin {
    hyprbars {
        enabled = true
        bar_height = 28
        bar_color = rgb(40a02b)
        col.text = rgb(ffffff)
        bar_text_size = 18
        bar_text_font = Saira Condensed Thin
        bar_text_weight = bold
        bar_text_align = left
        bar_text_y_offset = -2
        bar_padding = 10
        bar_part_of_window = true
        bar_precedence_over_border = true
        bar_blur = true
        bar_title_enabled = true
    }
}
```

注意：`bar_text_font = Saira Condensed Thin` **不要加引号**（引号会进入族名导致匹配失败）。

**窗口规则（节选）**

```conf
# 默认不显示；白名单覆盖为显示（见 hyprbars-show.conf）
windowrule {
  name = hyprbars-default-off
  match:class = .*
  hyprbars:no_bar = on
}
source = ./hyprbars-show.conf

windowrule {
  name = hyprbars-inactive
  match:focus = 0
  hyprbars:bar_color = rgb(6c7086)
}
```

维护白名单：编辑 `hypr/hyprbars-whitelist.txt` → `scripts/hyprbars-whitelist.sh` → `hyprctl reload`（或 Super+Ctrl+Shift+R）。

**自启**

```conf
exec-once = $scriptsDir/hyprbars-whitelist.sh && hyprpm reload -n && hyprctl reload
exec-once = waybar
```

### B. 字体

从 [Google Fonts — Saira Condensed](https://fonts.google.com/specimen/Saira+Condensed) 下载 **Thin (100)** 字重，安装到用户字体目录：

```bash
mkdir -p ~/.local/share/fonts/SairaCondensed
cp SairaCondensed-Thin.ttf ~/.local/share/fonts/SairaCondensed/
fc-cache -f ~/.local/share/fonts
fc-match 'Saira Condensed Thin'
```

### C. hyprbars 插件

构建依赖：`cmake`、`g++`、`pkg-config`、`git`、`make`、`hyprpm`。

```bash
export http_proxy=... https_proxy=... ALL_PROXY=...   # 访问 GitHub 困难时按需设置
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins   # 已添加可忽略错误
hyprpm enable hyprbars
hyprpm reload -n && hyprctl reload
```

### D. `bar_text_y_offset` 补丁（可选但推荐）

上游 hyprbars **没有** `bar_text_y_offset`；本配置使用该键时需手动打补丁并覆盖 hyprpm 编译产物。

**plugins 检出 pin**（与上次验证一致；升级 Hyprland 后可能需更新）：

```
7644cecdb947060682891a0db2a0cdc5c0b9e704
```

**获取补丁**（修改 `barDeco.cpp`、`globals.hpp`、`main.cpp` 三处，增加 `bar_text_y_offset` 配置项并在渲染时应用垂直偏移）：

```bash
git show origin/title:patches/hyprbars-bar-text-y-offset.patch > /tmp/hyprbars-bar-text-y-offset.patch
```

若本地无历史提交，可从 GitHub 提交 `e2b73d6` 的 `patches/hyprbars-bar-text-y-offset.patch` 下载同等内容。

**编译并安装 patched `.so`：**

```bash
PIN=7644cecdb947060682891a0db2a0cdc5c0b9e704
USER=$(id -un)
HEADERS=/var/cache/hyprpm/$USER/headersRoot/share/pkgconfig
PLUGINS=/var/cache/hyprpm/$USER/hyprland-plugins

git clone https://github.com/hyprwm/hyprland-plugins.git /tmp/hyprland-plugins
git -C /tmp/hyprland-plugins fetch --depth 1 origin "$PIN"
git -C /tmp/hyprland-plugins checkout "$PIN"
git -C /tmp/hyprland-plugins apply /tmp/hyprbars-bar-text-y-offset.patch

export PKG_CONFIG_PATH="$HEADERS:$PKG_CONFIG_PATH"
make -C /tmp/hyprland-plugins/hyprbars all
sudo cp -f /tmp/hyprland-plugins/hyprbars/hyprbars.so "$PLUGINS/hyprbars.so"

hyprpm reload -n && hyprctl reload
```

若不需要垂直微调，可跳过 **D**，并从 `hyprland.conf` 删除 `bar_text_y_offset` 行。

升级 Hyprland / `hyprpm update` 后，若偏移失效，按 **D** 重打补丁（pin 可能需随 plugins 提交更新）。

### E. 重启 Hyprland

装字体或换机后：**重启会话**。仅 `hyprctl reload` 往往不够。

改 `windowrules.conf` 中 hyprbars 规则后：先 `hyprpm reload -n && hyprctl reload`，已开窗口需重开或等规则刷新。

---

## 验收命令

```bash
hyprctl plugins list | grep -i hyprbars
hyprctl getoption decoration:rounding              # int: 4
hyprctl getoption decoration:rounding_power        # float: 1.0
hyprctl getoption general:col.active_border        # 含 40a02b
hyprctl getoption plugin:hyprbars:bar_text_font    # Saira Condensed Thin
hyprctl getoption plugin:hyprbars:bar_text_size    # 18
hyprctl getoption plugin:hyprbars:bar_text_weight  # 700 (bold)
hyprctl getoption plugin:hyprbars:bar_text_y_offset # -2（补丁生效时）
fc-match 'Saira Condensed Thin'
pgrep -a waybar
hyprctl layers | grep -i waybar
```

拉丁标题应呈窄体细字伪粗；中文标题会回退系统 CJK（预期行为）。

---

## 已知限制

- 不能按角设置不同 `rounding` / `rounding_power`
- 不能单独加厚上边框
- hyprbars 不能把标题强制全大写
- 上游无 `bar_text_y_offset`；需 **D** 补丁提供
- 新字体必须重启 Hyprland 才稳定生效
- 标题文字在 `active_opacity < 1` 或 `bar_blur = true` 时可能略灰或带背景色（非字体损坏）

---

## 给后续 Agent 的最短指令

> checkout `title`（或 `office`），保证 `~/.config/hypr` 指向本仓库 `hypr/`，按本文件 **B–E** 安装字体、启用 hyprbars、可选打 y_offset 补丁，重启 Hyprland，并用「验收命令」核对。
