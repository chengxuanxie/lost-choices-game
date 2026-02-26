---
video_id: ch1_sc_005b
scene_id: SC-005
scene_name: SC-005 书店
chapter: ch1
duration_seconds: 300
has_voice_over: true
has_dialogue: true
has_subtitles: true
language: zh-CN
---

# [CH1_SC_005B] SC-005 书店 - 对话/字幕脚本

> 白芷瑶提出可以帮助主角

---

## 一、角色配置

### 声音类型

| 角色 | 声音类型 | 特点 |
|------|----------|------|
| 主角（内心独白） | 沉稳中性 | 带轻微回响效果，犹豫、期待 |
| 白芷瑶 | 温柔女声 | 治愈、专业、真诚 |
| 老张 | 苍老男声 | 和蔼、睿智 |

---

## 二、详细脚本

### Segment 1: 深入交谈 (0-100秒)

#### 时间轴: 0:05-0:30
```yaml
id: VO_001
speaker: 主角 (内心)
type: inner_monologue
start_time: 5
end_time: 30
emotion: uncertain
text: |
  她说可以帮助我...
  我应该相信她吗？
  但她的眼神...是真诚的...
audio_note: |
  犹豫的语气
  思考的感觉
  回响效果
```

#### 时间轴: 0:30-1:00
```yaml
id: DIA_BZY_001
speaker: 白芷瑶
type: dialogue
start_time: 30
end_time: 60
emotion: explaining
text: |
  我知道你现在的感受。
  困惑、恐惧、不知道该相信谁...
  这些都是正常的反应。
audio_note: |
  专业的心理咨询语气
  温柔理解
  语速中等
```

#### 时间轴: 1:00-1:40
```yaml
id: DIA_BZY_002
speaker: 白芷瑶
type: dialogue
start_time: 60
end_time: 100
emotion: sincere
text: |
  我不是"黄昏"的人。
  我只是一个普通人...恰好认识你。
  如果可以...我想帮你找回自己。
audio_note: |
  真诚的表白
  "找回自己"略作停顿
  带着温柔
```

---

### Segment 2: 提供帮助 (100-200秒)

#### 时间轴: 1:40-2:10
```yaml
id: DIA_LZ_001
speaker: 老张
type: dialogue
start_time: 100
end_time: 130
emotion: approving
text: |
  白医生是个好人。
  她帮助过很多人。
  你可以考虑她的提议。
audio_note: |
  赞许的语气
  语速较慢
  带着信任
```

#### 时间轴: 2:10-2:40
```yaml
id: VO_002
speaker: 主角 (内心)
type: inner_monologue
start_time: 130
end_time: 160
emotion: considering
text: |
  老张也这么说...
  也许...我真的可以信任她...
  但我现在还有太多事情没弄清楚...
audio_note: |
  思考的语气
  带着犹豫
  语速中等
```

#### 时间轴: 2:40-3:20
```yaml
id: DIA_BZY_003
speaker: 白芷瑶
type: dialogue
start_time: 160
end_time: 200
emotion: offering
text: |
  我不要求你现在就决定。
  但如果你需要帮助...
  这是我的联系方式。
  任何时候...都可以来找我。
audio_note: |
  提供帮助的语气
  不强求的感觉
  温柔而坚定
```

---

### Segment 3: 选择时刻 (200-300秒)

#### 时间轴: 3:20-3:50
```yaml
id: DIA_LZ_002
speaker: 老张
type: dialogue
start_time: 200
end_time: 230
emotion: wise
text: |
  年轻人，记住一件事。
  接受帮助不是软弱。
  有时候，独自承担才是真正的逃避。
audio_note: |
  智者的语气
  每句话略作停顿
  带着深意
```

#### 时间轴: 3:50-4:20
```yaml
id: VO_003
speaker: 主角 (内心)
type: inner_monologue
start_time: 230
end_time: 260
emotion: deciding
text: |
  接受帮助...还是继续独自前行...
  每个选择都会带来不同的路...
  我需要做出决定...
audio_note: |
  决策的时刻
  语速略慢
  带着思考
```

#### 时间轴: 4:20-5:00
```yaml
id: DIA_BZY_004
speaker: 白芷瑶
type: dialogue
start_time: 260
end_time: 300
emotion: waiting
text: |
  不管你做什么选择...
  我都希望你找到答案。
  现在...告诉我你的决定。
audio_note: |
  等待的语气
  不带压力
  温柔而真诚
```

---

## 三、玩家选择字幕

### 选择 #1
```yaml
id: CHOICE_001
speaker: 系统
type: choice
display_time: 280
choice_id: choice_021
text: "好，我愿意接受你的帮助"
effects:
  - modify_relationship: bai_zhiyao +15
  - set_flag: accepted_bai_help = true
  - set_variable: healing_path = 1
next_node: ch1_sc_008
hover_text: "接受白芷瑶的帮助，开启治愈路线"
```

### 选择 #2
```yaml
id: CHOICE_002
speaker: 系统
type: choice
display_time: 280
choice_id: choice_022
text: "谢谢，但我还有事要处理"
effects:
  - set_flag: declined_bai_help = true
next_node: ch1_sc_008
hover_text: "婉拒帮助，继续自己的旅程"
```

---

## 四、选择触发对话

### 选择A触发
```yaml
id: DIA_CHOICE_A
speaker: 主角
type: dialogue
text: "好...我愿意接受你的帮助。"
follow_up:
  speaker: 白芷瑶
  emotion: pleased
  text: |
    谢谢你的信任。
    这是一个很好的开始。
    明天来我的诊所，我们好好谈谈。
    我会尽我所能...帮你找回自己。
```

### 选择B触发
```yaml
id: DIA_CHOICE_B
speaker: 主角
type: dialogue
text: "谢谢你的好意。但我还有事要处理。"
follow_up:
  speaker: 白芷瑶
  emotion: understanding
  text: |
    我理解。
    每个人都有自己的路要走。
    如果改变主意...随时可以来找我。
    保重。
```

---

## 五、音效时序

| 时间 | 音效 | 类型 | 音量 | 描述 |
|------|------|------|------|------|
| 0:00 | bookstore_ambient | 环境 | 30% | 书店安静氛围 |
| 1:00 | book_close | 效果 | 25% | 合上书本声 |
| 2:40 | paper_slide | 效果 | 30% | 递名片声 |
| 4:40 | choice_appear | 效果 | 60% | 选择界面出现音效 |

---

## 六、字幕文件导出 (SRT格式)

```srt
1
00:00:05,000 --> 00:00:30,000
（内心独白）
她说可以帮助我...
我应该相信她吗？
但她的眼神...是真诚的...

2
00:00:30,000 --> 00:01:00,000
（白芷瑶）
我知道你现在的感受。
困惑、恐惧、不知道该相信谁...
这些都是正常的反应。

3
00:01:00,000 --> 00:01:40,000
（白芷瑶）
我不是"黄昏"的人。
我只是一个普通人...恰好认识你。
如果可以...我想帮你找回自己。

4
00:01:40,000 --> 00:02:10,000
（老张）
白医生是个好人。
她帮助过很多人。
你可以考虑她的提议。

5
00:02:40,000 --> 00:03:20,000
（白芷瑶）
我不要求你现在就决定。
但如果你需要帮助...
这是我的联系方式。
任何时候...都可以来找我。

6
00:03:20,000 --> 00:03:50,000
（老张）
年轻人，记住一件事。
接受帮助不是软弱。
有时候，独自承担才是真正的逃避。

7
00:04:20,000 --> 00:05:00,000
（白芷瑶）
不管你做什么选择...
我都希望你找到答案。
现在...告诉我你的决定。
```

---

## 七、配音注意事项

### 主角内心独白
1. **情绪层次**: 犹豫 → 思考 → 决断
2. **语速**: 中等偏慢（0.85x）
3. **特殊处理**: 所有内心独白添加轻微回响效果

### 白芷瑶
1. **声音特点**: 温柔治愈，专业而有同理心
2. **情绪变化**: 解释 → 真诚 → 提议 → 等待
3. **关键词**: "帮助"、"找回自己"、"任何时候"

### 老张
1. **声音特点**: 智者风范，话中有话
2. **情绪变化**: 赞许 → 劝告

---

## 八、场景特点说明

### 剧情要点
- 白芷瑶正式提出帮助
- 建立治愈线的入口
- 老张作为信任背书

### 好感度影响
| 选择 | 白芷瑶好感度 | 后续影响 |
|------|-------------|----------|
| 接受帮助 | +15 | 开启治愈结局路线 |
| 婉拒 | 0 | 保持独立路线 |

---

**创建日期**: 2026-02-26
**更新日期**: 2026-02-26
**状态**: ✅ 对话脚本完成
**配音状态**: ⏳ 待录制
