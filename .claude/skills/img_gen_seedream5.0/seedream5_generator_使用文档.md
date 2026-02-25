# Seedream 5.0 图像生成器使用文档

## 简介

Seedream 5.0 是火山方舟平台推出的高质量图像生成模型，支持文生图、图生图、多图融合、组图生成等多种能力。

## 安装依赖

```bash
pip install 'volcengine-python-sdk[ark]'
```

## 配置

### 方式1: 环境变量（推荐）

```bash
# Linux/macOS
export ARK_API_KEY="your_api_key"

# Windows
set ARK_API_KEY=your_api_key
```

### 方式2: 命令行参数

```bash
python seedream5_generator.py --api-key your_api_key ...
```

## 使用方法

### 基本文生图

```bash
# 生成单张图片
python seedream5_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

# 指定尺寸
python seedream5_generator.py --prompt "城市夜景" --size 3K --output ./output

# 指定输出格式（仅5.0-lite支持）
python seedream5_generator.py --prompt "风景画" --format png --output ./output
```

### 图生图（单图输入）

```bash
# 基于参考图生成新图
python seedream5_generator.py \
    --prompt "让这只猫咪戴上墨镜" \
    --image https://example.com/cat.jpg \
    --output ./output
```

### 多图融合

```bash
# 融合多张参考图
python seedream5_generator.py \
    --prompt "将图1的服装换为图2的服装" \
    --image https://example.com/person.jpg https://example.com/clothes.jpg \
    --output ./output
```

### 组图生成

```bash
# 生成一组关联图片
python seedream5_generator.py \
    --prompt "生成一组共4张连贯插画，展示同一庭院的四季变迁" \
    --sequential \
    --max-images 4 \
    --output ./output

# 基于参考图生成组图
python seedream5_generator.py \
    --prompt "生成3张女孩在不同场景的图片" \
    --image https://example.com/girl.jpg \
    --sequential \
    --max-images 3 \
    --output ./output
```

### 联网搜索（仅5.0-lite支持）

```bash
# 启用联网搜索获取实时信息
python seedream5_generator.py \
    --prompt "生成今日上海天气图" \
    --web-search \
    --output ./output
```

### 流式输出

```bash
# 流式输出，逐张返回图片
python seedream5_generator.py \
    --prompt "可爱的猫咪" \
    --stream \
    --output ./output
```

### 提示词优化

```bash
# 使用快速模式（仅4.0支持）
python seedream5_generator.py \
    --prompt "风景画" \
    --model 4.0 \
    --optimize fast \
    --output ./output

# 使用标准模式
python seedream5_generator.py \
    --prompt "风景画" \
    --optimize standard \
    --output ./output
```

## 命令行参数

| 参数 | 简写 | 说明 | 默认值 |
|------|------|------|--------|
| `--prompt` | `-p` | 文本提示词（必需） | - |
| `--image` | `-i` | 参考图片URL（支持多个） | - |
| `--output` | `-o` | 输出目录 | `./output` |
| `--prefix` | - | 输出文件名前缀 | `generated` |
| `--format` | `-f` | 输出格式: png/jpeg | `jpeg` |
| `--response-format` | - | 响应格式: url/b64_json | `url` |
| `--model` | `-m` | 模型版本 | `5.0-lite` |
| `--size` | `-s` | 图像尺寸 | `2K` |
| `--sequential` | - | 生成组图 | `false` |
| `--max-images` | - | 组图最大数量 | `4` |
| `--stream` | - | 流式输出 | `false` |
| `--web-search` | - | 启用联网搜索 | `false` |
| `--optimize` | - | 提示词优化模式 | - |
| `--watermark` | - | 添加水印 | `false` |
| `--api-key` | - | API密钥 | - |
| `--save-json` | - | 保存响应JSON | `false` |

## 支持的模型

| 模型名称 | Model ID | 特点 |
|----------|----------|------|
| `5.0-lite` | doubao-seedream-5-0-lite-260128 | 最新版本，支持联网搜索、PNG输出 |
| `5.0` | doubao-seedream-5-0-260128 | 标准版本 |
| `4.5` | doubao-seedream-4-5-251128 | 支持4K输出 |
| `4.0` | doubao-seedream-4-0-250828 | 支持快速模式、1K-4K输出 |

## 尺寸规格

### Seedream 5.0 lite

**方式1: 分辨率**
- `2K` - 在prompt中描述宽高比
- `3K` - 在prompt中描述宽高比

**方式2: 具体像素**
- 默认: `2048x2048`
- 宽高比范围: [1/16, 16]
- 总像素范围: [3686400, 10404496]

**推荐像素值:**

| 分辨率 | 宽高比 | 像素值 |
|--------|--------|--------|
| 2K | 1:1 | 2048x2048 |
| 2K | 4:3 | 2304x1728 |
| 2K | 3:4 | 1728x2304 |
| 2K | 16:9 | 2848x1600 |
| 2K | 9:16 | 1600x2848 |
| 3K | 1:1 | 3072x3072 |
| 3K | 4:3 | 3456x2592 |
| 3K | 3:4 | 2592x3456 |
| 3K | 16:9 | 4096x2304 |
| 3K | 9:16 | 2304x4096 |

## Python API 使用

```python
from seedream5_generator import Seedream5Generator

# 初始化
generator = Seedream5Generator(api_key="your_api_key", model="5.0-lite")

# 文生图
result = generator.generate_sync(
    prompt="一只可爱的猫咪在花园里玩耍",
    size="2K",
    output_format="png"
)

# 获取图片URL
for img in result['images']:
    print(f"图片URL: {img['url']}")
    print(f"图片尺寸: {img['size']}")

# 图生图
result = generator.generate_sync(
    prompt="让猫咪戴上墨镜",
    image="https://example.com/cat.jpg",
    size="2K"
)

# 多图融合
result = generator.generate_sync(
    prompt="将图1的服装换为图2的服装",
    image=["https://example.com/person.jpg", "https://example.com/clothes.jpg"],
    size="2K"
)

# 组图生成
result = generator.generate_sync(
    prompt="生成4张四季变化图",
    sequential=True,
    max_images=4,
    size="2K"
)

# 流式输出
for event in generator.generate_stream(
    prompt="可爱的猫咪",
    sequential=True,
    max_images=4
):
    if event['type'] == 'image_generation.partial_succeeded':
        print(f"收到图片: {event['url']}")
    elif event['type'] == 'image_generation.completed':
        print("生成完成")
```

## 提示词建议

1. **简洁连贯**: 用自然语言描述 **主体 + 行为 + 环境**
2. **美学元素**: 可补充 **风格**、**色彩**、**光影**、**构图**
3. **长度控制**: 建议不超过300个汉字或600个英文单词

### 示例提示词

```
充满活力的特写编辑肖像，模特眼神犀利，头戴雕塑感帽子，
色彩拼接丰富，眼部焦点锐利，景深较浅，
具有Vogue杂志封面的美学风格，采用中画幅拍摄，工作室灯光效果强烈。
```

## 使用限制

### 图片输入限制
- 格式: jpeg, png, webp, bmp, tiff, gif
- 宽高比: [1/16, 16]
- 最小边长: >14px
- 大小: ≤10MB
- 总像素: ≤36,000,000px
- 参考图数量: ≤14张

### 组图限制
- 输入参考图 + 生成图片 ≤ 15张

### 保存时间
- 生成的图片URL在24小时内有效，请及时保存

## 常见问题

### Q: 如何获取API Key?
A: 访问 [火山方舟控制台](https://console.volcengine.com/ark/region:ark+cn-beijing/apikey) 获取API Key

### Q: 图片URL过期怎么办?
A: 生成的图片URL 24小时内有效，请及时下载保存

### Q: 组图生成失败部分图片怎么办?
A: 如果是审核不通过，会继续生成其他图片；如果是服务异常(500)，则不会继续

### Q: 如何查看联网搜索是否生效?
A: 在响应的 `usage.tool_usage.web_search` 字段可以看到实际搜索次数，0表示未搜索

## 相关链接

- [火山方舟控制台](https://console.volcengine.com/ark)
- [API文档](https://www.volcengine.com/docs/82379/1541523)
- [使用教程](https://www.volcengine.com/docs/82379/1824121)
- [提示词指南](https://www.volcengine.com/docs/82379/1829186)
