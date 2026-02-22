---
video_id: ch1_ending_03
scene_id: 
scene_name: 结局: 放弃与遗忘
chapter: ch1
total_duration_seconds: 300
video_path: res://assets/videos/ch1/ending_03/
node_id: ch1_ending_03

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 20

# 参考图URLs
reference_images:
  # 此场景无特定参考图配置

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_ENDING_03] 结局: 放弃与遗忘 - 分镜脚本 (分段版)

> 选择放弃，回归普通生活
> **总时长**: 300秒 / **片段数**: 20个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 选择后的释然 (0-45秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 选择后的释然 - 片段1 | `First person POV, beginning to relief after decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 选择后的释然 - 片段2 | `First person POV, relief after decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 选择后的释然 - 片段3 | `First person POV, intensifying relief after decision, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 放下过去 (45-90秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_004 | 15s | 放下过去 - 片段1 | `First person POV, beginning to letting go, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_005 | 15s | 放下过去 - 片段2 | `First person POV, letting go, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_006 | 15s | 放下过去 - 片段3 | `First person POV, intensifying letting go, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 3: 回归日常 (90-135秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 回归日常 - 片段1 | `First person POV, beginning to returning to normal, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_008 | 15s | 回归日常 - 片段2 | `First person POV, returning to normal, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_009 | 15s | 回归日常 - 片段3 | `First person POV, intensifying returning to normal, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 刻意遗忘 (135-180秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_010 | 15s | 刻意遗忘 - 片段1 | `First person POV, beginning to choosing to forget, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 刻意遗忘 - 片段2 | `First person POV, choosing to forget, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 刻意遗忘 - 片段3 | `First person POV, intensifying choosing to forget, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 5: 平静表面 (180-210秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 平静表面 - 片段1 | `First person POV, beginning to calm surface, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 平静表面 - 片段2 | `First person POV, calm surface, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 内心暗流 (210-240秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_015 | 15s | 内心暗流 - 片段1 | `First person POV, beginning to hidden feelings, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_016 | 15s | 内心暗流 - 片段2 | `First person POV, hidden feelings, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 7: 生活继续 (240-270秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 生活继续 - 片段1 | `First person POV, beginning to life continues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 生活继续 - 片段2 | `First person POV, life continues, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 结局定格 (270-300秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 结局定格 - 片段1 | `First person POV, beginning to ending moment, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_020 | 15s | 结局定格 - 片段2 | `First person POV, ending moment, cinematic, atmospheric, 4K, 16:9` | env_main |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...20个片段配置...]

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
"ch1_ending_03": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/ending_03/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 300
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
**总片段**: 20个
**预计AI生成时间**: 约20次调用
