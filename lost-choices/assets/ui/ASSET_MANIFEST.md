# UI 资产清单

> 《迷途抉择》UI资产目录，Gilded Shadow视觉风格

---

## 目录结构

```
lost-choices/assets/ui/
├── backgrounds/        # 背景图
│   └── bg_main_menu.jpg
├── buttons/            # 按钮组件
│   ├── btn_primary_normal.png
│   ├── btn_primary_hover.png
│   ├── btn_primary_pressed.png
│   ├── btn_secondary_normal.png
│   ├── btn_play.png
│   ├── btn_pause.png
│   └── choice_card_*.png (4个状态)
├── icons/              # 图标 (SVG矢量)
│   └── icon_*.svg (9个)
└── panels/             # 面板组件
    ├── dialog_panel.png
    ├── subtitle_panel.png
    ├── save_slot.png
    ├── progress_bg.png
    ├── progress_fill.png
    ├── slider_bg.png
    ├── slider_fill.png
    └── slider_handle.png
```

---

## 资产列表

### 背景图 (`backgrounds/`)

| 文件名 | 尺寸 | 用途 |
|--------|------|------|
| bg_main_menu.jpg | 1920×1080 | 主菜单背景 |

### 按钮 (`buttons/`)

| 文件名 | 尺寸 | 状态 | 用途 |
|--------|------|------|------|
| btn_primary_normal.png | 280×60 | 正常 | 主按钮 |
| btn_primary_hover.png | 280×60 | 悬停 | 主按钮 |
| btn_primary_pressed.png | 280×60 | 按下 | 主按钮 |
| btn_secondary_normal.png | 280×60 | 正常 | 次要按钮 |
| btn_play.png | 280×60 | 正常 | 播放按钮 |
| btn_pause.png | 280×60 | 正常 | 暂停按钮 |

### 选项卡片 (`buttons/`)

| 文件名 | 尺寸 | 状态 |
|--------|------|------|
| choice_card_normal.png | 280×60 | 正常 |
| choice_card_hover.png | 280×60 | 悬停 |
| choice_card_selected.png | 280×60 | 选中 |
| choice_card_locked.png | 280×60 | 锁定 |

### 图标 (`icons/`)

| 文件名 | 用途 |
|--------|------|
| icon_menu.svg | 菜单 |
| icon_settings.svg | 设置 |
| icon_save.svg | 存档 |
| icon_load.svg | 读档 |
| icon_back.svg | 返回 |
| icon_close.svg | 关闭 |
| icon_lock.svg | 锁定 |
| icon_affection.svg | 好感度 |
| icon_volume.svg | 音量 |

### 面板 (`panels/`)

| 文件名 | 尺寸 | 用途 |
|--------|------|------|
| dialog_panel.png | 400×120 | 对话框 |
| subtitle_panel.png | 600×60 | 字幕面板 |
| save_slot.png | 300×80 | 存档槽位 |
| progress_bg.png | 200×12 | 进度条背景 |
| progress_fill.png | 200×12 | 进度条填充 |
| slider_bg.png | 200×8 | 滑块背景 |
| slider_fill.png | 200×8 | 滑块填充 |
| slider_handle.png | 24×24 | 滑块把手 |

---

## 配色方案

| 颜色名称 | 色值 | 用途 |
|----------|------|------|
| 金色深 | #D4A574 | 按钮渐变起始 |
| 金色浅 | #E8C99B | 按钮渐变结束 |
| 背景深 | #1A1A2E | 面板/按钮背景 |
| 背景最深 | #0F0F1A | 主背景 |
| 文字深 | #0A0A0A | 按钮文字 |

---

## Godot 引用路径

```gdscript
# 按钮
const BTN_PRIMARY_NORMAL = "res://assets/ui/buttons/btn_primary_normal.png"
const BTN_PRIMARY_HOVER = "res://assets/ui/buttons/btn_primary_hover.png"
const BTN_PRIMARY_PRESSED = "res://assets/ui/buttons/btn_primary_pressed.png"

# 图标
const ICON_MENU = "res://assets/ui/icons/icon_menu.svg"
const ICON_SETTINGS = "res://assets/ui/icons/icon_settings.svg"

# 面板
const PANEL_DIALOG = "res://assets/ui/panels/dialog_panel.png"

# 背景
const BG_MAIN_MENU = "res://assets/ui/backgrounds/bg_main_menu.jpg"
```

---

**创建日期**: 2026-02-22
**设计风格**: Gilded Shadow
**资产总数**: 28个
