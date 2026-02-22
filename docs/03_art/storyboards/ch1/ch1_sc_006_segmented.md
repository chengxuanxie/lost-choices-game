---
video_id: ch1_sc_006
scene_id: SC-006
scene_name: 艺术画廊
chapter: ch1
total_duration_seconds: 360
video_path: res://assets/videos/ch1/sc_006/
node_id: ch1_sc_006

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 24

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_006/sc_006_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_006/sc_006_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_006] 艺术画廊 - 分镜脚本 (分段版)

> 在艺术画廊发现更多真相
> **总时长**: 360秒 / **片段数**: 24个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 进入画廊 (0-45秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 进入画廊 - 片段1 | `First person POV, beginning to entering art gallery, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 进入画廊 - 片段2 | `First person POV, entering art gallery, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 进入画廊 - 片段3 | `First person POV, intensifying entering art gallery, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 欣赏作品 (45-90秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_004 | 15s | 欣赏作品 - 片段1 | `First person POV, beginning to viewing artworks, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_005 | 15s | 欣赏作品 - 片段2 | `First person POV, viewing artworks, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 欣赏作品 - 片段3 | `First person POV, intensifying viewing artworks, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 发现异样 (90-135秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 发现异样 - 片段1 | `First person POV, beginning to noticing something unusual, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_008 | 15s | 发现异样 - 片段2 | `First person POV, noticing something unusual, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_009 | 15s | 发现异样 - 片段3 | `First person POV, intensifying noticing something unusual, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 仔细观察 (135-180秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_010 | 15s | 仔细观察 - 片段1 | `First person POV, beginning to closer examination, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_011 | 15s | 仔细观察 - 片段2 | `First person POV, closer examination, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_012 | 15s | 仔细观察 - 片段3 | `First person POV, intensifying closer examination, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 发现隐藏信息 (180-225秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现隐藏信息 - 片段1 | `First person POV, beginning to finding hidden message, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 发现隐藏信息 - 片段2 | `First person POV, finding hidden message, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_015 | 15s | 发现隐藏信息 - 片段3 | `First person POV, intensifying finding hidden message, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 联系过去 (225-270秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_016 | 15s | 联系过去 - 片段1 | `First person POV, beginning to connecting to past, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_017 | 15s | 联系过去 - 片段2 | `First person POV, connecting to past, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_018 | 15s | 联系过去 - 片段3 | `First person POV, intensifying connecting to past, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 真相浮现 (270-315秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 真相浮现 - 片段1 | `First person POV, beginning to truth emerging, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_020 | 15s | 真相浮现 - 片段2 | `First person POV, truth emerging, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_021 | 15s | 真相浮现 - 片段3 | `First person POV, intensifying truth emerging, cinematic, atmospheric, 4K, 16:9` | env_main |

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
"ch1_sc_006": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_006/",
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
