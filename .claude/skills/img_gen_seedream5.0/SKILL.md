---
name: img_gen_seedream5.0
description: Seedream 5.0 AI图像生成工具，支持文生图、图生图、多图融合、组图生成、联网搜索等功能
---
# Seedream 5.0 图像生成器

基于火山方舟平台 Seedream 5.0 Lite 模型的图像生成工具。

## 功能说明

### 核心能力
- **文生图**: 根据文本描述生成高质量图像
- **图生图**: 基于参考图进行图像编辑
- **多图融合**: 融合多张参考图（最多14张）
- **组图生成**: 一次生成多张内容关联的图片（最多15张）
- **联网搜索**: 获取实时网络信息增强生成效果（仅5.0-lite）
- **流式输出**: 逐张返回生成的图片

### 支持的模型
- `doubao-seedream-5.0-lite` - 最新版本，支持联网搜索、PNG输出
- `doubao-seedream-4.5` - 支持4K输出
- `doubao-seedream-4.0` - 支持快速模式

## 使用方式

### 1. 文生图
```bash
python seedream5_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output
```

### 2. 图生图
```bash
# 单图生图
python seedream5_generator.py \
    --prompt "让猫咪戴上墨镜" \
    --image https://example.com/cat.jpg \
    --output ./output
```

### 3. 多图融合
```bash
# 融合多张参考图
python seedream5_generator.py \
    --prompt "将图1的服装换为图2的服装" \
    --image https://example.com/person.jpg https://example.com/clothes.jpg \
    --output ./output
```

### 4. 组图生成
```bash
# 生成一组关联图片
python seedream5_generator.py \
    --prompt "生成一组共4张连贯插画，展示同一庭院的四季变迁" \
    --sequential \
    --max-images 4 \
    --output ./output
```

### 5. 联网搜索
```bash
# 启用联网搜索获取实时信息
python seedream5_generator.py \
    --prompt "生成今日上海天气图" \
    --web-search \
    --output ./output
```

### 6. 流式输出
```bash
python seedream5_generator.py \
    --prompt "可爱的猫咪" \
    --stream \
    --output ./output
```

## 配置

### 环境变量
```bash
export ARK_API_KEY="your_api_key"
```

### API Key 获取
访问 [火山方舟控制台](https://console.volcengine.com/ark/region:ark+cn-beijing/apikey) 获取 API Key

## 参数说明

| 参数 | 说明 | 默认值 |
|------|------|--------|
| `--prompt` | 文本提示词（必需） | - |
| `--image` | 参考图片URL | - |
| `--output` | 输出目录 | `./output` |
| `--prefix` | 文件名前缀 | `generated` |
| `--model` | 模型版本 | `5.0-lite` |
| `--size` | 图像尺寸 | `2K` |
| `--format` | 输出格式 | `jpeg` |
| `--sequential` | 生成组图 | `false` |
| `--max-images` | 组图数量 | `4` |
| `--stream` | 流式输出 | `false` |
| `--web-search` | 联网搜索 | `false` |
| `--watermark` | 添加水印 | `false` |

## Python API

```python
from seedream5_generator import Seedream5Generator

# 初始化
generator = Seedream5Generator(api_key="your_api_key")

# 文生图
result = generator.generate_sync(
    prompt="一只可爱的猫咪",
    size="2K"
)

# 获取图片
for img in result['images']:
    print(f"URL: {img['url']}")
```

## 文件说明

- `seedream5_generator.py` - 主程序脚本
- `seedream5_generator_使用文档.md` - 详细使用文档
- `seedream5.0_api文档.md` - API接口文档
- `seedream5.0_sdk使用样例.md` - SDK使用示例

## 安装依赖

```bash
pip install 'volcengine-python-sdk[ark]'
```

## 相关链接

- [火山方舟控制台](https://console.volcengine.com/ark)
- [API文档](https://www.volcengine.com/docs/82379/1541523)
- [使用教程](https://www.volcengine.com/docs/82379/1824121)
