# 迷途抉择 (Lost Choices)

第一人称视频互动游戏 - Godot 4.3 技术原型

## 项目概述

《迷途抉择》是一款第一人称视频互动游戏，玩家通过选择不同的剧情分支来推进故事发展，最终达成不同的结局。

### 核心特性

- **分支剧情系统**: 支持复杂的故事分支和条件判断
- **好感度系统**: 角色好感度影响剧情走向和结局
- **存档系统**: 支持多存档位，自动存档
- **Web支持**: 可导出为Web版本在浏览器中运行
- **单机模式**: 无需服务器，完全离线运行

## 技术架构

### 核心系统 (Autoload)

| 管理器 | 功能 |
|--------|------|
| GameManager | 游戏生命周期、状态管理、场景切换 |
| VideoManager | 视频加载、播放、缓存 |
| StoryEngine | 剧情流程、节点管理、分支选择 |
| GameStateManager | 游戏状态（标记、变量、物品、好感度） |
| SaveManager | 存档保存/加载、加密 |
| AudioManager | 背景音乐、音效播放 |
| EventManager | 全局事件系统 |
| ResourceManager | 资源加载和缓存 |
| StatsManager | 游戏统计 |

### 目录结构

```
lost-choices/
├── project.godot          # Godot 项目配置
├── icon.svg               # 项目图标
├── scripts/
│   ├── autoload/          # 全局管理器脚本
│   ├── ui/                # UI 场景脚本
│   ├── test/              # 测试脚本
│   └── utils/             # 工具脚本
├── scenes/
│   ├── main_menu.tscn     # 主菜单场景
│   ├── game.tscn          # 游戏主场景
│   ├── demo.tscn          # 演示场景
│   └── test_runner.tscn   # 测试场景
├── data/
│   └── stories/
│       ├── chapters_index.json  # 章节索引
│       └── chapter_01.json      # 第一章数据
└── assets/                # 资源文件（需添加）
    ├── videos/            # 视频文件
    ├── audio/             # 音频文件
    └── images/            # 图片文件
```

## 快速开始

### 环境要求

- Godot Engine 4.3 或更高版本
- （可选）Visual Studio Code + GDScript 扩展

### 运行项目

1. 使用 Godot 编辑器打开项目目录
2. 点击运行按钮（或按 F5）
3. 主菜单将显示以下选项：
   - **开始新游戏**: 进入游戏主场景（需要视频资源）
   - **演示模式**: 模拟游戏流程，无需视频文件
   - **运行测试**: 执行技术原型验证测试

### 测试验证

项目包含完整的技术原型测试套件，点击"运行测试"按钮可验证：

- GameManager: 状态管理、场景切换
- GameStateManager: 标记、变量、物品、好感度
- StoryEngine: 章节加载、节点管理、条件判断、效果应用
- SaveManager: 存档槽位、加密解密
- VideoManager: 缓存配置、播放状态
- AudioManager: 音量控制、静音
- EventManager: 事件注册、触发
- StatsManager: 统计记录

### 演示模式

演示模式模拟完整的游戏流程：
1. 加载章节数据
2. 显示剧情文本（模拟字幕）
3. 提供选择按钮
4. 应用选择效果（好感度变化等）
5. 达成结局

## 剧情数据格式

### 章节文件结构

```json
{
  "chapter_id": "chapter_01",
  "title": "章节标题",
  "start_node": "ch1_sc_001",
  "endings": [...],
  "nodes": {
    "node_id": {
      "node_type": "choice|video|ending|auto",
      "video": {...},
      "subtitles": [...],
      "choices": [...],
      "conditions": [...],
      "effects": [...]
    }
  }
}
```

### 节点类型

- `choice`: 播放视频后显示选择
- `video`: 纯视频节点
- `ending`: 结局节点
- `auto`: 自动跳转节点

### 条件类型

- `flag`: 检查布尔标记
- `variable`: 检查数值变量
- `relationship`: 检查角色好感度
- `item`: 检查是否拥有物品
- `visited`: 检查是否访问过节点

### 效果类型

- `set_flag`: 设置标记
- `set_variable`: 设置变量
- `modify_variable`: 修改变量
- `modify_relationship`: 修改好感度
- `add_item`: 添加物品
- `remove_item`: 移除物品
- `trigger_event`: 触发事件

## Web 导出

### 配置

项目已配置 WebGL2 优先渲染，适合 Web 导出：
- `export/prefer_webgl2=true`
- `export/exclude_p2p=true`

### 导出步骤

1. 项目 → 导出
2. 添加 Web 平台
3. 配置导出选项
4. 点击导出项目

### 浏览器兼容性

- Chrome/Edge: 完全支持
- Firefox: 完全支持
- Safari: 需要使用 WebM 格式视频

## 添加视频资源

1. 将视频文件放入 `assets/videos/` 目录
2. 推荐格式：
   - OGV (Theora): 适用于 Chrome/Firefox
   - WebM: 适用于 Safari
3. 更新章节数据中的视频路径

## 开发路线

- [x] M1: 项目规划和文档
- [x] M2: 技术原型验证
- [ ] M3: 第一章内容制作
- [ ] M4: UI/UX 完善
- [ ] M5: 测试和优化
- [ ] M6: 发布准备

## 许可证

本项目仅供技术原型验证使用。
