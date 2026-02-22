---
video_id: ch1_sc_004
scene_id: SC-004
scene_name: 咖啡馆
chapter: ch1
total_duration_seconds: 720
video_path: res://assets/videos/ch1/sc_004/
node_id: ch1_sc_004

# 分片配置
segmentation:
  enabled: true
  clip_duration_target: 15
  total_clips: 48

# 参考图URLs
reference_images:
  env_main: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_004/sc_004_env_01.png
  env_alt: https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_004/sc_004_env_02.png

# 视觉风格
style:
  type: cinematic_first_person
  mood: mysterious
  lighting: cinematic, dramatic shadows
  color_palette: [dark_blue, warm_gold, shadow_black]
---

# [CH1_SC_004] 咖啡馆 - 分镜脚本 (分段版)

> 在咖啡馆获取情报，寻找线索
> **总时长**: 720秒 / **片段数**: 48个 / **单片段**: ~15秒

---

## 一、片段清单

### Phase 1: 进入咖啡馆 (0-90秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_001 | 15s | 进入咖啡馆 - 片段1 | `First person POV, beginning to entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_002 | 15s | 进入咖啡馆 - 片段2 | `First person POV, entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_003 | 15s | 进入咖啡馆 - 片段3 | `First person POV, intensifying entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_004 | 15s | 进入咖啡馆 - 片段4 | `First person POV, continuing to entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_005 | 15s | 进入咖啡馆 - 片段5 | `First person POV, beginning to entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_006 | 15s | 进入咖啡馆 - 片段6 | `First person POV, entering cafe, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 2: 观察环境 (90-180秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_007 | 15s | 观察环境 - 片段1 | `First person POV, beginning to observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_008 | 15s | 观察环境 - 片段2 | `First person POV, observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_009 | 15s | 观察环境 - 片段3 | `First person POV, intensifying observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_010 | 15s | 观察环境 - 片段4 | `First person POV, continuing to observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_011 | 15s | 观察环境 - 片段5 | `First person POV, beginning to observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_012 | 15s | 观察环境 - 片段6 | `First person POV, observing cafe interior, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 3: 寻找目标 (180-270秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_013 | 15s | 寻找目标 - 片段1 | `First person POV, beginning to looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_014 | 15s | 寻找目标 - 片段2 | `First person POV, looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_015 | 15s | 寻找目标 - 片段3 | `First person POV, intensifying looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_016 | 15s | 寻找目标 - 片段4 | `First person POV, continuing to looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_017 | 15s | 寻找目标 - 片段5 | `First person POV, beginning to looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_018 | 15s | 寻找目标 - 片段6 | `First person POV, looking for contact, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 4: 接头对话 (270-360秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_019 | 15s | 接头对话 - 片段1 | `First person POV, beginning to meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_020 | 15s | 接头对话 - 片段2 | `First person POV, meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_021 | 15s | 接头对话 - 片段3 | `First person POV, intensifying meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_022 | 15s | 接头对话 - 片段4 | `First person POV, continuing to meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_023 | 15s | 接头对话 - 片段5 | `First person POV, beginning to meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_024 | 15s | 接头对话 - 片段6 | `First person POV, meeting contact, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 5: 获取情报 (360-450秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_025 | 15s | 获取情报 - 片段1 | `First person POV, beginning to receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_026 | 15s | 获取情报 - 片段2 | `First person POV, receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_027 | 15s | 获取情报 - 片段3 | `First person POV, intensifying receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_028 | 15s | 获取情报 - 片段4 | `First person POV, continuing to receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_029 | 15s | 获取情报 - 片段5 | `First person POV, beginning to receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_030 | 15s | 获取情报 - 片段6 | `First person POV, receiving information, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 6: 分析情报 (450-540秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_031 | 15s | 分析情报 - 片段1 | `First person POV, beginning to processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_032 | 15s | 分析情报 - 片段2 | `First person POV, processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_033 | 15s | 分析情报 - 片段3 | `First person POV, intensifying processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_034 | 15s | 分析情报 - 片段4 | `First person POV, continuing to processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_035 | 15s | 分析情报 - 片段5 | `First person POV, beginning to processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_036 | 15s | 分析情报 - 片段6 | `First person POV, processing information, cinematic, atmospheric, 4K, 16:9` | env_alt |

### Phase 7: 发现异常 (540-630秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_037 | 15s | 发现异常 - 片段1 | `First person POV, beginning to noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_038 | 15s | 发现异常 - 片段2 | `First person POV, noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_039 | 15s | 发现异常 - 片段3 | `First person POV, intensifying noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_040 | 15s | 发现异常 - 片段4 | `First person POV, continuing to noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_041 | 15s | 发现异常 - 片段5 | `First person POV, beginning to noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |
| clip_042 | 15s | 发现异常 - 片段6 | `First person POV, noticing something wrong, cinematic, atmospheric, 4K, 16:9` | env_main |

### Phase 8: 选择时刻 (630-720秒, 6个片段)

| 片段 | 时长 | 描述 | AI Prompt | 参考图 |
|------|------|------|-----------|--------|
| clip_043 | 15s | 选择时刻 - 片段1 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_044 | 15s | 选择时刻 - 片段2 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_045 | 15s | 选择时刻 - 片段3 | `First person POV, intensifying decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_046 | 15s | 选择时刻 - 片段4 | `First person POV, continuing to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_047 | 15s | 选择时刻 - 片段5 | `First person POV, beginning to decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |
| clip_048 | 15s | 选择时刻 - 片段6 | `First person POV, decision point, cinematic, atmospheric, 4K, 16:9` | env_alt |

---

## 二、批量生成脚本

### 生成命令模板
```python
# 批量生成所有片段
clips = [...48个片段配置...]

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
"ch1_sc_004": {
  "video": {
    "type": "playlist",
    "clips_dir": "res://assets/videos/ch1/sc_004/",
    "clips": [
      {"file": "clip_001.ogv", "duration": 15},
      {"file": "clip_002.ogv", "duration": 15},
      ...
    ],
    "total_duration": 720
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
**总片段**: 48个
**预计AI生成时间**: 约48次调用
