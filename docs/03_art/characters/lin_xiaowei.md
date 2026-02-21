# 林晓薇 视觉设定

> 角色视觉参考文档，用于AI生成视频一致性保持

---

## 基本信息

| 项目 | 内容 |
|------|------|
| **角色ID** | lin_xiaowei |
| **中文名** | 林晓薇 |
| **年龄** | 26岁 |
| **职业** | 自由撰稿人 / 调查记者 |
| **身高** | 165cm |

---

## 外貌特征

### 面部特征

| 特征 | 描述 |
|------|------|
| 脸型 | 瓜子脸，线条柔和 |
| 眼睛 | 杏眼，黑色瞳孔，眼神温和坚定 |
| 眉毛 | 自然眉形，略细 |
| 鼻子 | 小巧挺直 |
| 嘴唇 | 自然唇色，微笑时嘴角上扬 |
| 肤色 | 亚洲人自然肤色，偏白皙 |

### 发型

| 项目 | 描述 |
|------|------|
| 长度 | 中长发（过肩约10cm） |
| 颜色 | 自然黑色 |
| 发质 | 柔顺直发，发尾微卷 |
| 常见造型 | 披散或半扎马尾 |

### 体型

| 项目 | 描述 |
|------|------|
| 体型 | 匀称偏瘦 |
| 气质 | 知性、干练、温和 |

---

## 服装设定

### 日常服装

| 场景 | 上装 | 下装 | 配饰 |
|------|------|------|------|
| 日常工作 | 白色衬衫 | 深蓝色牛仔裤 | 简约银色项链 |
| 休闲 | 浅灰色针织衫 | 卡其色休闲裤 | 手表 |
| 外出调查 | 黑色外套 | 深色工装裤 | 背包、笔记本 |

### 配色方案

```
主色调：
├── 上装：白色、浅灰、米色
├── 下装：深蓝、黑色、卡其色
└── 配饰：银色、深棕色

整体风格：简约知性，适合调查记者身份
```

---

## 表情参考

### 常见表情

| 表情ID | 表情名称 | 描述 | 使用场景 |
|--------|----------|------|----------|
| exp_01 | 微笑 | 温和的笑容，眼神柔和 | 初次见面、友好交流 |
| exp_02 | 严肃 | 眉头微皱，专注认真 | 分析情况、说明重要信息 |
| exp_03 | 担忧 | 眼神忧虑，嘴唇微抿 | 关心主角、遇到危险 |
| exp_04 | 坚定 | 目光坚定，下巴微抬 | 做出决定、表态支持 |
| exp_05 | 思考 | 视线略偏，若有所思 | 分析线索、回忆信息 |

---

## 参考图生成指南

### Prompt模板

**正面全身**：
```
full body portrait, Asian female, 26 years old,
black medium-length straight hair,
gentle intelligent face, warm smile,
wearing white shirt and blue jeans,
professional journalist look,
silver simple necklace,
natural lighting, 4K --seed LXW_BASE
```

**面部特写**：
```
portrait close-up, Asian female, 26 years old,
black medium-length hair framing face,
warm brown eyes, gentle smile,
soft natural lighting, high detail skin texture,
professional yet approachable, 4K
```

**表情变体**：
```
[基础Prompt], [表情描述], [场景描述], 4K --seed LXW_BASE

示例：
portrait close-up, Asian female, 26 years old,
concerned worried expression,
dark background, soft lighting, 4K
```

### 参考图清单

| 图片ID | 类型 | 描述 | 状态 |
|--------|------|------|------|
| lin_xiaowei_full | 全身 | 正面全身照 | 待生成 |
| lin_xiaowei_face_01 | 面部 | 微笑表情 | 待生成 |
| lin_xiaowei_face_02 | 面部 | 严肃表情 | 待生成 |
| lin_xiaowei_face_03 | 面部 | 担忧表情 | 待生成 |
| lin_xiaowei_face_04 | 面部 | 坚定表情 | 待生成 |
| lin_xiaowei_face_05 | 面部 | 思考表情 | 待生成 |
| lin_xiaowei_cloth_01 | 服装 | 日常装束 | 待生成 |
| lin_xiaowei_cloth_02 | 服装 | 休闲装束 | 待生成 |
| lin_xiaowei_pose_01 | 姿态 | 站立交谈 | 待生成 |
| lin_xiaowei_pose_02 | 姿态 | 查看文件 | 待生成 |

---

## 第一章出场方式

### SC-003 通讯室

林晓薇通过屏幕出现（视频通话形式）：

| 项目 | 内容 |
|------|------|
| 出现方式 | 监控屏幕上的视频通话 |
| 背景 | 不明房间，光线较暗 |
| 光线 | 正面光，屏幕光照 |
| 距离 | 胸部以上半身 |

**屏幕形象Prompt**：
```
video call screenshot, Asian female, 26 years old,
black medium-length hair, concerned expression,
white casual shirt, dark room background,
webcam quality, screen glow on face,
worried but professional, 4K --ar 16:9
```

---

## 一致性检查要点

生成新图片时，确保以下要素一致：

- [ ] 发型长度和颜色（黑色中长发）
- [ ] 面部特征（瓜子脸、杏眼）
- [ ] 服装风格（简约知性）
- [ ] 气质表现（温和坚定）
- [ ] 配饰（简约项链、手表）

---

## 禁止事项

- ❌ 不要改变发型颜色（保持黑色）
- ❌ 不要过于浓妆（保持自然妆容）
- ❌ 不要改变服装风格（保持简约）
- ❌ 不要过度美化（保持真实感）

---

**创建日期**: 2026-02-22
**状态**: 新建 - 待生成参考图
