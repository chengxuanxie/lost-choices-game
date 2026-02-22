---
video_id: ch1_sc_002b
scene_id: SC-002
scene_name: SC-002 废弃仓库
chapter: ch1
duration_seconds: 400
video_path: res://assets/videos/ch1/sc002b_explore.ogv
node_id: ch1_sc_002b

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_002/sc_002_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_002/sc_002_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: abandoned
  lighting: cinematic_dramatic

# 角色出场
characters:
  - id: player
    type: first_person
    visible: hands_only
---

# [CH1_SC_002B] SC-002 废弃仓库 - 分镜脚本

> 独自探索离开，在废弃仓库遇到林晓薇

---

## 一、场景概述

### 场景描述
独自探索离开，在废弃仓库遇到林晓薇

### 核心情绪
- 开场: 期待/紧张
- 中段: 发展
- 结尾: 过渡到下一节点

---

## 二、镜头分解

### Segment 1: 开场 (0-100秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 0-50s | 场景环境展示 | 第一人称 | 观察 | 警觉 |
| 50-100s | 角色互动 | 第一人称 | 对话/行动 | 紧张 |

**AI Prompt**:
```
First person POV, 废弃仓库, abandoned atmosphere,
cinematic, dramatic lighting, slow natural movement, 4K, 16:9 --duration 100
```

---

### Segment 2: 发展 (100-200秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 100-150s | 剧情推进 | 第一人称 | 互动 | 专注 |
| 150-200s | 信息揭示 | 第一人称 | 反应 | 惊讶 |

**AI Prompt**:
```
First person POV, story development scene, character interaction,
abandoned mood, cinematic, 4K, 16:9 --duration 100
```

---

### Segment 3: 高潮/过渡 (200-400秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 200-300s | 关键时刻 | 第一人称 | 决策 | 紧张 |
| 300-400s | 过渡/准备选择 | 第一人称 | 等待 | 期待 |

**AI Prompt**:
```
First person POV, climax moment, decision point,
abandoned intensity, cinematic tension, 4K, 16:9 --duration 200
```

---

## 三、AI生成配置

### 主Prompt模板
```
First person POV, cinematic, 废弃仓库,
abandoned atmosphere, dramatic lighting,
natural head movement, film grain, 4K, 16:9
```

### 风格词库
```
Positive: cinematic, first person POV, abandoned,
atmospheric, natural movement, 4K, film grain

Negative: third person, cartoon, bright, watermark, blurry, distorted
```

---

## 四、技术规格

| 参数 | 规格 |
|------|------|
| 分辨率 | 1920x1080 |
| 帧率 | 24fps |
| 格式 | MP4 -> OGV |
| 时长 | 400秒 |

---

## 五、质量检查清单

- [ ] 第一人称视角一致
- [ ] 光照风格统一
- [ ] 运动平滑无抖动
- [ ] 无AI生成明显瑕疵
- [ ] 时长符合要求

---

**创建日期**: 2026-02-22
**状态**: 待制作
**来源**: 自动生成自chapter_01.json
