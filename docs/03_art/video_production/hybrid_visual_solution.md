# 混合视觉方案

> 结合短视频、关键帧动画和程序特效，平衡视觉效果与制作成本

---

## 一、方案概述

### 核心理念
- **重要剧情节点**: 使用短视频 (5-10秒)
- **普通场景过渡**: 关键帧图片 + Godot程序动画
- **循环场景**: 短循环动图 (2-3秒)

### 成本预估

| 方案 | 原方案 | 混合方案 | 节省 |
|------|--------|----------|------|
| AI视频调用 | 464次 | ~60次 | 87% |
| 存储空间 | ~2.3GB | ~300MB | 87% |
| 制作时间 | 长 | 短 | 70% |

---

## 二、场景分类

### A类: 短视频场景 (60个片段 → 60次AI调用)

这些场景需要动态视频来传达关键剧情：

| 场景 | 原片段数 | 新方案 | 短视频数 |
|------|----------|--------|----------|
| ch1_sc_001 醒来 | 32 | 4个短视频(各8秒) | 4 |
| ch1_sc_002a 遇见林晓薇 | 24 | 3个短视频 | 3 |
| ch1_sc_003 追逐 | 40 | 5个短视频(动作场景) | 5 |
| ch1_sc_008 天台抉择 | 28 | 4个短视频 | 4 |
| ending_01~05 结局 | 100 | 各4个短视频 | 20 |
| 其他关键节点 | - | 精选重要时刻 | 24 |
| **小计** | **~224** | - | **60** |

### B类: 关键帧+程序动画 (~200张图片)

这些场景可用静态图+动画效果：

| 场景类型 | 原片段数 | 新方案 | 图片数 |
|----------|----------|--------|--------|
| 环境观察 | ~80 | 3-5张关键帧 | 40 |
| 对话场景 | ~100 | 2-3张表情帧 | 60 |
| 探索发现 | ~60 | 3-4张关键帧 | 50 |
| 过渡场景 | ~50 | 1-2张背景帧 | 50 |
| **小计** | **~290** | - | **200** |

---

## 三、技术实现

### 3.1 短视频 (A类)

```gdscript
# 关键剧情节点使用短视频
func play_key_scene(video_id: String, clip_index: int):
    var path = "res://assets/videos/%s/clip_%03d.ogv" % [video_id, clip_index]
    video_player.stream = load(path)
    video_player.play()
```

**生成命令**:
```
# 使用video_gen skill生成5-10秒短视频
/video_gen prompt="First person POV, dramatic moment..." duration=8
```

### 3.2 关键帧+程序动画 (B类)

```gdscript
# 关键帧场景使用TextureRect + Shader
class_name KeyframeScene extends Control

@export var keyframes: Array[Texture]  # 3-5张关键帧
@export var transition_duration: float = 3.0
@export var effects: Array[String] = ["parallax", "zoom", "light_flicker"]

var current_frame: int = 0

func play_scene():
    # 1. 交叉淡入淡出切换关键帧
    tween_crossfade(keyframes[current_frame], keyframes[current_frame + 1])

    # 2. 应用程序动画效果
    apply_shader_effects(effects)

    # 3. 等待用户交互或定时切换
    await get_tree().create_timer(transition_duration).timeout
    next_frame()
```

### 3.3 Godot着色器效果

```glsl
// 视差效果
shader_type canvas_item;

uniform float parallax_strength: hint_range(0.0, 0.1) = 0.02;
uniform vec2 parallax_direction = vec2(1.0, 0.5);

void fragment() {
    vec2 uv = UV + parallax_direction * parallax_strength * sin(TIME * 0.5);
    COLOR = texture(TEXTURE, uv);
}

// 缓慢缩放
uniform float zoom_speed: hint_range(0.0, 0.5) = 0.1;
uniform float zoom_amount: hint_range(0.0, 0.2) = 0.05;

void fragment() {
    float zoom = 1.0 + zoom_amount * sin(TIME * zoom_speed);
    vec2 center = vec2(0.5, 0.5);
    vec2 uv = center + (UV - center) / zoom;
    COLOR = texture(TEXTURE, uv);
}

// 光影变化
uniform float flicker_speed: hint_range(0.5, 5.0) = 2.0;
uniform float flicker_amount: hint_range(0.0, 0.3) = 0.1;

void fragment() {
    COLOR = texture(TEXTURE, UV);
    float flicker = 1.0 - flicker_amount * (0.5 + 0.5 * sin(TIME * flicker_speed));
    COLOR.rgb *= flicker;
}
```

---

## 四、资产结构

### 新的目录结构

```
assets/
├── keyframes/           # 关键帧图片
│   └── ch1/
│       ├── sc_001/
│       │   ├── frame_001.png  # 醒来-闭眼
│       │   ├── frame_002.png  # 醒来-睁眼
│       │   ├── frame_003.png  # 观察-天花板
│       │   └── ...
│       └── ...
│
├── videos/              # 短视频 (仅关键节点)
│   └── ch1/
│       ├── sc_001/
│       │   ├── key_001.ogv    # 醒来过程 (8秒)
│       │   ├── key_002.ogv    # 发现纸条 (6秒)
│       │   └── ...
│       └── endings/
│           └── ...
│
└── shaders/             # 场景特效着色器
    ├── parallax.gdshader
    ├── slow_zoom.gdshader
    ├── light_flicker.gdshader
    └── scene_atmosphere.gdshader
```

---

## 五、场景配置示例

### JSON配置格式

```json
{
  "ch1_sc_001": {
    "type": "hybrid",
    "keyframes": {
      "dir": "res://assets/keyframes/ch1/sc_001/",
      "frames": [
        {"file": "frame_001.png", "duration": 5, "effects": ["blur_to_clear"]},
        {"file": "frame_002.png", "duration": 4, "effects": ["slow_zoom"]},
        {"file": "frame_003.png", "duration": 5, "effects": ["parallax"]},
        {"file": "frame_004.png", "duration": 4, "effects": ["light_flicker"]}
      ]
    },
    "videos": [
      {"file": "key_001.ogv", "trigger": "on_wake", "duration": 8},
      {"file": "key_002.ogv", "trigger": "on_find_note", "duration": 6}
    ],
    "total_duration": 480
  },

  "ch1_sc_003": {
    "type": "video_heavy",
    "videos": [
      {"file": "chase_001.ogv", "duration": 10},
      {"file": "chase_002.ogv", "duration": 8},
      {"file": "chase_003.ogv", "duration": 10},
      {"file": "chase_004.ogv", "duration": 8},
      {"file": "chase_005.ogv", "duration": 10}
    ],
    "bridges": [
      {"type": "keyframe", "file": "bridge_001.png", "duration": 3}
    ]
  }
}
```

---

## 六、关键帧生成清单

### 优先级P1 (核心场景)

| 场景 | 关键帧数 | 短视频数 | 说明 |
|------|----------|----------|------|
| sc_001 神秘房间 | 12张 | 4个 | 开场最重要 |
| sc_002a 遇见林晓薇 | 8张 | 3个 | 关键相遇 |
| sc_003 追逐 | 10张 | 5个 | 动作场景 |
| sc_008 天台 | 10张 | 4个 | 高潮场景 |

### 优先级P2 (结局)

| 结局 | 关键帧数 | 短视频数 |
|------|----------|----------|
| ending_01 | 8张 | 4个 |
| ending_02 | 8张 | 4个 |
| ending_03 | 8张 | 4个 |
| ending_04 | 8张 | 4个 |
| ending_05 | 8张 | 4个 |

### 优先级P3 (其他场景)

- 其余场景使用关键帧+程序动画
- 根据已有参考图快速生成

---

## 七、实施步骤

### Phase 1: 基础设施 (1-2天)
1. 创建KeyframeScene组件
2. 编写着色器效果库
3. 更新SceneManager支持混合模式

### Phase 2: 关键帧生成 (2-3天)
1. 基于现有参考图生成关键帧变体
2. 使用img_gen skill批量生成

### Phase 3: 短视频生成 (3-5天)
1. 筛选60个关键剧情点
2. 使用video_gen skill生成5-10秒短视频
3. 转码为OGV格式

### Phase 4: 集成测试 (1-2天)
1. 更新chapter_01.json
2. 测试场景切换流畅度
3. 调整动画参数

---

## 八、效果预览

### 关键帧动画效果

```
场景: 神秘房间醒来

[frame_001] --blur_to_clear(3s)--> [frame_002] --slow_zoom(4s)--> [frame_003]
    ↓                                    ↓                            ↓
  闭眼模糊                            睁眼清晰                      观察房间
  (程序动画)                          (程序动画)                    (程序动画)

关键时刻: 发现纸条
[key_001.ogv] 6秒短视频
    ↓
  手拿起纸条特写
  (AI生成视频)
```

---

**创建日期**: 2026-02-22
**状态**: 方案设计完成
**下一步**: 开始Phase 1基础设施开发
