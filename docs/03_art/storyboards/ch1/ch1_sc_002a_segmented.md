---
video_id: ch1_sc_002a
scene_id: SC-002
scene_name: 废弃仓库 - 遇见林晓薇
chapter: ch1
total_duration_seconds: 360
video_path: res://assets/videos/ch1/sc_002a/
node_id: ch1_sc_002a

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 24

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_002/sc_002_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_002/sc_002_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_002A] 废弃仓库 - 遇见林晓薇 - 分镜脚本 (分段版)

> 按神秘人指示离开，在废弃仓库遇到林晓薇
> **总时长**: 360秒 / **片段数**: 24个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 离开房间 (0-45秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 离开房间 - 片段1 | `First person POV, beginning to leaving room, walking down corridor, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 离开房间 - 片段2 | `First person POV, leaving room, walking down corridor, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 离开房间 - 片段3 | `First person POV, intensifying leaving room, walking down corridor, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 进入仓库 (45-90秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_004 | 15s | 进入仓库 - 片段1 | `First person POV, beginning to entering abandoned warehouse, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_005 | 15s | 进入仓库 - 片段2 | `First person POV, entering abandoned warehouse, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 进入仓库 - 片段3 | `First person POV, intensifying entering abandoned warehouse, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 环境观察 (90-135秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 环境观察 - 片段1 | `First person POV, beginning to observing warehouse interior, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_008 | 15s | 环境观察 - 片段2 | `First person POV, observing warehouse interior, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_009 | 15s | 环境观察 - 片段3 | `First person POV, intensifying observing warehouse interior, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 听到声音 (135-180秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_010 | 15s | 听到声音 - 片段1 | `First person POV, beginning to hearing sound, becoming alert, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_011 | 15s | 听到声音 - 片段2 | `First person POV, hearing sound, becoming alert, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_012 | 15s | 听到声音 - 片段3 | `First person POV, intensifying hearing sound, becoming alert, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 发现林晓薇 (180-225秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现林晓薇 - 片段1 | `First person POV, beginning to spotting Lin Xiaowei, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 发现林晓薇 - 片段2 | `First person POV, spotting Lin Xiaowei, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_015 | 15s | 发现林晓薇 - 片段3 | `First person POV, intensifying spotting Lin Xiaowei, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 初次接触 (225-270秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_016 | 15s | 初次接触 - 片段1 | `First person POV, beginning to cautious first contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_017 | 15s | 初次接触 - 片段2 | `First person POV, cautious first contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_018 | 15s | 初次接触 - 片段3 | `First person POV, intensifying cautious first contact, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 对话交流 (270-315秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 对话交流 - 片段1 | `First person POV, beginning to conversation, establishing trust, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_020 | 15s | 对话交流 - 片段2 | `First person POV, conversation, establishing trust, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_021 | 15s | 对话交流 - 片段3 | `First person POV, intensifying conversation, establishing trust, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (315-360秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_022 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_023 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_024 | 15s | 选择时刻 - 片段3 | `First person POV, intensifying decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...24个片段配置...]

for clip in clips:
    generate_video(
        prompt=clip["prompt"],
        reference_image=clip["reference"],
        duration=clip["duration"],
        output=f"clip_{clip['id']:03d}.mp4"
    )
```

### 转码命令
```bash
# 批量转换 MP4 → OGV
for f in clip_*.mp4; do
    ffmpeg -i "$f" -c:v libtheora -q:v 7 "${f%.mp4}.ogv"
done
```

---

## 三、JSON配置示例

```json
"ch1_sc_002a": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_002a/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 360
  }
}
```

---

## 四、衔接注意事项

| 检查项 | 要求 |
|--------|------|
| 视角高度 | 始终保持眼睛水平(160-170cm) |
| 光照一致 | 同一场景内光源位置不变 |
| 色调统一 | 使用相同滤镜参数 |
| 手部风格 | 所有可见手部保持一致 |

---

**创建日期**: 2026-02-22
**状态**: 待制作
**总片段**: 24个
**预计AI生成时间**: 约24次调用
