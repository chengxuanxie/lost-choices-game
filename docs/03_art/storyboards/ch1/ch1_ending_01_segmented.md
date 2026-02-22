---
video_id: ch1_ending_01
scene_id: 
scene_name: 结局: 信任的开始
chapter: ch1
total_duration_seconds: 300
video_path: res://assets/videos/ch1/ending_01/
node_id: ch1_ending_01

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

# [CH1_ENDING_01] 结局: 信任的开始 - 分镜脚本 (分段版)

> 与林晓薇建立信任，一起调查真相
> **总时长**: 300秒 / **片段数**: 20个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 选择后的平静 (0-45秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 选择后的平静 - 片段1 | `First person POV, beginning to calm after decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 选择后的平静 - 片段2 | `First person POV, calm after decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 选择后的平静 - 片段3 | `First person POV, intensifying calm after decision, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 建立信任 (45-90秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_004 | 15s | 建立信任 - 片段1 | `First person POV, beginning to building trust, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_005 | 15s | 建立信任 - 片段2 | `First person POV, building trust, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_006 | 15s | 建立信任 - 片段3 | `First person POV, intensifying building trust, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 3: 共同目标 (90-135秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 共同目标 - 片段1 | `First person POV, beginning to shared purpose, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_008 | 15s | 共同目标 - 片段2 | `First person POV, shared purpose, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_009 | 15s | 共同目标 - 片段3 | `First person POV, intensifying shared purpose, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 合作开始 (135-180秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_010 | 15s | 合作开始 - 片段1 | `First person POV, beginning to cooperation begins, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 合作开始 - 片段2 | `First person POV, cooperation begins, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 合作开始 - 片段3 | `First person POV, intensifying cooperation begins, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 5: 希望涌现 (180-210秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 希望涌现 - 片段1 | `First person POV, beginning to hope emerging, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 希望涌现 - 片段2 | `First person POV, hope emerging, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 展望未来 (210-240秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_015 | 15s | 展望未来 - 片段1 | `First person POV, beginning to looking to future, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_016 | 15s | 展望未来 - 片段2 | `First person POV, looking to future, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 7: 新的开始 (240-270秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 新的开始 - 片段1 | `First person POV, beginning to new beginning, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 新的开始 - 片段2 | `First person POV, new beginning, cinematic, atmospheric, 4K, 16:9` | env_main |

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
"ch1_ending_01": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/ending_01/",
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
