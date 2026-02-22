# 视频分镜脚本目录

> 第一章视频分镜脚本，用于AI视频生成
> **采用分段方案**: 每个视频拆分为~15秒片段，详见 `_segmented.md` 文件

---

## 目录结构

```
storyboards/
├── TEMPLATE.md          # 分镜脚本模板
├── generate_segmented.py # 分段脚本生成工具
└── ch1/                 # 第一章
    ├── ch1_sc_001.md     # SC-001 神秘房间 (原始版)
    ├── ch1_sc_001_segmented.md  # SC-001 分段版 (推荐使用)
    ├── ch1_sc_002a.md    # SC-002 废弃仓库 (分支A)
    ├── ch1_sc_002a_segmented.md
    ├── ...               # 其他场景
    └── ch1_ending_*.md   # 5个结局分镜
```

---

## 文档说明

### 原始分镜 (无 `_segmented` 后缀)
- 整体叙事描述
- 大段落划分
- 用于理解剧情流程

### 分段分镜 (`_segmented` 后缀) **[推荐用于AI生成]**
- 精确到15秒的片段划分
- 每个片段独立的AI Prompt
- YAML格式参考图配置
- JSON配置示例
- 衔接注意事项

---

## AI友好特性

- YAML front matter 便于程序解析
- 参考图URL直接指向TOS公网地址
- Prompt模板可直接复制使用
- 时间戳精确到秒
- 分段版本支持批量生成

---

**创建日期**: 2026-02-22
