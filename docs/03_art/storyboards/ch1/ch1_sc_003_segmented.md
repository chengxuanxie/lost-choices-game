---
video_id: ch1_sc_003
scene_id: SC-003
scene_name: 城市街道 - 追逐
chapter: ch1
total_duration_seconds: 600
video_path: res://assets/videos/ch1/sc_003/
node_id: ch1_sc_003

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 40

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_003/sc_003_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_003/sc_003_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_003] 城市街道 - 追逐 - 分镜脚本 (分段版)

> 黑衣人追来，林晓薇带领主角逃亡
> **总时长**: 600秒 / **片段数**: 40个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 发现追踪 (0-75秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 发现追踪 - 片段1 | `First person POV, beginning to noticing pursuers behind, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 发现追踪 - 片段2 | `First person POV, noticing pursuers behind, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 发现追踪 - 片段3 | `First person POV, intensifying noticing pursuers behind, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 发现追踪 - 片段4 | `First person POV, continuing to noticing pursuers behind, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_005 | 15s | 发现追踪 - 片段5 | `First person POV, beginning to noticing pursuers behind, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 开始奔跑 (75-150秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_006 | 15s | 开始奔跑 - 片段1 | `First person POV, beginning to starting to run, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 开始奔跑 - 片段2 | `First person POV, starting to run, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 开始奔跑 - 片段3 | `First person POV, intensifying starting to run, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_009 | 15s | 开始奔跑 - 片段4 | `First person POV, continuing to starting to run, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_010 | 15s | 开始奔跑 - 片段5 | `First person POV, beginning to starting to run, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 街道穿梭 (150-225秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_011 | 15s | 街道穿梭 - 片段1 | `First person POV, beginning to running through streets, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 街道穿梭 - 片段2 | `First person POV, running through streets, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_013 | 15s | 街道穿梭 - 片段3 | `First person POV, intensifying running through streets, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 街道穿梭 - 片段4 | `First person POV, continuing to running through streets, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_015 | 15s | 街道穿梭 - 片段5 | `First person POV, beginning to running through streets, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 躲避追兵 (225-300秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_016 | 15s | 躲避追兵 - 片段1 | `First person POV, beginning to evading pursuers, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_017 | 15s | 躲避追兵 - 片段2 | `First person POV, evading pursuers, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_018 | 15s | 躲避追兵 - 片段3 | `First person POV, intensifying evading pursuers, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_019 | 15s | 躲避追兵 - 片段4 | `First person POV, continuing to evading pursuers, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_020 | 15s | 躲避追兵 - 片段5 | `First person POV, beginning to evading pursuers, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 小巷躲避 (300-375秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_021 | 15s | 小巷躲避 - 片段1 | `First person POV, beginning to hiding in alley, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_022 | 15s | 小巷躲避 - 片段2 | `First person POV, hiding in alley, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_023 | 15s | 小巷躲避 - 片段3 | `First person POV, intensifying hiding in alley, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_024 | 15s | 小巷躲避 - 片段4 | `First person POV, continuing to hiding in alley, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_025 | 15s | 小巷躲避 - 片段5 | `First person POV, beginning to hiding in alley, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 紧张等待 (375-450秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_026 | 15s | 紧张等待 - 片段1 | `First person POV, beginning to tense waiting, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_027 | 15s | 紧张等待 - 片段2 | `First person POV, tense waiting, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_028 | 15s | 紧张等待 - 片段3 | `First person POV, intensifying tense waiting, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_029 | 15s | 紧张等待 - 片段4 | `First person POV, continuing to tense waiting, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_030 | 15s | 紧张等待 - 片段5 | `First person POV, beginning to tense waiting, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 继续逃亡 (450-525秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_031 | 15s | 继续逃亡 - 片段1 | `First person POV, beginning to continuing escape, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_032 | 15s | 继续逃亡 - 片段2 | `First person POV, continuing escape, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_033 | 15s | 继续逃亡 - 片段3 | `First person POV, intensifying continuing escape, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_034 | 15s | 继续逃亡 - 片段4 | `First person POV, continuing to continuing escape, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_035 | 15s | 继续逃亡 - 片段5 | `First person POV, beginning to continuing escape, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 抵达安全点 (525-600秒, 5个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_036 | 15s | 抵达安全点 - 片段1 | `First person POV, beginning to reaching safety point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_037 | 15s | 抵达安全点 - 片段2 | `First person POV, reaching safety point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_038 | 15s | 抵达安全点 - 片段3 | `First person POV, intensifying reaching safety point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_039 | 15s | 抵达安全点 - 片段4 | `First person POV, continuing to reaching safety point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_040 | 15s | 抵达安全点 - 片段5 | `First person POV, beginning to reaching safety point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...40个片段配置...]

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
"ch1_sc_003": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_003/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 600
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
**总片段**: 40个
**预计AI生成时间**: 约40次调用
