---
video_id: ch1_ending_03
scene_id: 
scene_name: 结局: 治愈之路
chapter: ch1
duration_seconds: 300
video_path: res://assets/videos/ch1/ending_03_healing.ogv
node_id: ch1_ending_03

# 参考图URLs
reference_images:
  # 结局视频无场景参考图

# 视觉风格
style:
  type: cinematic_first_person
  mood: emotional, resolution
  lighting: cinematic_dramatic

# 角色出场
characters:
  - id: player
    type: first_person
    visible: hands_only
---

# [CH1_ENDING_03] 结局: 治愈之路 - 分镜脚本

> 在白芷瑶的帮助下开始恢复记忆

---

## 一、场景概述

### 场景描述
在白芷瑶的帮助下开始恢复记忆

### 核心情绪
- 开场: 期待/紧张
- 中段: 发展
- 结尾: 过渡到下一节点

---

## 二、镜头分解

### Segment 1: 开场 (0-75秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 0-37s | 场景环境展示 | 第一人称 | 观察 | 警觉 |
| 37-75s | 角色互动 | 第一人称 | 对话/行动 | 紧张 |

**AI Prompt**:
```
First person POV, 未知场景, emotional, resolution atmosphere,
cinematic, dramatic lighting, slow natural movement, 4K, 16:9 --duration 75
```

---

### Segment 2: 发展 (75-150秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 75-112s | 剧情推进 | 第一人称 | 互动 | 专注 |
| 112-150s | 信息揭示 | 第一人称 | 反应 | 惊讶 |

**AI Prompt**:
```
First person POV, story development scene, character interaction,
emotional, resolution mood, cinematic, 4K, 16:9 --duration 75
```

---

### Segment 3: 高潮/过渡 (150-300秒)

| 时间 | 画面 | POV | 动作 | 情绪 |
|------|------|-----|------|------|
| 150-225s | 关键时刻 | 第一人称 | 决策 | 紧张 |
| 225-300s | 过渡/准备选择 | 第一人称 | 等待 | 期待 |

**AI Prompt**:
```
First person POV, climax moment, decision point,
emotional, resolution intensity, cinematic tension, 4K, 16:9 --duration 150
```

---

## 三、AI生成配置

### 主Prompt模板
```
First person POV, cinematic, 未知场景,
emotional, resolution atmosphere, dramatic lighting,
natural head movement, film grain, 4K, 16:9
```

### 风格词库
```
Positive: cinematic, first person POV, emotional, resolution,
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
| 时长 | 300秒 |

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
