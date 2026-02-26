---
video_id: ch1_sc_007b
scene_id: SC-007
scene_name: SC-007 安全屋
chapter: ch1
duration_seconds: 240
has_voice_over: true
has_dialogue: true
has_subtitles: true
language: zh-CN
---

# [CH1_SC_007B] SC-007 安全屋 - 对话/字幕脚本

> 叶清寒透露更多关于组织的信息

---

## 一、角色配置

### 声音类型

| 角色 | 声音类型 | 特点 |
|------|----------|------|
| 主角（内心独白） | 沉稳中性 | 带轻微回响效果，震惊、理解 |
| 叶清寒 | 冷峻女声 | 坦诚、复杂、略带伤痛 |

---

## 二、详细脚本

### Segment 1: 揭示更多 (0-80秒)

#### 时间轴: 0:05-0:30
```yaml
id: DIA_YQH_001
speaker: 叶清寒
type: dialogue
start_time: 5
end_time: 30
emotion: serious
text: |
  你想知道更多...很好。
  至少你没有立刻拒绝我。
  这说明你有判断力。
audio_note: |
  认可的语气
  语速中等
  带着一丝赞许
```

#### 时间轴: 0:30-1:00
```yaml
id: VO_001
speaker: 主角 (内心)
type: inner_monologue
start_time: 30
end_time: 60
emotion: listening
text: |
  她愿意告诉我更多...
  这是好事...至少她没有隐瞒...
  我需要仔细听...
audio_note: |
  专注的语气
  语速中等
  回响效果
```

#### 时间轴: 1:00-1:20
```yaml
id: DIA_YQH_002
speaker: 叶清寒
type: dialogue
start_time: 60
end_time: 80
emotion: explaining
text: |
  "黄昏"不只是一个组织。
  它是一个系统...一个控制记忆的系统。
  而你...是它的一部分。
audio_note: |
  解释的语气
  "系统"加重
  带着严肃
```

---

### Segment 2: 关于组织 (80-160秒)

#### 时间轴: 1:20-1:50
```yaml
id: DIA_YQH_003
speaker: 叶清寒
type: dialogue
start_time: 80
end_time: 110
emotion: revealing
text: |
  他们选择特定的人...清除记忆...
  然后植入新的身份...执行任务。
  当任务结束...再次清除。
  循环往复。
audio_note: |
  揭示的语气
  每句略作停顿
  带着沉重
```

#### 时间轴: 1:50-2:10
```yaml
id: VO_002
speaker: 主角 (内心)
type: inner_monologue
start_time: 110
end_time: 130
emotion: horrified
text: |
  这太可怕了...
  我也是这样被操控的吗？
  我经历了多少次这样的循环？
audio_note: |
  恐惧的感觉
  语速略快
  带着颤抖
```

#### 时间轴: 2:10-2:40
```yaml
id: DIA_YQH_004
speaker: 叶清寒
type: dialogue
start_time: 130
end_time: 160
emotion: honest
text: |
  你可能已经经历过多次了。
  但这一次...出了问题。
  你的记忆没有完全清除。
  这就是为什么他们追你。
audio_note: |
  坦诚的语气
  "出了问题"略作停顿
  带着意味
```

---

### Segment 3: 选择时刻 (160-240秒)

#### 时间轴: 2:40-3:10
```yaml
id: VO_003
speaker: 主角 (内心)
type: inner_monologue
start_time: 160
end_time: 190
emotion: processing
text: |
  我的记忆没有完全清除...
  这意味着...那些碎片是真的...
  我需要找回它们...
audio_note: |
  处理信息的感觉
  语速中等
  带着决心
```

#### 时间轴: 3:10-3:40
```yaml
id: DIA_YQH_005
speaker: 叶清寒
type: dialogue
start_time: 190
end_time: 220
emotion: offering
text: |
  我可以帮助你找回记忆。
  我知道他们的技术。
  但这条路...充满危险。
  你准备好了吗？
audio_note: |
  提供帮助的语气
  "危险"加重
  带着关切
```

#### 时间轴: 3:40-4:00
```yaml
id: DIA_YQH_006
speaker: 叶清寒
type: dialogue
start_time: 220
end_time: 240
emotion: waiting
text: |
  这是你的选择。
  我只能提供机会。
  最终决定...在你手中。
audio_note: |
  等待的语气
  给予选择权
  带着尊重
```

---

## 三、玩家选择字幕

### 选择 #1
```yaml
id: CHOICE_001
speaker: 系统
type: choice
display_time: 220
choice_id: choice_032
text: "好，我愿意和你合作"
effects:
  - modify_relationship: ye_qinghan +10
  - set_flag: cooperated_ye = true
next_node: ch1_sc_008
hover_text: "接受叶清寒的合作提议"
```

### 选择 #2
```yaml
id: CHOICE_002
speaker: 系统
type: choice
display_time: 220
choice_id: choice_033
text: "我需要时间考虑"
effects:
  - set_flag: delayed_ye = true
next_node: ch1_sc_008
hover_text: "暂缓决定，保留选择权"
```

---

## 四、选择触发对话

### 选择A触发
```yaml
id: DIA_CHOICE_A
speaker: 主角
type: dialogue
text: "好，我愿意和你合作。告诉我该怎么做。"
follow_up:
  speaker: 叶清寒
  emotion: determined
  text: |
    很好。
    首先，我们需要找到你的原始记忆数据。
    它应该还在"黄昏"的档案库里。
    这不容易...但我们一起，有机会。
```

### 选择B触发
```yaml
id: DIA_CHOICE_B
speaker: 主角
type: dialogue
text: "我需要时间考虑。这太重要了。"
follow_up:
  speaker: 叶清寒
  emotion: understanding
  text: |
    我理解。
    这不是一个容易的决定。
    但记住...时间不站在我们这边。
    "黄昏"不会停止追捕。
    当你准备好...来找我。
```

---

## 五、音效时序

| 时间 | 音效 | 类型 | 音量 | 描述 |
|------|------|------|------|------|
| 0:00 | safehouse_ambient | 环境 | 25% | 安全屋安静氛围 |
| 1:20 | revelation_tone | 效果 | 30% | 揭示音效 |
| 3:40 | choice_appear | 效果 | 60% | 选择界面出现音效 |

---

## 六、字幕文件导出 (SRT格式)

```srt
1
00:00:05,000 --> 00:00:30,000
（叶清寒）
你想知道更多...很好。
至少你没有立刻拒绝我。
这说明你有判断力。

2
00:01:00,000 --> 00:01:20,000
（叶清寒）
"黄昏"不只是一个组织。
它是一个系统...一个控制记忆的系统。
而你...是它的一部分。

3
00:01:20,000 --> 00:01:50,000
（叶清寒）
他们选择特定的人...清除记忆...
然后植入新的身份...执行任务。
当任务结束...再次清除。

4
00:02:10,000 --> 00:02:40,000
（叶清寒）
你可能已经经历过多次了。
但这回...出了问题。
你的记忆没有完全清除。

5
00:03:10,000 --> 00:03:40,000
（叶清寒）
我可以帮助你找回记忆。
我知道他们的技术。
但这条路...充满危险。

6
00:03:40,000 --> 00:04:00,000
（叶清寒）
这是你的选择。
我只能提供机会。
最终决定...在你手中。
```

---

## 七、配音注意事项

### 主角内心独白
1. **情绪层次**: 专注 → 恐惧 → 决心
2. **语速**: 中等（0.9x）
3. **特殊处理**: 所有内心独白添加轻微回响效果

### 叶清寒
1. **声音特点**: 坦诚复杂，带着伤痛和决心
2. **情绪变化**: 认可 → 揭示 → 提议
3. **关键词**: "系统"、"记忆"、"危险"

---

## 八、场景特点说明

### 剧情要点
- 揭示"黄昏"的记忆控制机制
- 主角记忆未完全清除的原因
- 叶清寒提供帮助的具体内容

### 伏笔呼应
| 内容 | 本场景呼应 |
|------|------------|
| 记忆碎片 | "记忆没有完全清除" |
| "旅人"身份 | "是它的一部分" |
| 追杀原因 | 因为记忆未清除 |

---

**创建日期**: 2026-02-26
**更新日期**: 2026-02-26
**状态**: ✅ 对话脚本完成
**配音状态**: ⏳ 待录制
