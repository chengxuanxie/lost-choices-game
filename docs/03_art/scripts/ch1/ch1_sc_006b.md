---
video_id: ch1_sc_006b
scene_id: SC-006
scene_name: SC-006 艺术画廊
chapter: ch1
duration_seconds: 300
has_voice_over: true
has_dialogue: true
has_subtitles: true
language: zh-CN
---

# [CH1_SC_006B] SC-006 艺术画廊 - 对话/字幕脚本

> 沈墨染解读画作含义

---

## 一、角色配置

### 声音类型

| 角色 | 声音类型 | 特点 |
|------|----------|------|
| 主角（内心独白） | 沉稳中性 | 带轻微回响效果，震撼、感悟 |
| 沈墨染 | 低沉慵懒女声 | 神秘、深邃、引导 |

---

## 二、详细脚本

### Segment 1: 画作解读 (0-100秒)

#### 时间轴: 0:05-0:40
```yaml
id: DIA_SMR_001
speaker: 沈墨染
type: dialogue
start_time: 5
end_time: 40
emotion: explaining
text: |
  你看这幅画的中心。
  那个站在迷雾中的人。
  他不是迷失...他是在选择。
audio_note: |
  解说的语气
  语速较慢
  带着引导
```

#### 时间轴: 0:40-1:10
```yaml
id: VO_001
speaker: 主角 (内心)
type: inner_monologue
start_time: 40
end_time: 70
emotion: resonating
text: |
  选择...
  我也在做选择吗？
  还是...选择已经被做出了？
audio_note: |
  产生共鸣
  语速中等
  带着困惑
```

#### 时间轴: 1:10-1:40
```yaml
id: DIA_SMR_002
speaker: 沈墨染
type: dialogue
start_time: 70
end_time: 100
emotion: deep
text: |
  迷雾不是障碍...是可能性。
  每个方向都是未知。
  但只有走出那一步...
  才能看到真正的风景。
audio_note: |
  哲理的语气
  每句略作停顿
  带着深意
```

---

### Segment 2: 符号揭示 (100-200秒)

#### 时间轴: 1:40-2:10
```yaml
id: DIA_SMR_003
speaker: 沈墨染
type: dialogue
start_time: 100
end_time: 130
emotion: revealing
text: |
  你注意到画角的那个符号了吗？
  那是我三年前画的。
  当时我不知道它意味着什么。
  直到后来...我才明白。
audio_note: |
  揭示的语气
  "符号"略作停顿
  带着神秘
```

#### 时间轴: 2:10-2:40
```yaml
id: VO_002
speaker: 主角 (内心)
type: inner_monologue
start_time: 130
end_time: 160
emotion: shocked
text: |
  那个符号...
  和我在神秘房间里看到的一样！
  她也和"黄昏"有关？
audio_note: |
  震惊的感觉
  语速略快
  带着警觉
```

#### 时间轴: 2:40-3:20
```yaml
id: DIA_SMR_004
speaker: 沈墨染
type: dialogue
start_time: 160
end_time: 200
emotion: knowing
text: |
  你认识这个符号。
  我看得出来。
  它叫"黄昏"...代表结束，也代表开始。
  你和它...有很深的渊源。
audio_note: |
  知道的语气
  "黄昏"加重
  带着洞察
```

---

### Segment 3: 选择时刻 (200-300秒)

#### 时间轴: 3:20-3:50
```yaml
id: VO_003
speaker: 主角 (内心)
type: inner_monologue
start_time: 200
end_time: 230
emotion: enlightened
text: |
  她知道一些事...
  但她没有全部说出来。
  也许...她想让我自己找到答案。
audio_note: |
  感悟的语气
  语速中等
  带着理解
```

#### 时间轴: 3:50-4:20
```yaml
id: DIA_SMR_005
speaker: 沈墨染
type: dialogue
start_time: 230
end_time: 260
emotion: guiding
text: |
  艺术不会给你答案。
  它只会给你问题。
  而答案...在你自己心里。
  你准备好去找了吗？
audio_note: |
  引导的语气
  不强求
  带着期待
```

#### 时间轴: 4:20-5:00
```yaml
id: DIA_SMR_006
speaker: 沈墨染
type: dialogue
start_time: 260
end_time: 300
emotion: inviting
text: |
  如果你需要...我可以做你的向导。
  不是告诉你答案...
  而是帮你找到属于自己的路。
  或者...你可以继续独自前行。
audio_note: |
  最后的邀请
  给予选择权
  温柔而神秘
```

---

## 三、玩家选择字幕

### 选择 #1
```yaml
id: CHOICE_001
speaker: 系统
type: choice
display_time: 280
choice_id: choice_026
text: "谢谢你，我想我找到了一些方向"
effects:
  - modify_relationship: shen_moran +10
  - set_flag: found_direction = true
next_node: ch1_sc_008
hover_text: "感谢沈墨染的启发，找到前进方向"
```

### 选择 #2
```yaml
id: CHOICE_002
speaker: 系统
type: choice
display_time: 280
choice_id: choice_027
text: "我需要赶去别的地方"
effects:
  - set_flag: left_gallery = true
next_node: ch1_sc_008
hover_text: "离开画廊，继续旅程"
```

---

## 四、选择触发对话

### 选择A触发
```yaml
id: DIA_CHOICE_A
speaker: 主角
type: dialogue
text: "谢谢你...我想我找到了一些方向。"
follow_up:
  speaker: 沈墨染
  emotion: pleased
  text: |
    很好。
    方向比目的地更重要。
    记住这幅画的感觉...
    当你迷茫的时候...它会指引你。
    我们会再见面的。
```

### 选择B触发
```yaml
id: DIA_CHOICE_B
speaker: 主角
type: dialogue
text: "我需要赶去别的地方。谢谢你。"
follow_up:
  speaker: 沈墨染
  emotion: understanding
  text: |
    去吧。
    每个人都有自己的路。
    这幅画会一直在这里...
    如果你需要...随时可以回来。
```

---

## 五、音效时序

| 时间 | 音效 | 类型 | 音量 | 描述 |
|------|------|------|------|------|
| 0:00 | gallery_ambient | 环境 | 25% | 画廊安静氛围 |
| 1:40 | symbol_reveal | 效果 | 30% | 符号揭示音效 |
| 3:20 | enlightenment | 效果 | 25% | 感悟音效 |
| 4:40 | choice_appear | 效果 | 60% | 选择界面出现音效 |

---

## 六、字幕文件导出 (SRT格式)

```srt
1
00:00:05,000 --> 00:00:40,000
（沈墨染）
你看这幅画的中心。
那个站在迷雾中的人。
他不是迷失...他是在选择。

2
00:00:40,000 --> 00:01:10,000
（内心独白）
选择...
我也在做选择吗？
还是...选择已经被做出了？

3
00:01:10,000 --> 00:01:40,000
（沈墨染）
迷雾不是障碍...是可能性。
每个方向都是未知。
但只有走出那一步...
才能看到真正的风景。

4
00:01:40,000 --> 00:02:10,000
（沈墨染）
你注意到画角的那个符号了吗？
那是我三年前画的。
当时我不知道它意味着什么。

5
00:02:40,000 --> 00:03:20,000
（沈墨染）
你认识这个符号。
我看得出来。
它叫"黄昏"...代表结束，也代表开始。

6
00:03:50,000 --> 00:04:20,000
（沈墨染）
艺术不会给你答案。
它只会给你问题。
而答案...在你自己心里。

7
00:04:20,000 --> 00:05:00,000
（沈墨染）
如果你需要...我可以做你的向导。
不是告诉你答案...
而是帮你找到属于自己的路。
```

---

## 七、配音注意事项

### 主角内心独白
1. **情绪层次**: 共鸣 → 震撼 → 感悟
2. **语速**: 中等偏慢（0.85x）
3. **特殊处理**: 所有内心独白添加轻微回响效果

### 沈墨染
1. **声音特点**: 慵懒深邃，像是在诉说哲理
2. **情绪变化**: 解释 → 揭示 → 引导
3. **关键词**: "选择"、"黄昏"、"答案"

---

## 八、场景特点说明

### 剧情要点
- "黄昏"符号首次在画作中明确出现
- 沈墨染与"黄昏"的关联暗示
- 艺术作为记忆线索的作用

### 伏笔呼应
| 伏笔 | 来源 | 本场景呼应 |
|------|------|------------|
| "黄昏"符号 | SC-001墙上 | 画作中的符号 |
| 选择主题 | 全程选择 | "他是在选择" |
| 沈墨染身份 | 待揭示 | 与"黄昏"有关联 |

---

**创建日期**: 2026-02-26
**更新日期**: 2026-02-26
**状态**: ✅ 对话脚本完成
**配音状态**: ⏳ 待录制
