# 视频制作管理

> 视频生产进度跟踪和资源管理
> **采用混合视觉方案**: 关键帧+程序动画 为主，短视频仅用于关键剧情

---

## 目录结构

```
video_production/
├── README.md                    # 本文件
├── video_shot_list.md           # 视频镜头清单
├── hybrid_visual_solution.md    # 混合视觉方案 (推荐)
└── segment_solution.md          # 分段生成方案 (备用)
```

---

## 方案说明

### 混合视觉方案 (当前采用)

| 类型 | 数量 | 技术 | 成本 |
|------|------|------|------|
| 短视频 | ~60个 | AI视频生成 5-10秒 | 中 |
| 关键帧 | ~200张 | AI图片生成 + Godot动画 | 低 |

**优势**:
- 成本降低87% (相比全视频方案)
- 制作周期短
- 维护成本低

### 文档说明

### video_shot_list.md
- 所有视频的技术规格和状态
- 混合方案分类 (A类/B类)
- 短视频和关键帧统计
- 进度跟踪

### hybrid_visual_solution.md
- 混合方案完整设计
- Godot着色器代码示例
- JSON配置格式
- 实施步骤

---

## 制作工作流

```
1. 准备阶段
   ├── 确认分镜脚本完整
   ├── 确认参考图可访问
   └── 划分A类/B类场景

2. 关键帧生成 (B类场景主体)
   ├── 使用 img_gen skill 生成关键帧
   ├── 基于现有参考图生成变体
   └── 上传到TOS

3. 短视频生成 (A类关键节点)
   ├── 使用 video_gen skill 生成短视频
   ├── 时长控制5-10秒
   └── 转码为OGV格式

4. 集成测试
   ├── 创建KeyframeScene组件
   ├── 编写Shader效果
   └── 测试场景切换

5. 更新状态
   └── 更新 video_shot_list.md 状态
```

---

## 相关资源

| 资源 | 路径 |
|------|------|
| 分镜脚本 | [../storyboards/](../storyboards/) |
| 对话脚本 | [../scripts/](../scripts/) |
| 参考图(TOS) | `https://lost-choices-art.tos-cn-beijing.volces.com/` |
| 游戏数据 | `lost-choices/data/stories/chapter_01.json` |

---

**创建日期**: 2026-02-22
