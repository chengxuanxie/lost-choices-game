# 🖼️ 美术与资产阶段

> 本阶段负责游戏的视觉资产制作，包括角色、场景、UI等美术资源

---

## 📢 阶段状态

| 项目 | 内容 |
|------|------|
| **阶段状态** | 🟡 进行中 |
| **开始日期** | 2026-02-20 |
| **当前进度** | 75% |
| **阶段负责人** | UI设计师 / 视频导演 |

### ✅ 已完成工作

| 工作项 | 状态 | 说明 |
|--------|------|------|
| 美术风格指南 | ✅ | 视觉风格定义 |
| UI风格设计稿 | ✅ | UI组件规范 |
| AI视频制作指南 | ✅ | 即梦4.0生成流程 |
| 场景设定文档 | ✅ | 6个场景（含镜头分解） |
| 角色设定文档 | ✅ | 8个角色 |
| 场景参考图 | ✅ | 41张，已上传TOS |
| 角色参考图 | ✅ | 60张，已上传TOS |
| UI资产制作 | ✅ | 28个资产（SVG/PNG） |
| 对话脚本 | ✅ | 18个场景 |
| 视频镜头清单 | ✅ | 含分段方案 |

### 🎯 下一步工作

```
1. Godot着色器 - 编写视差、缩放、光影等场景特效
2. 关键帧生成 - 使用img_gen skill生成~200张关键帧
3. 短视频生成 - 使用video_gen skill生成~60个关键剧情视频
4. 场景组件 - 创建KeyframeScene组件
5. JSON更新 - 更新chapter_01.json使用混合格式
```

---

## 📁 文档列表

### 规范文档

| 文档 | 版本 | 状态 | 说明 |
|------|------|------|------|
| [美术风格指南](./01_美术风格指南.md) | v1.0 | ✅ 已定稿 | 视觉风格统一标准，包括色彩、材质、光影等 |
| [UI风格设计稿](./02_UI风格设计稿.md) | v1.0 | ✅ 已定稿 | UI视觉设计规范，包括配色、字体、组件等 |
| [AI视频制作指南](./03_AI视频制作指南.md) | v1.0 | ✅ 新建 | AI生成视频的流程和规范 |

### 场景设定文档 (`scenes/`)

> 每个场景一个文档，包含：视觉设定、镜头分解、关键帧需求、短视频Prompt

#### 第一章场景 (`scenes/ch1/`)

| 文档 | 状态 | 说明 |
|------|------|------|
| [SC-001 神秘房间](./scenes/ch1/sc_001_神秘房间.md) | ✅ 完成 | 主角醒来并探索的起始场景（已整合storyboards） |
| [SC-003 通讯室](./scenes/ch1/sc_003_通讯室.md) | ✅ 完成 | 与林晓薇首次接触 |
| [SC-004 走廊/通道](./scenes/ch1/sc_004_走廊通道.md) | ✅ 完成 | 连接区域的过渡场景 |
| [SC-005 白芷瑶房间](./scenes/ch1/sc_005_白芷瑶房间.md) | ✅ 完成 | 心理咨询师场景 |
| [SC-006 沈墨染画室](./scenes/ch1/sc_006_沈墨染画室.md) | ✅ 完成 | 艺术家场景 |
| [SC-007 出口区域](./scenes/ch1/sc_007_出口区域.md) | ✅ 完成 | 逃离/结局相关场景 |

### 对话脚本文档 (`scripts/`)

> 每个场景的对话文本、字幕时间轴、TTS配置

| 目录 | 状态 | 说明 |
|------|------|------|
| `scripts/ch1/` | ✅ 完成 | 18个场景对话脚本（内容待补充） |

### 角色视觉设定文档 (`characters/`)

> 每个角色一个文档，包含外貌、服装、表情、参考图Prompt等

| 文档 | 状态 | 说明 |
|------|------|------|
| [主角（玩家）](./characters/player.md) | ✅ 完成 | 第一人称视角，手部参考 |
| [林晓薇](./characters/lin_xiaowei.md) | ✅ 完成 | 调查记者 - 26岁 |
| [白芷瑶](./characters/bai_zhiyao.md) | ✅ 完成 | 心理咨询师 - 27岁 |
| [沈墨染](./characters/shen_moran.md) | ✅ 完成 | 艺术家 - 25岁 |
| [叶清寒](./characters/ye_qinghan.md) | ✅ 完成 | 前特工 - 26岁 |
| [江念](./characters/jiang_nian.md) | ✅ 完成 | 天才黑客 - 21岁 |
| [陈远航](./characters/chen_yuanhang.md) | ✅ 完成 | 私家侦探 - 32岁 |
| [苏雅琳](./characters/su_yalin.md) | ✅ 完成 | 企业高管 - 28岁 |

---

## 📂 美术资产目录

> 资产描述文件使用 `.md` 格式，由美术团队根据描述生成实际资产

### 场景参考图 (`assets/scenes/`)

> AI视频生成的场景参考图

| 目录 | 状态 | 说明 |
|------|------|------|
| `assets/scenes/ch1/` | ⏳ 待生成 | 第一章场景参考图 |

### 角色参考图 (`assets/characters/`)

> AI视频生成的角色参考图

| 目录 | 状态 | 说明 |
|------|------|------|
| `assets/characters/player/` | ⏳ 待生成 | 主角手部参考图 |
| `assets/characters/lin_xiaowei/` | ⏳ 待生成 | 林晓薇参考图 |
| `assets/characters/bai_zhiyao/` | ⏳ 待生成 | 白芷瑶参考图 |
| `assets/characters/shen_moran/` | ⏳ 待生成 | 沈墨染参考图 |
| `assets/characters/ye_qinghan/` | ⏳ 待生成 | 叶清寒参考图 |
| `assets/characters/jiang_nian/` | ⏳ 待生成 | 江念参考图 |
| `assets/characters/chen_yuanhang/` | ⏳ 待生成 | 陈远航参考图 |
| `assets/characters/su_yalin/` | ⏳ 待生成 | 苏雅琳参考图 |

### 品牌资产 (`assets/brand/`)

| 资产描述文件 | 实际资产 | 状态 | 说明 |
|--------------|----------|------|------|
| [logo_main.png.md](./assets/brand/logo_main.png.md) | logo_main.png | ⏳ 待制作 | 游戏主Logo |

### UI资产 (`assets/ui/`)

| 资产描述文件 | 实际资产 | 状态 | 说明 |
|--------------|----------|------|------|
| [btn_primary_normal.png.md](./assets/ui/btn_primary_normal.png.md) | btn_primary_normal.png | ⏳ 待制作 | 主按钮-正常状态 |
| [btn_primary_hover.png.md](./assets/ui/btn_primary_hover.png.md) | btn_primary_hover.png | ⏳ 待制作 | 主按钮-悬停状态 |
| [btn_primary_pressed.png.md](./assets/ui/btn_primary_pressed.png.md) | btn_primary_pressed.png | ⏳ 待制作 | 主按钮-按下状态 |
| [btn_secondary_normal.png.md](./assets/ui/btn_secondary_normal.png.md) | btn_secondary_normal.png | ⏳ 待制作 | 次要按钮-正常状态 |
| [btn_pause.png.md](./assets/ui/btn_pause.png.md) | btn_pause.png | ⏳ 待制作 | 暂停按钮 |
| [btn_play.png.md](./assets/ui/btn_play.png.md) | btn_play.png | ⏳ 待制作 | 播放按钮 |
| [bg_main_menu.jpg.md](./assets/ui/bg_main_menu.jpg.md) | bg_main_menu.jpg | ⏳ 待制作 | 主菜单背景 |
| [dialog_panel.9.png.md](./assets/ui/dialog_panel.9.png.md) | dialog_panel.9.png | ⏳ 待制作 | 对话框面板 |
| [subtitle_panel.9.png.md](./assets/ui/subtitle_panel.9.png.md) | subtitle_panel.9.png | ⏳ 待制作 | 字幕面板 |
| [save_slot.9.png.md](./assets/ui/save_slot.9.png.md) | save_slot.9.png | ⏳ 待制作 | 存档槽位面板 |
| [progress_bg.9.png.md](./assets/ui/progress_bg.9.png.md) | progress_bg.9.png | ⏳ 待制作 | 进度条背景 |
| [progress_fill.9.png.md](./assets/ui/progress_fill.9.png.md) | progress_fill.9.png | ⏳ 待制作 | 进度条填充 |
| [slider_bg.9.png.md](./assets/ui/slider_bg.9.png.md) | slider_bg.9.png | ⏳ 待制作 | 滑块背景 |
| [slider_fill.9.png.md](./assets/ui/slider_fill.9.png.md) | slider_fill.9.png | ⏳ 待制作 | 滑块填充 |
| [slider_handle.png.md](./assets/ui/slider_handle.png.md) | slider_handle.png | ⏳ 待制作 | 滑块把手 |

### 图标资产 (`assets/ui/`)

| 资产描述文件 | 实际资产 | 状态 | 说明 |
|--------------|----------|------|------|
| [icon_menu.svg.md](./assets/ui/icon_menu.svg.md) | icon_menu.svg | ⏳ 待制作 | 菜单图标 |
| [icon_settings.svg.md](./assets/ui/icon_settings.svg.md) | icon_settings.svg | ⏳ 待制作 | 设置图标 |
| [icon_save.svg.md](./assets/ui/icon_save.svg.md) | icon_save.svg | ⏳ 待制作 | 存档图标 |
| [icon_load.svg.md](./assets/ui/icon_load.svg.md) | icon_load.svg | ⏳ 待制作 | 读档图标 |
| [icon_back.svg.md](./assets/ui/icon_back.svg.md) | icon_back.svg | ⏳ 待制作 | 返回图标 |
| [icon_close.svg.md](./assets/ui/icon_close.svg.md) | icon_close.svg | ⏳ 待制作 | 关闭图标 |
| [icon_lock.svg.md](./assets/ui/icon_lock.svg.md) | icon_lock.svg | ⏳ 待制作 | 锁定图标 |
| [icon_affection.svg.md](./assets/ui/icon_affection.svg.md) | icon_affection.svg | ⏳ 待制作 | 好感度图标 |
| [icon_volume.svg.md](./assets/ui/icon_volume.svg.md) | icon_volume.svg | ⏳ 待制作 | 音量图标 |

### 选项卡片资产 (`assets/ui/choice/`)

| 资产描述文件 | 实际资产 | 状态 | 说明 |
|--------------|----------|------|------|
| [choice_card_normal.9.png.md](./assets/ui/choice/choice_card_normal.9.png.md) | choice_card_normal.9.png | ⏳ 待制作 | 选项卡片-正常状态 |
| [choice_card_hover.9.png.md](./assets/ui/choice/choice_card_hover.9.png.md) | choice_card_hover.9.png | ⏳ 待制作 | 选项卡片-悬停状态 |
| [choice_card_selected.9.png.md](./assets/ui/choice/choice_card_selected.9.png.md) | choice_card_selected.9.png | ⏳ 待制作 | 选项卡片-选中状态 |
| [choice_card_locked.9.png.md](./assets/ui/choice/choice_card_locked.9.png.md) | choice_card_locked.9.png | ⏳ 待制作 | 选项卡片-锁定状态 |

---

## ✅ 阶段检查清单

### 风格规范
- [x] 美术风格定义
- [x] 配色方案制定
- [x] 字体规范制定
- [x] UI组件设计规范
- [x] AI视频制作指南

### UI制作
- [x] 界面布局设计
- [x] 图标设计 (9个SVG图标)
- [x] 界面切图 (28个UI资产)
- [ ] 适配不同分辨率 (待Godot验证)

### AI视频制作
- [x] AI视频制作流程规范
- [x] 场景视觉设定文档（含镜头分解）
- [x] 角色视觉设定文档
- [x] 场景参考图生成（41张）
- [x] 角色参考图生成（60张）
- [x] 图片上传TOS（101张，公网可访问）
- [x] 对话脚本（18个）
- [x] 视频镜头清单
- [x] 混合视觉方案（关键帧+短视频）
- [ ] Godot着色器效果库
- [ ] 关键帧图片生成（~200张）
- [ ] 短视频生成（~60个）
- [ ] 场景组件集成

---

## 📊 资产进度追踪

### 参考图资产 ✅ 完成

| 资产类型 | 总数 | 已生成 | 已上传 | 状态 |
|----------|------|--------|--------|------|
| 场景参考图 | 41 | 41 | 41 | ✅ |
| 角色参考图 | 60 | 60 | 60 | ✅ |
| **总计** | **101** | **101** | **101** | ✅ |

> **存储桶**: lost-choices-art (公共读)
> **基础URL**: https://lost-choices-art.tos-cn-beijing.volces.com
> **URL参考**: `docs/图片生成工作状态.md`

### UI资产

| 资产类型 | 总数 | 已完成 | 状态 |
|----------|------|--------|------|
| 按钮组件 | 10 | 10 | ✅ |
| 图标 | 9 | 9 | ✅ |
| 背景图 | 1 | 1 | ✅ |
| 面板组件 | 8 | 8 | ✅ |
| **总计** | **28** | **28** | ✅ |

> 所有UI资产已生成，存放在 `lost-choices/assets/ui/`
> 详见: `lost-choices/assets/ui/ASSET_MANIFEST.md`

### 视频资产 (混合方案)

| 指标 | 数值 | 状态 |
|------|------|------|
| 场景数量 | 6个 | ✅ 设定完成 |
| 短视频片段 | ~60个 | 📝 待生成 |
| 关键帧图片 | ~200张 | 📝 待生成 |
| 总时长 | 118分钟 | - |
| 对话脚本 | 18个 | ✅ 已完成 |
| 镜头清单 | 1个 | ✅ 已完成 |
| 混合方案文档 | 1个 | ✅ 已完成 |

> **混合方案**: 关键帧+程序动画 为主，短视频仅用于关键剧情
> **成本节省**: AI调用从464次降至约60次 (节省87%)
> 详见: `docs/03_art/video_production/hybrid_visual_solution.md`

---

## 📝 资产命名规范

### 文件命名格式

```
类型_项目_描述_状态.扩展名
```

### 类型前缀

| 前缀 | 说明 | 示例 |
|------|------|------|
| btn | 按钮 | btn_start_normal.png |
| icon | 图标 | icon_settings.svg |
| bg | 背景 | bg_main_menu.jpg |
| panel | 面板 | panel_dialog.9.png |
| card | 卡片 | card_choice_hover.9.png |

### 状态后缀

| 后缀 | 说明 |
|------|------|
| normal | 正常状态 |
| hover | 悬停状态 |
| pressed | 按下状态 |
| selected | 选中状态 |
| locked | 锁定状态 |
| disabled | 禁用状态 |

### 九宫格图片

需要可拉伸的UI组件使用 `.9.png` 后缀，如：`btn_primary_normal.9.png`

---

## 📐 输出规范

### 图片格式

| 类型 | 格式 | 说明 |
|------|------|------|
| UI元素 | PNG | 透明背景，@1x/@2x/@3x |
| 图标 | SVG | 矢量格式优先 |
| 背景 | JPG/WebP | 压缩率80% |

### 分辨率

| 类型 | 基准分辨率 | 输出倍率 |
|------|------------|----------|
| UI元素 | 1920×1080 | @1x, @2x, @3x |
| 图标 | 24×24 ~ 64×64 | @1x, @2x, @3x |
| 背景 | 1920×1080 | 单张 |

---

**阶段状态**: 🟡 进行中
**当前重点**: 视频生产准备完成，等待AI视频生成
**下一里程碑**: AI视频片段批量生成
