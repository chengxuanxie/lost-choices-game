---
video_id: ch1_sc_008
scene_id: SC-008
scene_name: 天台
chapter: ch1
total_duration_seconds: 420
video_path: res://assets/videos/ch1/sc_008/
node_id: ch1_sc_008

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 28

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_008/sc_008_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_008/sc_008_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_008] 天台 - 分镜脚本 (分段版)

> 在天台上做出最终选择
> **总时长**: 420秒 / **片段数**: 28个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 登上天台 (0-60秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 登上天台 - 片段1 | `First person POV, beginning to climbing to rooftop, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 登上天台 - 片段2 | `First person POV, climbing to rooftop, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 登上天台 - 片段3 | `First person POV, intensifying climbing to rooftop, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 登上天台 - 片段4 | `First person POV, continuing to climbing to rooftop, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 俯瞰城市 (60-120秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 俯瞰城市 - 片段1 | `First person POV, beginning to overlooking city, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 俯瞰城市 - 片段2 | `First person POV, overlooking city, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 俯瞰城市 - 片段3 | `First person POV, intensifying overlooking city, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 俯瞰城市 - 片段4 | `First person POV, continuing to overlooking city, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 回顾历程 (120-180秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 回顾历程 - 片段1 | `First person POV, beginning to reflecting on journey, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_010 | 15s | 回顾历程 - 片段2 | `First person POV, reflecting on journey, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 回顾历程 - 片段3 | `First person POV, intensifying reflecting on journey, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 回顾历程 - 片段4 | `First person POV, continuing to reflecting on journey, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 最终对话 (180-240秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 最终对话 - 片段1 | `First person POV, beginning to final conversation, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_014 | 15s | 最终对话 - 片段2 | `First person POV, final conversation, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_015 | 15s | 最终对话 - 片段3 | `First person POV, intensifying final conversation, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_016 | 15s | 最终对话 - 片段4 | `First person POV, continuing to final conversation, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 情感高潮 (240-285秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 情感高潮 - 片段1 | `First person POV, beginning to emotional climax, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 情感高潮 - 片段2 | `First person POV, emotional climax, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_019 | 15s | 情感高潮 - 片段3 | `First person POV, intensifying emotional climax, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 真相揭示 (285-330秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_020 | 15s | 真相揭示 - 片段1 | `First person POV, beginning to truth revealed, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_021 | 15s | 真相揭示 - 片段2 | `First person POV, truth revealed, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_022 | 15s | 真相揭示 - 片段3 | `First person POV, intensifying truth revealed, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 面临抉择 (330-375秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_023 | 15s | 面临抉择 - 片段1 | `First person POV, beginning to facing choice, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_024 | 15s | 面临抉择 - 片段2 | `First person POV, facing choice, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_025 | 15s | 面临抉择 - 片段3 | `First person POV, intensifying facing choice, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 最终选择 (375-420秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_026 | 15s | 最终选择 - 片段1 | `First person POV, beginning to final decision, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_027 | 15s | 最终选择 - 片段2 | `First person POV, final decision, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_028 | 15s | 最终选择 - 片段3 | `First person POV, intensifying final decision, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...28个片段配置...]

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
"ch1_sc_008": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_008/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 420
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
**总片段**: 28个
**预计AI生成时间**: 约28次调用
