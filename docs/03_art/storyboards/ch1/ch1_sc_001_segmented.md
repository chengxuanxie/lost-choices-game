---
video_id: ch1_sc_001
scene_id: SC-001
scene_name: 神秘房间
chapter: ch1
total_duration_seconds: 480
video_path: res://assets/videos/ch1/sc_001/
node_id: ch1_sc_001

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 32

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_001] 神秘房间 - 分镜脚本 (分段版)

> 主角在陌生房间醒来，探索环境，神秘人通过广播出现
> **总时长**: 480秒 / **片段数**: 32个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 醒来 (0-60秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 醒来 - 片段1 | `First person POV, beginning to waking up, blurry vision clearing, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 醒来 - 片段2 | `First person POV, waking up, blurry vision clearing, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 醒来 - 片段3 | `First person POV, intensifying waking up, blurry vision clearing, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 醒来 - 片段4 | `First person POV, continuing to waking up, blurry vision clearing, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 观察 (60-120秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 观察 - 片段1 | `First person POV, beginning to looking around room, observing details, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 观察 - 片段2 | `First person POV, looking around room, observing details, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 观察 - 片段3 | `First person POV, intensifying looking around room, observing details, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 观察 - 片段4 | `First person POV, continuing to looking around room, observing details, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 起身探索 (120-180秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 起身探索 - 片段1 | `First person POV, beginning to getting up, exploring room, cinematic, atmospheric, 4K, 16:9` | detail_bed |
| clip_010 | 15s | 起身探索 - 片段2 | `First person POV, getting up, exploring room, cinematic, atmospheric, 4K, 16:9` | detail_bed |
| clip_011 | 15s | 起身探索 - 片段3 | `First person POV, intensifying getting up, exploring room, cinematic, atmospheric, 4K, 16:9` | detail_bed |
| clip_012 | 15s | 起身探索 - 片段4 | `First person POV, continuing to getting up, exploring room, cinematic, atmospheric, 4K, 16:9` | detail_bed |

### Phase 4: 发现物品 (180-240秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现物品 - 片段1 | `First person POV, beginning to finding objects, wallet, keys, note, cinematic, atmospheric, 4K, 16:9` | detail_door |
| clip_014 | 15s | 发现物品 - 片段2 | `First person POV, finding objects, wallet, keys, note, cinematic, atmospheric, 4K, 16:9` | detail_door |
| clip_015 | 15s | 发现物品 - 片段3 | `First person POV, intensifying finding objects, wallet, keys, note, cinematic, atmospheric, 4K, 16:9` | detail_door |
| clip_016 | 15s | 发现物品 - 片段4 | `First person POV, continuing to finding objects, wallet, keys, note, cinematic, atmospheric, 4K, 16:9` | detail_door |

### Phase 5: 尝试离开 (240-300秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 尝试离开 - 片段1 | `First person POV, beginning to trying to leave, door locked, cinematic, atmospheric, 4K, 16:9` | detail_window |
| clip_018 | 15s | 尝试离开 - 片段2 | `First person POV, trying to leave, door locked, cinematic, atmospheric, 4K, 16:9` | detail_window |
| clip_019 | 15s | 尝试离开 - 片段3 | `First person POV, intensifying trying to leave, door locked, cinematic, atmospheric, 4K, 16:9` | detail_window |
| clip_020 | 15s | 尝试离开 - 片段4 | `First person POV, continuing to trying to leave, door locked, cinematic, atmospheric, 4K, 16:9` | detail_window |

### Phase 6: 发现符号 (300-360秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_021 | 15s | 发现符号 - 片段1 | `First person POV, beginning to noticing mysterious symbols, cinematic, atmospheric, 4K, 16:9` | detail_symbols |
| clip_022 | 15s | 发现符号 - 片段2 | `First person POV, noticing mysterious symbols, cinematic, atmospheric, 4K, 16:9` | detail_symbols |
| clip_023 | 15s | 发现符号 - 片段3 | `First person POV, intensifying noticing mysterious symbols, cinematic, atmospheric, 4K, 16:9` | detail_symbols |
| clip_024 | 15s | 发现符号 - 片段4 | `First person POV, continuing to noticing mysterious symbols, cinematic, atmospheric, 4K, 16:9` | detail_symbols |

### Phase 7: 神秘人出现 (360-420秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_025 | 15s | 神秘人出现 - 片段1 | `First person POV, beginning to mysterious voice appears, cinematic, atmospheric, 4K, 16:9` | lighting |
| clip_026 | 15s | 神秘人出现 - 片段2 | `First person POV, mysterious voice appears, cinematic, atmospheric, 4K, 16:9` | lighting |
| clip_027 | 15s | 神秘人出现 - 片段3 | `First person POV, intensifying mysterious voice appears, cinematic, atmospheric, 4K, 16:9` | lighting |
| clip_028 | 15s | 神秘人出现 - 片段4 | `First person POV, continuing to mysterious voice appears, cinematic, atmospheric, 4K, 16:9` | lighting |

### Phase 8: 对话与选择 (420-480秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_029 | 15s | 对话与选择 - 片段1 | `First person POV, beginning to listening, making decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_030 | 15s | 对话与选择 - 片段2 | `First person POV, listening, making decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_031 | 15s | 对话与选择 - 片段3 | `First person POV, intensifying listening, making decision, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_032 | 15s | 对话与选择 - 片段4 | `First person POV, continuing to listening, making decision, cinematic, atmospheric, 4K, 16:9` | env_main |

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
"ch1_sc_001": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_001/",
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
