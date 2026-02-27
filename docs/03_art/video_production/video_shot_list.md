---
chapter: ch1
total_videos: 13
total_clips: 13
total_keyframes: 28
total_duration_seconds: ~2500
total_duration_minutes: ~42
last_updated: 2026-02-27
solution: video_priority
---

# 第一章视频镜头清单

> **采用视频优先方案**: 场景图+人物参考图 + 短视频
>
> **实际状态**: 视频已完成13个，关键帧仅SC-001完整

---

## 一、方案概览

| 指标 | 原方案 | 混合方案 | 节省 |
|------|--------|----------|------|
| AI视频调用 | 464次 | ~60次 | 87% |
| AI图片调用 | 0次 | ~200次 | - |
| 存储空间 | ~2.3GB | ~300MB | 87% |

### 资产分类

| 类型 | 数量 | 用途 | 技术 |
|------|------|------|------|
| 短视频 (A类) | 60个 | 关键剧情节点 | AI视频生成 |
| 关键帧 (B类) | 200张 | 普通场景 | AI图片 + Godot动画 |

---

## 二、总体概览

| 指标 | 规划 | 实际 | 状态 |
|------|------|------|------|
| 视频总数 | 18个 | 13个 | ✅ |
| 场景视频 | 13个 | 13个 | ✅ |
| 结局视频 | 5个 | 0个 | ⏳ |
| 关键帧(SC-001) | 20张 | 20张 | ✅ |
| 关键帧(其他) | - | 各1张 | ⚠️ |
| 总时长 | ~118分钟 | ~42分钟 | ✅ |

---

## 二、视频清单

### 场景视频 (13个) ✅ 已完成

| 视频ID | 场景 | 文件路径 | 状态 |
|--------|------|----------|------|
| ch1_sc_001 | SC-001 神秘房间 | `videos/ch1/sc_001/key_001.mp4` 等3个 | ✅ |
| ch1_sc_002a | SC-002 废弃仓库 | `videos/ch1/sc_002/key_001a.mp4` | ✅ |
| ch1_sc_002b | SC-002 废弃仓库 | `videos/ch1/sc_002/key_001b.mp4` | ✅ |
| ch1_sc_002c | SC-002 废弃仓库 | `videos/ch1/sc_002/key_001c.mp4` | ✅ |
| ch1_sc_003 | SC-003 城市街道 | `videos/ch1/sc_003/key_001.mp4` | ✅ |
| ch1_sc_004 | SC-004 咖啡馆 | `videos/ch1/sc_004/key_001.mp4` | ✅ |
| ch1_sc_005 | SC-005 书店 | `videos/ch1/sc_005/key_001.mp4` | ✅ |
| ch1_sc_005b | SC-005 书店 | - | ⏳ |
| ch1_sc_006 | SC-006 艺术画廊 | `videos/ch1/sc_006/key_001.mp4` | ✅ |
| ch1_sc_006b | SC-006 艺术画廊 | - | ⏳ |
| ch1_sc_007 | SC-007 安全屋 | `videos/ch1/sc_007/key_001.mp4` | ✅ |
| ch1_sc_007b | SC-007 安全屋 | - | ⏳ |
| ch1_sc_008 | SC-008 天台 | `videos/ch1/sc_008/key_001.mp4` | ✅ |

### 结局视频 (5个) ✅ 完成4个

| 视频ID | 结局名称 | 文件 | 状态 |
|--------|----------|------|------|
| ch1_ending_01 | 信任的开始 | `key_001.mp4` | ✅ |
| ch1_ending_02 | 独自前行 | `key_002.mp4` | ✅ |
| ch1_ending_03 | 治愈之路 | `key_003.mp4` | ✅ |
| ch1_ending_04 | 艺术共鸣 | `key_004.mp4` | ✅ |
| ch1_ending_05 | 危险联盟 | `key_005.mp4` | ✅ |

**类型说明**:
- **A类**: 关键场景，较多短视频 (4-5个)
- **B类**: 普通场景，少量短视频 (1-3个)，主要用关键帧+动画

---

## 三、资产存储信息

### TOS存储

| 类型 | 存储桶 | 基础URL |
|------|--------|---------|
| 视频 | lost-choices-art | `https://lost-choices-art.tos-cn-beijing.volces.com/videos/ch1/` |
| 关键帧 | lost-choices-art | `https://lost-choices-art.tos-cn-beijing.volces.com/keyframes/ch1/` |

### 本地路径

```
lost-choices/assets/videos/ch1/
├── sc_001/
│   ├── key_001.mp4   (2.8MB)
│   ├── key_002.mp4
│   └── key_003.mp4
├── sc_002/
│   ├── key_001a.mp4  (2.8MB)
│   ├── key_001b.mp4  (2.5MB)
│   └── key_001c.mp4  (3.5MB)
├── sc_003/
│   └── key_001.mp4   (2.5MB)
├── sc_004/
│   └── key_001.mp4
├── sc_005/
│   └── key_001.mp4
├── sc_006/
│   └── key_001.mp4
├── sc_007/
│   └── key_001.mp4
└── sc_008/
    └── key_001.mp4   (2.5MB)
```

### 关键帧本地路径

```
lost-choices/assets/keyframes/ch1/
├── sc_001/           (20帧完整)
│   └── frame_001.png ~ frame_020.png
├── sc_002/           (1帧)
├── sc_003/           (1帧)
├── sc_004/           (1帧)
├── sc_005/           (1帧)
├── sc_006/           (1帧)
├── sc_007/           (1帧)
├── sc_008/           (1帧)
└── endings/          (1帧)
```

---

## 四、制作优先级

### 推荐制作顺序

1. **P1 - 核心主线** (优先)
   - ch1_sc_001 (开场，最重要) - 32片段
   - ch1_sc_002a (主线分支) - 24片段
   - ch1_sc_003 (首次室外) - 40片段
   - ch1_ending_01 (主线结局) - 20片段

2. **P2 - 重要分支**
   - ch1_sc_002b/c (其他分支) - 55片段
   - ch1_sc_004~006 (角色互动) - 164片段
   - ch1_ending_02~05 (其他结局) - 80片段

3. **P3 - 补充场景**
   - ch1_sc_005b, sc_006b, sc_007b (变体场景) - 56片段

---

## 四、技术规格

| 参数 | 规范 |
|------|------|
| 分辨率 | 1920×1080 (1080p) |
| 宽高比 | 16:9 |
| 帧率 | 24fps |
| 源格式 | MP4 (H.264) |
| 目标格式 | OGV (Theora) |
| 码率 | 4-6 Mbps |
| 视角 | 第一人称 (First Person POV) |
| 单片段时长 | 10-15秒 |
| 片段命名 | clip_XXX.ogv |

---

## 五、混合视觉方案

### 架构流程
```
关键剧情节点
    ↓
[短视频 5-10秒] × 60个 (AI视频生成)
    ↓ 转码
[.ogv] 文件
    ↓ Godot
  VideoPlayer播放

普通场景
    ↓
[关键帧图片] × 200张 (AI图片生成)
    ↓ Godot Shader
  视差/缩放/光影动画
    ↓
  TextureRect + Tween切换
    ↓
  流畅场景呈现
```

### 技术方案
| 元素 | 技术 | 用途 |
|------|------|------|
| 短视频 | VideoPlayer + OGV | 关键剧情动态表现 |
| 关键帧 | TextureRect | 场景背景 |
| 切换动画 | Tween | 关键帧淡入淡出 |
| 氛围效果 | Shader | 视差、缩放、光影 |
| 过渡效果 | AnimationPlayer | 场景切换 |

### 详细方案文档
- [hybrid_visual_solution.md](./hybrid_visual_solution.md) - 混合方案详细设计
- [segment_solution.md](./segment_solution.md) - 原分段方案(备用参考)

---

## 六、参考资源

### 场景参考图

| 场景 | 参考图目录 | TOS路径 |
|------|------------|---------|
| SC-001 | [assets/scenes/ch1/sc_001](../../../assets/scenes/ch1/sc_001/) | `scenes/ch1/sc_001/` |
| SC-002 | [assets/scenes/ch1/sc_002](../../../assets/scenes/ch1/sc_002/) | `scenes/ch1/sc_002/` |
| SC-003 | [assets/scenes/ch1/sc_003](../../../assets/scenes/ch1/sc_003/) | `scenes/ch1/sc_003/` |
| SC-004 | [assets/scenes/ch1/sc_004](../../../assets/scenes/ch1/sc_004/) | `scenes/ch1/sc_004/` |
| SC-005 | [assets/scenes/ch1/sc_005](../../../assets/scenes/ch1/sc_005/) | `scenes/ch1/sc_005/` |
| SC-006 | [assets/scenes/ch1/sc_006](../../../assets/scenes/ch1/sc_006/) | `scenes/ch1/sc_006/` |
| SC-007 | [assets/scenes/ch1/sc_007](../../../assets/scenes/ch1/sc_007/) | `scenes/ch1/sc_007/` |

### 角色参考图

| 角色 | 参考图目录 | TOS路径 |
|------|------------|---------|
| 林晓薇 | [assets/characters/lin_xiaowei](../../../assets/characters/lin_xiaowei/) | `characters/lin_xiaowei/` |
| 白芷瑶 | [assets/characters/bai_zhiyao](../../../assets/characters/bai_zhiyao/) | `characters/bai_zhiyao/` |
| 沈墨染 | [assets/characters/shen_moran](../../../assets/characters/shen_moran/) | `characters/shen_moran/` |
| 叶清寒 | [assets/characters/ye_qinghan](../../../assets/characters/ye_qinghan/) | `characters/ye_qinghan/` |
| 江念 | [assets/characters/jiang_nian](../../../assets/characters/jiang_nian/) | `characters/jiang_nian/` |
| 陈远航 | [assets/characters/chen_yuanhang](../../../assets/characters/chen_yuanhang/) | `characters/chen_yuanhang/` |
| 苏雅琳 | [assets/characters/su_yalin](../../../assets/characters/su_yalin/) | `characters/su_yalin/` |

---

## 七、状态说明

| 状态 | 说明 |
|------|------|
| 📝 待制作 | 分镜/分段文档就绪，等待生成 |
| 🔄 制作中 | 正在AI生成片段 |
| ✅ 已完成 | 所有片段已生成、转码并集成 |
| ❌ 需重做 | 片段质量不达标，需重新生成 |

---

**创建日期**: 2026-02-22
**更新日期**: 2026-02-22 (添加分段方案)
**维护人**: 视频导演
