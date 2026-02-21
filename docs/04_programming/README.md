# 💻 程序开发阶段

> 本阶段负责游戏的技术实现，包括架构设计、功能开发、核心系统等

---

## 📢 阶段状态

| 项目 | 内容 |
|------|------|
| **阶段状态** | ✅ 技术原型完成 |
| **开始日期** | 2026-02-21 |
| **当前进度** | 原型验证通过，进入M3开发 |
| **阶段负责人** | 技术负责人 |

---

## 📁 项目结构

```
lost-choices/
├── project.godot              # Godot 项目配置
├── scripts/
│   ├── autoload/              # 9个全局管理器
│   │   ├── game_manager.gd    # 游戏生命周期
│   │   ├── video_manager.gd   # 视频播放
│   │   ├── story_engine.gd    # 剧情引擎
│   │   ├── game_state_manager.gd  # 状态管理
│   │   ├── save_manager.gd    # 存档系统
│   │   ├── audio_manager.gd   # 音频管理
│   │   ├── event_manager.gd   # 事件系统
│   │   ├── resource_manager.gd # 资源加载
│   │   └── stats_manager.gd   # 统计数据
│   ├── ui/                    # UI脚本
│   ├── test/                  # 测试脚本
│   └── utils/                 # 工具脚本
├── scenes/                    # 场景文件
├── data/stories/              # 剧情数据(JSON)
└── assets/                    # 资源文件
```

---

## ✅ 已完成的核心系统

### 全局管理器 (Autoload)

| 系统 | 文件 | 状态 | 说明 |
|------|------|------|------|
| GameManager | game_manager.gd | ✅ 完成 | 游戏生命周期、场景切换 |
| VideoManager | video_manager.gd | ✅ 完成 | 视频加载、播放、缓存 |
| StoryEngine | story_engine.gd | ✅ 完成 | 剧情流程、节点管理 |
| GameStateManager | game_state_manager.gd | ✅ 完成 | 标记、变量、物品、好感度 |
| SaveManager | save_manager.gd | ✅ 完成 | 存档系统（加密存储） |
| AudioManager | audio_manager.gd | ✅ 完成 | BGM/SFX播放 |
| EventManager | event_manager.gd | ✅ 完成 | 事件注册/触发 |
| ResourceManager | resource_manager.gd | ✅ 完成 | 资源加载管理 |
| StatsManager | stats_manager.gd | ✅ 完成 | 游戏统计 |

### 场景文件

| 场景 | 文件 | 状态 | 说明 |
|------|------|------|------|
| 主菜单 | main_menu.tscn | ✅ 完成 | 游戏入口界面 |
| 游戏场景 | game.tscn | ✅ 完成 | 核心游戏场景 |
| 演示模式 | demo.tscn | ✅ 完成 | 无视频演示 |
| 测试场景 | test.tscn | ✅ 完成 | 自动化测试 |

---

## 📊 测试状态

### M2 技术原型测试结果

| 测试类别 | 测试数 | 通过 | 状态 |
|----------|--------|------|------|
| GameManager | 3 | 3 | ✅ |
| GameStateManager | 6 | 6 | ✅ |
| StoryEngine | 3 | 3 | ✅ |
| SaveManager | 13 | 13 | ✅ |
| VideoManager | 2 | 2 | ✅ |
| AudioManager | 2 | 2 | ✅ |
| EventManager | 1 | 1 | ✅ |
| **总计** | **30** | **30** | ✅ 全部通过 |

---

## 🔧 技术架构

### 单机模式架构

```
┌─────────────────────────────────────────────┐
│                   Godot 4.3                  │
├─────────────────────────────────────────────┤
│  Autoload Singletons (9个全局管理器)          │
│  ├── GameManager (游戏生命周期)               │
│  ├── StoryEngine (剧情引擎)                   │
│  ├── GameStateManager (状态管理)              │
│  ├── SaveManager (存档系统)                   │
│  └── ...                                     │
├─────────────────────────────────────────────┤
│  数据层                                      │
│  ├── JSON剧情数据 (data/stories/)            │
│  ├── 本地存档 (user://saves/)                │
│  └── IndexedDB (Web端)                       │
└─────────────────────────────────────────────┘
```

### 关键技术决策

| 决策 | 选择 | 原因 |
|------|------|------|
| 游戏引擎 | Godot 4.3+ | 开源免费、Web支持好 |
| 存储方案 | 本地文件 + IndexedDB | 单机模式，无需服务器 |
| 存档加密 | XOR + SHA256 | 简单有效 |
| 视频格式 | OGV/WebM | 浏览器兼容 |

---

## 📋 待开发功能

### M3 阶段

- [ ] 视频资源集成
- [ ] UI美化
- [ ] 性能优化

### M4-M5 阶段

- [ ] 多语言支持
- [ ] 成就系统
- [ ] 设置系统完善

---

**阶段状态**: ✅ 技术原型验证通过
**下一步**: 视频资源制作与集成
