# 音频资源目录

将游戏音频文件放置在此目录下。

## 目录结构

```
audio/
├── bgm/           # 背景音乐
│   ├── main_menu.ogg
│   ├── game.ogg
│   └── ending_*.ogg
├── sfx/           # 音效
│   ├── click.ogg
│   ├── hover.ogg
│   └── transition.ogg
└── voice/         # 语音（可选）
```

## 支持的格式

- OGG Vorbis (推荐)
- WAV (短音效)
- MP3 (兼容性好)

## 音频规格

### 背景音乐
- 格式: OGG Vorbis
- 采样率: 44100 Hz
- 比特率: 128-192 kbps
- 循环点: 无缝循环

### 音效
- 格式: WAV 或 OGG
- 采样率: 44100 Hz
- 时长: < 3 秒
