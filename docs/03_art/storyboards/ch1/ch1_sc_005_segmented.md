---
video_id: ch1_sc_005
scene_id: SC-005
scene_name: 书店
chapter: ch1
total_duration_seconds: 480
video_path: res://assets/videos/ch1/sc_005/
node_id: ch1_sc_005

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 32

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

# [CH1_SC_005] 书店 - 分镜脚本 (分段版)

> 在书店寻找关键线索
> **总时长**: 480秒 / **片段数**: 32个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 进入书店 (0-60秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 进入书店 - 片段1 | `First person POV, beginning to entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 进入书店 - 片段2 | `First person POV, entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 进入书店 - 片段3 | `First person POV, intensifying entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 进入书店 - 片段4 | `First person POV, continuing to entering bookstore, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 浏览书籍 (60-120秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_005 | 15s | 浏览书籍 - 片段1 | `First person POV, beginning to browsing books, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_006 | 15s | 浏览书籍 - 片段2 | `First person POV, browsing books, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_007 | 15s | 浏览书籍 - 片段3 | `First person POV, intensifying browsing books, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 浏览书籍 - 片段4 | `First person POV, continuing to browsing books, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 寻找线索 (120-180秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_009 | 15s | 寻找线索 - 片段1 | `First person POV, beginning to searching for clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_010 | 15s | 寻找线索 - 片段2 | `First person POV, searching for clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_011 | 15s | 寻找线索 - 片段3 | `First person POV, intensifying searching for clues, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_012 | 15s | 寻找线索 - 片段4 | `First person POV, continuing to searching for clues, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 发现密码 (180-240秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 发现密码 - 片段1 | `First person POV, beginning to finding coded message, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_014 | 15s | 发现密码 - 片段2 | `First person POV, finding coded message, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_015 | 15s | 发现密码 - 片段3 | `First person POV, intensifying finding coded message, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_016 | 15s | 发现密码 - 片段4 | `First person POV, continuing to finding coded message, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 解读密码 (240-300秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_017 | 15s | 解读密码 - 片段1 | `First person POV, beginning to decoding message, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 解读密码 - 片段2 | `First person POV, decoding message, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_019 | 15s | 解读密码 - 片段3 | `First person POV, intensifying decoding message, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_020 | 15s | 解读密码 - 片段4 | `First person POV, continuing to decoding message, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 获取地址 (300-360秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_021 | 15s | 获取地址 - 片段1 | `First person POV, beginning to discovering location, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_022 | 15s | 获取地址 - 片段2 | `First person POV, discovering location, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_023 | 15s | 获取地址 - 片段3 | `First person POV, intensifying discovering location, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_024 | 15s | 获取地址 - 片段4 | `First person POV, continuing to discovering location, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 警觉观察 (360-420秒, 4个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_025 | 15s | 警觉观察 - 片段1 | `First person POV, beginning to alert observation, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_026 | 15s | 警觉观察 - 片段2 | `First person POV, alert observation, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_027 | 15s | 警觉观察 - 片段3 | `First person POV, intensifying alert observation, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_028 | 15s | 警觉观察 - 片段4 | `First person POV, continuing to alert observation, cinematic, atmospheric, 4K, 16:9` | env_main |

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
"ch1_sc_005": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_005/",
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
