---
video_id: ch1_sc_005b
scene_id: SC-005
scene_name: 书店 - 变体
chapter: ch1
total_duration_seconds: 300
video_path: res://assets/videos/ch1/sc_005b/
node_id: ch1_sc_005b

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 20

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_005/sc_005_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_005/sc_005_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_005B] 书店 - 变体 - 分镜脚本 (分段版)

> 书店场景的不同发展路线
> **总时长**: 300秒 / **片段数**: 20个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 进入书店 (0-45秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 进入书店 - 片段1 | `First person POV, beginning to entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 进入书店 - 片段2 | `First person POV, entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 进入书店 - 片段3 | `First person POV, intensifying entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 遇到店主 (45-90秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_004 | 15s | 遇到店主 - 片段1 | `First person POV, beginning to meeting bookstore owner, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_005 | 15s | 遇到店主 - 片段2 | `First person POV, meeting bookstore owner, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 遇到店主 - 片段3 | `First person POV, intensifying meeting bookstore owner, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 对话交流 (90-135秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 对话交流 - 片段1 | `First person POV, beginning to conversation with owner, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_008 | 15s | 对话交流 - 片段2 | `First person POV, conversation with owner, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_009 | 15s | 对话交流 - 片段3 | `First person POV, intensifying conversation with owner, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 获取提示 (135-180秒, 3个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_010 | 15s | 获取提示 - 片段1 | `First person POV, beginning to receiving hint, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_011 | 15s | 获取提示 - 片段2 | `First person POV, receiving hint, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_012 | 15s | 获取提示 - 片段3 | `First person POV, intensifying receiving hint, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 发现秘密 (180-210秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现秘密 - 片段1 | `First person POV, beginning to discovering secret, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 发现秘密 - 片段2 | `First person POV, discovering secret, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 确认线索 (210-240秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_015 | 15s | 确认线索 - 片段1 | `First person POV, beginning to confirming clue, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_016 | 15s | 确认线索 - 片段2 | `First person POV, confirming clue, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 准备离开 (240-270秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 准备离开 - 片段1 | `First person POV, beginning to preparing to leave, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 准备离开 - 片段2 | `First person POV, preparing to leave, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (270-300秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_020 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

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
"ch1_sc_005b": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_005b/",
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
