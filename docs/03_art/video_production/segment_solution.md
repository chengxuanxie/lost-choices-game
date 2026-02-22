# AI视频分段生成方案

> 解决AI视频生成时长限制的技术方案

---

## 一、问题分析

### 当前状态
- 章节JSON设计的视频时长: 240-720秒
- AI视频生成工具限制: 5-30秒/段
- 即梦视频生成3.0 Pro: 最长约10秒

### 核心问题
单个AI视频无法达到游戏设计的时长要求。

---

## 二、解决方案：分段生成 + 运行时拼接

### 设计原则
1. **拆分长视频** → 多个10-20秒的片段
2. **AI分段生成** → 每段独立生成
3. **运行时拼接** → Godot中无缝播放

### 架构图
```
原始视频 (480秒)
    ↓ 拆分
[Clip1] [Clip2] [Clip3] [Clip4] ... [ClipN]
(15秒)  (15秒)  (15秒)  (15秒)      (15秒)
    ↓ AI生成
[.mp4]  [.mp4]  [.mp4]  [.mp4]      [.mp4]
    ↓ 转码
[.ogv]  [.ogv]  [.ogv]  [.ogv]      [.ogv]
    ↓ Godot运行时
  VideoManager.playlist_play(clips)
    ↓
  无缝播放给玩家
```

---

## 三、JSON数据结构调整

### 原格式
```json
"video": {
  "path": "res://assets/videos/ch1/sc001_main.ogv",
  "duration": 480
}
```

### 新格式 (方案A: 播放列表)
```json
"video": {
  "type": "playlist",
  "clips": [
    {"path": "res://assets/videos/ch1/sc001/clip_001.ogv", "duration": 15},
    {"path": "res://assets/videos/ch1/sc001/clip_002.ogv", "duration": 15},
    {"path": "res://assets/videos/ch1/sc001/clip_003.ogv", "duration": 15},
    ...
  ],
  "total_duration": 480
}
```

### 新格式 (方案B: 目录引用)
```json
"video": {
  "type": "directory",
  "path": "res://assets/videos/ch1/sc001/",
  "pattern": "clip_*.ogv",
  "total_duration": 480
}
```

---

## 四、Godot代码修改

### VideoManager 新增方法

```gdscript
# video_manager.gd

var _playlist: Array = []
var _playlist_index: int = 0
var _playlist_loop: bool = false

signal playlist_finished()

## 播放视频列表
func playlist_play(clips: Array, loop: bool = false) -> void:
    _playlist = clips
    _playlist_index = 0
    _playlist_loop = loop
    _play_next_clip()

func _play_next_clip() -> void:
    if _playlist_index >= _playlist.size():
        if _playlist_loop:
            _playlist_index = 0
        else:
            playlist_finished.emit()
            return

    var clip = _playlist[_playlist_index]
    play_video_by_path(clip.path)
    _playlist_index += 1

func _on_video_finished() -> void:
    if _playlist.size() > 0:
        _play_next_clip()

## 获取播放列表进度
func get_playlist_progress() -> float:
    if _playlist.is_empty():
        return 0.0
    return float(_playlist_index) / float(_playlist.size())
```

---

## 五、分镜脚本调整

### 新的片段结构

每个视频节点拆分为多个片段，每个片段10-20秒：

```yaml
# 示例: ch1_sc_001 分片方案
clips:
  - id: clip_001
    duration: 15
    description: "醒来 - 视觉模糊到清晰"
    prompt: "First person POV, waking up, blurry vision clearing..."

  - id: clip_002
    duration: 15
    description: "观察房间 - 环境扫描"
    prompt: "First person POV, looking around mysterious room..."

  - id: clip_003
    duration: 20
    description: "起身 - 从躺着到坐起"
    prompt: "First person POV, sitting up from bed..."
```

---

## 六、片段命名规范

```
assets/videos/
└── ch1/
    ├── sc001/                 # 场景目录
    │   ├── clip_001.ogv       # 片段1
    │   ├── clip_002.ogv       # 片段2
    │   └── ...
    ├── sc002a/
    │   └── ...
    └── endings/
        ├── ending_01/
        │   └── clip_*.ogv
        └── ...
```

---

## 七、生成流程

### Step 1: 规划分片
根据分镜脚本，将每个视频拆分为10-20秒的片段

### Step 2: 批量生成
```bash
# 使用 video_gen skill 生成每个片段
# 参考分镜脚本中的 clip 配置
```

### Step 3: 转码
```bash
# MP4 → OGV
ffmpeg -i clip_001.mp4 -c:v libtheora -q:v 7 clip_001.ogv
```

### Step 4: 更新JSON
将新的片段信息更新到 chapter_01.json

### Step 5: 测试
在Godot中测试播放列表的无缝性

---

## 八、推荐片段时长

| 场景类型 | 单片段时长 | 片段数(每节点) |
|----------|------------|----------------|
| 静态探索 | 15-20秒 | 3-5个 |
| 对话场景 | 10-15秒 | 4-6个 |
| 动作场景 | 8-12秒 | 5-8个 |
| 过渡场景 | 10秒 | 2-3个 |

---

## 九、质量保证

### 衔接检查清单
- [ ] 相邻片段色调一致
- [ ] 视角高度连续
- [ ] 光照条件匹配
- [ ] 背景元素一致
- [ ] 无明显跳跃感

---

**创建日期**: 2026-02-22
**用途**: 解决AI视频时长限制问题
