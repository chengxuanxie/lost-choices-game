---
video_id: ch1_sc_002b
scene_id: SC-002
scene_name: 废弃仓库 - 独自行动
chapter: ch1
total_duration_seconds: 400
video_path: res://assets/videos/ch1/sc_002b/
node_id: ch1_sc_002b

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 27

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

# [CH1_SC_002B] 废弃仓库 - 独自行动 - 分镜脚本 (分段版)

> 选择独自行动，在仓库中探索
> **总时长**: 400秒 / **片段数**: 27个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 离开房间 (0-60秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 离开房间 - 片段1 | `First person POV, beginning to leaving room alone, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 离开房间 - 片段2 | `First person POV, leaving room alone, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 离开房间 - 片段3 | `First person POV, intensifying leaving room alone, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 离开房间 - 片段4 | `First person POV, continuing to leaving room alone, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 进入仓库 (60-120秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 进入仓库 - 片段1 | `First person POV, beginning to entering warehouse independently, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 进入仓库 - 片段2 | `First person POV, entering warehouse independently, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 进入仓库 - 片段3 | `First person POV, intensifying entering warehouse independently, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 进入仓库 - 片段4 | `First person POV, continuing to entering warehouse independently, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 环境观察 (120-180秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 环境观察 - 片段1 | `First person POV, beginning to scanning warehouse carefully, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_010 | 15s | 环境观察 - 片段2 | `First person POV, scanning warehouse carefully, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 环境观察 - 片段3 | `First person POV, intensifying scanning warehouse carefully, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 环境观察 - 片段4 | `First person POV, continuing to scanning warehouse carefully, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 发现线索 (180-225秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现线索 - 片段1 | `First person POV, beginning to finding clues, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_014 | 15s | 发现线索 - 片段2 | `First person POV, finding clues, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_015 | 15s | 发现线索 - 片段3 | `First person POV, intensifying finding clues, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 遇到危险 (225-270秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_016 | 15s | 遇到危险 - 片段1 | `First person POV, beginning to encountering danger, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_017 | 15s | 遇到危险 - 片段2 | `First person POV, encountering danger, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 遇到危险 - 片段3 | `First person POV, intensifying encountering danger, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 紧急躲避 (270-315秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 紧急躲避 - 片段1 | `First person POV, beginning to hiding, escaping, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_020 | 15s | 紧急躲避 - 片段2 | `First person POV, hiding, escaping, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_021 | 15s | 紧急躲避 - 片段3 | `First person POV, intensifying hiding, escaping, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 发现出口 (315-360秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_022 | 15s | 发现出口 - 片段1 | `First person POV, beginning to finding exit, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_023 | 15s | 发现出口 - 片段2 | `First person POV, finding exit, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_024 | 15s | 发现出口 - 片段3 | `First person POV, intensifying finding exit, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (360-400秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_025 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_026 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_027 | 15s | 选择时刻 - 片段3 | `First person POV, intensifying decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...27个片段配置...]

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
"ch1_sc_002b": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_002b/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 400
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
**总片段**: 27个
**预计AI生成时间**: 约27次调用
