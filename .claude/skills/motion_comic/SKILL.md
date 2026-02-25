---
name: motion_comic
description: 动态漫生成器，将关键帧图片和对话脚本合成为带语音的视频。使用Edge-TTS生成配音，支持多种语言和音色。触发示例:`请使用asset目录下的图片生成一个家庭故事的动态漫视频` 或 `请将story.json配置文件生成为动态漫`
---

# 动态漫生成器 (Motion Comic Generator)

将关键帧图片和对话脚本自动合成为带语音的视频。

## 功能概述

本工具实现以下功能：
1. **语音合成 (TTS)**: 使用 Edge-TTS 将文本转换为语音，支持中、英、日等多种语言
2. **视频生成**: 将静态图片与音频合成视频，视频时长自动匹配音频时长
3. **视频拼接**: 将多个场景视频拼接成完整视频

### 工作流程
```
场景1: 图片 + 文本 --TTS--> 图片 + 音频 --合成--> 场景视频1
场景2: 图片 + 文本 --TTS--> 图片 + 音频 --合成--> 场景视频2
...
所有场景视频 --拼接--> 最终视频
```

## 快速开始

### 从配置文件生成（推荐）

1. 创建故事配置文件 `story.json`:
```json
{
  "title": "my_story",
  "scenes": [
    {
      "frame": "./images/scene1.png",
      "text": "你好，欢迎来到我的世界",
      "voice": "zh-CN-XiaoxiaoNeural"
    },
    {
      "frame": "./images/scene2.png",
      "text": "今天是个好日子",
      "voice": "zh-CN-YunxiNeural"
    }
  ]
}
```

2. 运行生成命令:
```bash
python motion_comic_generator.py generate --config ./story.json --output ./output/comic.mp4
```

### 从命令行参数生成

```bash
python motion_comic_generator.py generate \
    --frames ./images/scene1.png ./images/scene2.png \
    --texts "第一句台词" "第二句台词" \
    --voices zh-CN-XiaoxiaoNeural zh-CN-YunxiNeural \
    --output ./output/comic.mp4
```

## 命令详解

### 1. 生成动态漫 `generate`

**使用配置文件:**
```bash
python motion_comic_generator.py generate --config <配置文件路径> --output <输出路径>
```

**使用命令行参数:**
```bash
python motion_comic_generator.py generate \
    --frames <图片1> <图片2> ... \
    --texts <文本1> <文本2> ... \
    [--voices <音色1> <音色2> ...] \
    --output <输出路径>
```

**参数说明:**
| 参数 | 必填 | 说明 |
|------|------|------|
| --config, -c | 二选一 | 故事配置文件路径 |
| --frames | 二选一 | 关键帧图片路径列表（与 --texts 配合使用） |
| --texts | 二选一 | 台词文本列表（与 --frames 配合使用） |
| --voices | 否 | 音色列表，数量不足时使用默认音色补充 |
| --output, -o | 否 | 输出路径，默认 `./output/comic.mp4` |

### 2. 生成语音 `tts`

单独生成语音文件：
```bash
python motion_comic_generator.py tts \
    --text "要转换的文本" \
    --output ./output/voice.mp3 \
    [--voice zh-CN-XiaoxiaoNeural]
```

### 3. 查看音色 `list-voices`

列出所有可用音色：
```bash
# 列出所有音色
python motion_comic_generator.py list-voices

# 筛选特定语言
python motion_comic_generator.py list-voices --language zh-CN
```

## 配置文件格式

### story.json 结构
```json
{
  "title": "故事标题（用于默认输出文件名）",
  "scenes": [
    {
      "frame": "图片路径（必填）",
      "text": "台词文本（必填，除非提供 audio）",
      "voice": "音色名称（可选，默认 zh-CN-XiaoxiaoNeural）",
      "audio": "预置音频路径（可选，如有则跳过 TTS 直接使用）"
    }
  ]
}
```

### 完整示例
```json
{
  "title": "family_story",
  "scenes": [
    {
      "frame": "./assets/home.png",
      "text": "亲爱的，今天工作怎么样？",
      "voice": "zh-CN-YunxiNeural"
    },
    {
      "frame": "./assets/home.png",
      "text": "挺好的，今天做了红烧肉！",
      "voice": "zh-CN-XiaoxiaoNeural"
    },
    {
      "frame": "./assets/child.png",
      "text": "爸爸妈妈，看我画的画！",
      "voice": "zh-CN-XiaoyiNeural"
    }
  ]
}
```

### 场景字段说明

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| frame | string | 是 | 关键帧图片路径（支持 png, jpg 等常见格式） |
| text | string | 条件 | 台词文本，用于 TTS 生成语音。如果提供 audio 则可省略 |
| voice | string | 否 | 音色名称，默认使用 config.json 中的 default_voice 或 zh-CN-XiaoxiaoNeural |
| audio | string | 否 | 预置音频文件路径。如果提供，则直接使用该音频，不进行 TTS |

## 常用音色

### 中文音色
| 音色名称 | 性别 | 特点 |
|----------|------|------|
| zh-CN-XiaoxiaoNeural | 女 | 温柔、成熟（默认） |
| zh-CN-XiaoyiNeural | 女 | 活泼、年轻 |
| zh-CN-XiaochenNeural | 女 | 知性 |
| zh-CN-YunxiNeural | 男 | 年轻、阳光 |
| zh-CN-YunjianNeural | 男 | 成熟、稳重 |
| zh-CN-YunfengNeural | 男 | 沉稳、新闻播报风格 |

### 英文音色
| 音色名称 | 性别 | 特点 |
|----------|------|------|
| en-US-JennyNeural | 女 | 美式英语（默认） |
| en-US-GuyNeural | 男 | 美式英语 |
| en-GB-SoniaNeural | 女 | 英式英语 |

### 日语音色
| 音色名称 | 性别 |
|----------|------|
| ja-JP-NanamiNeural | 女 |
| ja-JP-KeitaNeural | 男 |

> 使用 `list-voices` 命令可查看完整的音色列表

## 全局配置

在脚本目录创建 `config.json` 可设置全局默认值：

```json
{
  "output_dir": "./output",
  "default_voice": "zh-CN-XiaoxiaoNeural",
  "fps": 24,
  "resolution": "720p",
  "max_retries": 3,
  "retry_delay": 1.0
}
```

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| output_dir | 默认输出目录 | ./output |
| default_voice | 默认音色 | zh-CN-XiaoxiaoNeural |
| fps | 视频帧率 | 24 |
| resolution | 视频分辨率高度 | 720p |
| max_retries | TTS失败时的最大重试次数 | 3 |
| retry_delay | 重试初始延迟（秒），采用指数退避 | 1.0 |

## 输出文件

生成的文件位于 output 目录：
- `scene_001.mp4`, `scene_002.mp4`, ... - 各场景的独立视频
- `<指定的输出文件名>` - 拼接后的完整视频

## 技术规格

| 项目 | 规格 |
|------|------|
| 视频编码 | H.264 (libx264) |
| 音频编码 | AAC |
| 输出格式 | MP4 |
| 默认分辨率 | 720p（高度，宽度按比例） |
| 默认帧率 | 24 fps |

## 依赖安装

```bash
pip install -r requirements.txt
```

依赖包：
- edge-tts: 微软 Edge TTS 语音合成
- imageio-ffmpeg: FFmpeg 视频处理

## 注意事项

### TTS 服务稳定性

Edge-TTS 是微软提供的免费在线服务，**某些音色可能存在间歇性不可用**的情况（报错 `No audio was received`）。这不是文本长度的问题，而是服务本身的不稳定性。

**自动处理机制：**
- 工具内置了重试机制（默认最多重试3次，使用指数退避）
- 当主音色失败时，会自动尝试备用音色
- 可在 `config.json` 中配置 `max_retries` 和 `retry_delay` 参数

**建议：**
- 如果某个音色频繁失败，可以尝试更换为其他同类音色
- 女声推荐：zh-CN-XiaoxiaoNeural（最稳定）
- 男声推荐：zh-CN-YunjianNeural（较稳定）

### 常见问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| TTS生成失败 | 音色服务不稳定 | 工具会自动重试并切换备用音色，或手动更换音色 |
| 视频无声音 | 音频路径错误 | 检查 audio 字段路径是否正确 |
| 图片无法加载 | 路径不存在 | 使用绝对路径或检查相对路径 |

### 最佳实践

1. **音色选择**：优先使用稳定的音色（如 zh-CN-XiaoxiaoNeural）
2. **路径规范**：建议使用绝对路径避免路径问题
3. **文本分段**：每个场景的台词控制在 1-2 句话，效果更佳
4. **分段处理**：长故事可拆分为多个配置文件分别生成
