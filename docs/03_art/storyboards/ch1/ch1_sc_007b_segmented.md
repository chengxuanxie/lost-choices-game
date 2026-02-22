---
video_id: ch1_sc_007b
scene_id: SC-007
scene_name: 安全屋 - 变体
chapter: ch1
total_duration_seconds: 240
video_path: res://assets/videos/ch1/sc_007b/
node_id: ch1_sc_007b

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 16

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

# [CH1_SC_007B] 安全屋 - 变体 - 分镜脚本 (分段版)

> 安全屋场景的不同发展路线
> **总时长**: 240秒 / **片段数**: 16个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 进入安全屋 (0-30秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 进入安全屋 - 片段1 | `First person POV, beginning to entering safe house, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 进入安全屋 - 片段2 | `First person POV, entering safe house, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 发现异常 (30-60秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_003 | 15s | 发现异常 - 片段1 | `First person POV, beginning to noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_004 | 15s | 发现异常 - 片段2 | `First person POV, noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 警觉搜索 (60-90秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 警觉搜索 - 片段1 | `First person POV, beginning to cautious search, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_006 | 15s | 警觉搜索 - 片段2 | `First person POV, cautious search, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 发现陷阱 (90-120秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 发现陷阱 - 片段1 | `First person POV, beginning to discovering trap, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 发现陷阱 - 片段2 | `First person POV, discovering trap, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 紧急应对 (120-150秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 紧急应对 - 片段1 | `First person POV, beginning to emergency response, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_010 | 15s | 紧急应对 - 片段2 | `First person POV, emergency response, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 脱险过程 (150-180秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_011 | 15s | 脱险过程 - 片段1 | `First person POV, beginning to escaping danger, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_012 | 15s | 脱险过程 - 片段2 | `First person POV, escaping danger, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 重新规划 (180-210秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 重新规划 - 片段1 | `First person POV, beginning to replanning, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 重新规划 - 片段2 | `First person POV, replanning, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (210-240秒, 2个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_015 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_016 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...16个片段配置...]

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
"ch1_sc_007b": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_007b/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 240
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
**总片段**: 16个
**预计AI生成时间**: 约16次调用
