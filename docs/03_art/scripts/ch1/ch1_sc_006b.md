---
video_id: ch1_sc_006b
scene_id: SC-006
scene_name: SC-006 艺术画廊
chapter: ch1
duration_seconds: 300
has_voice_over: true
has_dialogue: True
has_subtitles: true
language: zh-CN
---

# [CH1_SC_006B] SC-006 艺术画廊 - 对话/字幕脚本

> 沈墨染解读画作含义

---

## 一、字幕/配音清单

### 概览

| 类型 | 数量 | 说明 |
|------|------|------|
| 内心独白 | 2-3段 | 主角思维 |
| 角色对话 | 2-4段 | 场景对话 |
| 环境音效 | 2-3处 | 氛围增强 |
| 选择提示 | 2个 | 玩家选项 |

---

## 二、详细脚本

### Segment 1: 开场 (0-100秒)

#### 内心独白
```yaml
id: VO_001
speaker: 主角 (内心)
type: inner_monologue
start_time: 5
end_time: 15
emotion: alert
text: |
  [待补充: 根据剧情大纲填写具体对话]
audio_note: 内心独白，带有回响效果
```

---

### Segment 2: 中段 (100-200秒)

#### 对话/独白
```yaml
id: DIA_001
speaker: [角色名]
type: dialogue
start_time: 100
end_time: 150
emotion: neutral
text: |
  [待补充: 根据剧情大纲填写具体对话]
```

---

### Segment 3: 结尾 (200-300秒)

#### 过渡对话
```yaml
id: DIA_002
speaker: [角色名]
type: dialogue
start_time: 200
end_time: 275
emotion: expectant
text: |
  [待补充: 引出选择的对话]
```

---

## 三、玩家选择字幕

### 选择 #1
```yaml
id: CHOICE_ch1_sc_006b_001
speaker: 系统
type: choice
display_time: 280
choice_id: choice_026
text: "谢谢你，我想我找到了一些方向"
next_node: ch1_sc_008
```

### 选择 #2
```yaml
id: CHOICE_ch1_sc_006b_002
speaker: 系统
type: choice
display_time: 280
choice_id: choice_027
text: "我需要赶去别的地方"
next_node: ch1_sc_008
```


---

## 四、字幕文件导出 (SRT格式)

```srt
1
00:00:05,000 --> 00:00:15,000
[待补充: 开场字幕]

2
00:01:00,000 --> 00:01:30,000
[待补充: 中段字幕]

3
00:02:00,000 --> 00:02:30,000
[待补充: 结尾字幕]
```

---

## 五、待完善事项

- [ ] 根据剧情大纲补充具体对话内容
- [ ] 确定角色声音配置
- [ ] 添加环境音效时序
- [ ] 校对字幕时间轴

---

**创建日期**: 2026-02-22
**状态**: 待完善对话内容
**来源**: 自动生成框架，需人工补充对话
