# 项目文档

> 《迷途抉择》游戏项目文档导航

---

## 快速入口

| 文档 | 用途 | 推荐阅读顺序 |
|------|------|-------------|
| [快速恢复工作指引.md](快速恢复工作指引.md) | **新人首选** - 1分钟恢复工作上下文 | 1 |
| [plan.md](plan.md) | 项目总览、里程碑、进度追踪 | 2 |
| [开发工作规范.md](开发工作规范.md) | 工作流程、代码规范 | 3 |

---

## 目录结构

```
docs/
├── README.md                       # 本文档
├── plan.md                         # 项目总览
├── 快速恢复工作指引.md              # 会话恢复/团队交接
├── 开发工作规范.md                  # 工作流程规范
├── 图片生成工作状态.md              # 图片URL记录
│
├── 02_design/                      # 设计文档
│   ├── README.md                   # 设计文档索引
│   ├── 01_GDD_游戏设计文档.md      # 游戏设计 v2.0
│   ├── 02_角色设定文档.md          # 角色设定 v2.0
│   ├── 03_首章剧情大纲.md          # 剧情大纲 v2.0
│   └── 04_分支流程图设计.md        # 分支设计 v2.0
│
└── 03_art/                         # 美术文档
    ├── README.md                   # 美术文档索引
    ├── 03_AI视频制作指南.md        # ⭐ 核心制作规范
    ├── scenes/                     # 场景设定
    │   └── ch1/                    # 第一章场景
    │       ├── sc_001_神秘房间.md
    │       ├── sc_003_通讯室.md
    │       ├── sc_004_走廊通道.md
    │       ├── sc_005_白芷瑶房间.md
    │       ├── sc_006_沈墨染画室.md
    │       └── sc_007_出口区域.md
    ├── characters/                 # 角色设定
    ├── scripts/                    # 对话脚本
    ├── assets/                     # 图片资源
    └── video_production/           # 视频制作方案
        └── hybrid_visual_solution.md
```

---

## 按用途查找

### 想了解游戏设计

1. [02_design/01_GDD_游戏设计文档.md](02_design/01_GDD_游戏设计文档.md) - 完整的游戏设计
2. [02_design/02_角色设定文档.md](02_design/02_角色设定文档.md) - 8个可攻略角色
3. [02_design/03_首章剧情大纲.md](02_design/03_首章剧情大纲.md) - 第一章剧情
4. [02_design/04_分支流程图设计.md](02_design/04_分支流程图设计.md) - 分支选择设计

### 想制作美术资产

1. [03_art/03_AI视频制作指南.md](03_art/03_AI视频制作指南.md) - **必读** - 制作规范
2. [03_art/scenes/ch1/](03_art/scenes/ch1/) - 各场景的关键帧/视频需求
   - **SC-001 已完成详细剧情**: [sc_001_神秘房间.md](03_art/scenes/ch1/sc_001_神秘房间.md)
3. [03_art/video_production/hybrid_visual_solution.md](03_art/video_production/hybrid_visual_solution.md) - 混合视觉方案说明

### 想了解剧情和角色

1. [02_design/03_首章剧情大纲.md](02_design/03_首章剧情大纲.md) - 第一章剧情（含SC-001详细剧情）
2. [03_art/scripts/ch1/ch1_sc_001.md](03_art/scripts/ch1/ch1_sc_001.md) - SC-001完整对话脚本
3. [03_art/scenes/ch1/sc_001_物品与线索.md](03_art/scenes/ch1/sc_001_物品与线索.md) - SC-001物品设计
4. [03_art/characters/ch1_神秘人.md](03_art/characters/ch1_神秘人.md) - 神秘人角色设计

### 想了解代码结构

参见 [快速恢复工作指引.md](快速恢复工作指引.md) 中的"关键文件路径"部分。

---

## 核心规范

### 一场景一参考图

每个场景使用1张核心参考图，所有关键帧和短视频都基于该参考图生成。

详见: [03_art/03_AI视频制作指南.md](03_art/03_AI视频制作指南.md)

### 混合视觉方案

```
关键帧图片 + 着色器效果  →  主力（成本节省87%）
短视频                  →  仅关键剧情节点
```

详见: [03_art/video_production/hybrid_visual_solution.md](03_art/video_production/hybrid_visual_solution.md)

---

**最后更新**: 2026-02-23
