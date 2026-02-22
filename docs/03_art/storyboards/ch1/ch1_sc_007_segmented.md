---
video_id: ch1_sc_007
scene_id: SC-007
scene_name: 安全屋
chapter: ch1
total_duration_seconds: 480
video_path: res://assets/videos/ch1/sc_007/
node_id: ch1_sc_007

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 32

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_007/sc_007_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_007/sc_007_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_007] 安全屋 - 分镜脚本 (分段版)

> 抵达安全屋，整理线索
> **总时长**: 480秒 / **片段数**: 32个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 抵达安全屋 (0-60秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 抵达安全屋 - 片段1 | `First person POV, beginning to arriving at safe house, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 抵达安全屋 - 片段2 | `First person POV, arriving at safe house, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 抵达安全屋 - 片段3 | `First person POV, intensifying arriving at safe house, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 抵达安全屋 - 片段4 | `First person POV, continuing to arriving at safe house, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 进入室内 (60-120秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 进入室内 - 片段1 | `First person POV, beginning to entering interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 进入室内 - 片段2 | `First person POV, entering interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 进入室内 - 片段3 | `First person POV, intensifying entering interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 进入室内 - 片段4 | `First person POV, continuing to entering interior, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 检查安全 (120-180秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 检查安全 - 片段1 | `First person POV, beginning to checking for safety, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_010 | 15s | 检查安全 - 片段2 | `First person POV, checking for safety, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 检查安全 - 片段3 | `First person POV, intensifying checking for safety, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 检查安全 - 片段4 | `First person POV, continuing to checking for safety, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 整理思绪 (180-240秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 整理思绪 - 片段1 | `First person POV, beginning to gathering thoughts, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_014 | 15s | 整理思绪 - 片段2 | `First person POV, gathering thoughts, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_015 | 15s | 整理思绪 - 片段3 | `First person POV, intensifying gathering thoughts, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_016 | 15s | 整理思绪 - 片段4 | `First person POV, continuing to gathering thoughts, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 分析线索 (240-300秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 分析线索 - 片段1 | `First person POV, beginning to analyzing clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 分析线索 - 片段2 | `First person POV, analyzing clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_019 | 15s | 分析线索 - 片段3 | `First person POV, intensifying analyzing clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_020 | 15s | 分析线索 - 片段4 | `First person POV, continuing to analyzing clues, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 规划下一步 (300-360秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_021 | 15s | 规划下一步 - 片段1 | `First person POV, beginning to planning next steps, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_022 | 15s | 规划下一步 - 片段2 | `First person POV, planning next steps, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_023 | 15s | 规划下一步 - 片段3 | `First person POV, intensifying planning next steps, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_024 | 15s | 规划下一步 - 片段4 | `First person POV, continuing to planning next steps, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 准备行动 (360-420秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_025 | 15s | 准备行动 - 片段1 | `First person POV, beginning to preparing for action, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_026 | 15s | 准备行动 - 片段2 | `First person POV, preparing for action, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_027 | 15s | 准备行动 - 片段3 | `First person POV, intensifying preparing for action, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_028 | 15s | 准备行动 - 片段4 | `First person POV, continuing to preparing for action, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (420-480秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_029 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_030 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_031 | 15s | 选择时刻 - 片段3 | `First person POV, intensifying decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_032 | 15s | 选择时刻 - 片段4 | `First person POV, continuing to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...32个片段配置...]

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
"ch1_sc_007": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_007/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 480
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
**总片段**: 32个
**预计AI生成时间**: 约32次调用
