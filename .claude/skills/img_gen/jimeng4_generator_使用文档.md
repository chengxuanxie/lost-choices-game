# 即梦4.0 AI图像生成工具使用文档

## 目录

- [简介](#简介)
- [环境准备](#环境准备)
- [安装依赖](#安装依赖)
- [快速开始](#快速开始)
- [API参考](#api参考)
- [命令行使用](#命令行使用)
- [使用示例](#使用示例)
- [常见问题](#常见问题)
- [错误码说明](#错误码说明)

---

## 简介

本工具是对火山引擎**即梦4.0** AI图像生成服务的Python封装，提供简洁易用的接口进行图像生成操作。

### 主要功能

- **文生图**: 根据文本描述生成图像
- **图生图**: 基于参考图进行图像编辑
- **多图组合**: 支持最多10张参考图输入
- **高清输出**: 支持1K/2K/4K分辨率输出
- **批量生成**: 一次最多生成15张关联图像

### 特性

- 简洁的API设计
- 支持同步/异步调用
- 自动保存图片到本地
- 支持自定义水印
- 完整的错误处理
- 命令行支持

---

## 环境准备

### 前置条件

1. **Python版本**: Python 3.7+
2. **火山引擎账号**: 需要开通即梦4.0服务
3. **AK/SK**: 从火山引擎控制台获取Access Key和Secret Key

### 获取AK/SK

1. 登录[火山引擎控制台](https://console.volcengine.com/)
2. 进入"访问控制" -> "访问密钥"
3. 创建或查看已有的Access Key

### 配置AK/SK

支持三种方式配置AK/SK，按优先级从高到低：

#### 方式1: 直接传入参数（优先级最高）

```python
generator = JiMeng4Generator(ak="your_access_key", sk="your_secret_key")
```

#### 方式2: 环境变量

```bash
# Linux/macOS
export VOLC_ACCESSKEY="your_access_key"
export VOLC_SECRETKEY="your_secret_key"

# Windows (CMD)
set VOLC_ACCESSKEY=your_access_key
set VOLC_SECRETKEY=your_secret_key

# Windows (PowerShell)
$env:VOLC_ACCESSKEY="your_access_key"
$env:VOLC_SECRETKEY="your_secret_key"
```

#### 方式3: 配置文件 config.json（优先级最低）

在脚本所在目录创建 `config.json` 文件：

```json
{
  "ak": "your_access_key",
  "sk": "your_secret_key"
}
```

> **注意**: 配置文件应添加到 `.gitignore` 中，避免泄露密钥。

---

## 安装依赖

```bash
# 安装火山引擎Python SDK
pip install volcengine-python-sdk

# 安装requests库（用于下载图片）
pip install requests
```

或者使用requirements.txt:

```bash
pip install -r requirements.txt
```

requirements.txt内容:
```
volcengine-python-sdk>=1.0.0
requests>=2.28.0
```

---

## 快速开始

### 代码方式

```python
from jimeng4_generator import JiMeng4Generator

# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
# 需先在脚本目录创建 config.json 文件
generator = JiMeng4Generator()

# 方式2: 使用环境变量中的 ak/sk
# 需先设置环境变量: VOLC_ACCESSKEY, VOLC_SECRETKEY
# generator = JiMeng4Generator()

# 方式3: 直接传入 ak/sk（优先级最高）
# generator = JiMeng4Generator(ak="your_access_key", sk="your_secret_key")

# 文生图
result = generator.generate(
    prompt="一只可爱的橘猫在阳光明媚的花园里玩耍，毛茸茸的，治愈系风格",
    output_dir="./output"
)

# 检查结果
if result.success:
    print(f"生成成功！保存路径: {result.image_paths}")
else:
    print(f"生成失败: {result.message}")
```

### 命令行方式

```bash
# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

# 方式2: 使用环境变量中的 ak/sk
# 需用户先自行设置环境变量: VOLC_ACCESSKEY, VOLC_SECRETKEY
# python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

# 方式3: 显式指定 ak/sk（优先级最高，不安全）
python jimeng4_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪" --output ./output

# 方式4: 指定配置文件路径
python jimeng4_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪" --output ./output

# 图生图
python jimeng4_generator.py --prompt "换成海边背景" --images https://example.com/cat.jpg
```

---

## API参考

### JiMeng4Generator 类

主生成器类，封装所有图像生成功能。

#### 初始化参数

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| ak | str | 否 | 从环境变量或config.json获取 | 火山引擎Access Key |
| sk | str | 否 | 从环境变量或config.json获取 | 火山引擎Secret Key |
| max_retry | int | 否 | 30 | 查询结果最大重试次数 |
| retry_interval | float | 否 | 3.0 | 重试间隔（秒） |
| config_path | str | 否 | None | 配置文件路径，默认为脚本目录下的config.json |

> **配置优先级**: 参数 > 环境变量 `VOLC_ACCESSKEY`/`VOLC_SECRETKEY` > 配置文件 `config.json`。若三种方式都未设置，将抛出 `ValueError` 异常。

#### generate() 方法

核心生成方法，支持文生图和图生图。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| prompt | str | 是 | - | 提示词，中英文均可，最长800字符 |
| image_urls | List[str] | 否 | None | 参考图片URL列表（0-10张） |
| output_dir | str | 否 | 当前目录 | 输出目录 |
| width | int | 否 | None | 生成图片宽度（需与height同时传入） |
| height | int | 否 | None | 生成图片高度（需与width同时传入） |
| size | int | 否 | 4194304 | 生成图片面积（默认2048×2048） |
| scale | float | 否 | 0.5 | 文本影响程度，范围[0, 1] |
| force_single | bool | 否 | False | 是否强制生成单图 |
| min_ratio | float | 否 | 1/3 | 最小宽高比 |
| max_ratio | float | 否 | 3.0 | 最大宽高比 |
| logo_info | LogoInfo | 否 | None | 水印配置 |
| aigc_meta | AIGCMeta | 否 | None | AIGC隐式标识 |
| return_url | bool | 否 | True | 是否返回图片URL |
| save_images | bool | 否 | True | 是否保存图片到本地 |
| filename_prefix | str | 否 | "jimeng4" | 文件名前缀 |

**返回值: GenerateResult**

| 字段 | 类型 | 说明 |
|------|------|------|
| success | bool | 是否成功 |
| status | TaskStatus | 任务状态 |
| image_paths | List[str] | 本地保存的图片路径 |
| image_urls | List[str] | 图片URL列表（24小时有效） |
| task_id | str | 任务ID |
| message | str | 结果消息 |
| error_code | int | 错误码 |
| request_id | str | 请求ID（用于排查问题） |

#### generate_text2image() 方法

文生图快捷方法。

```python
result = generator.generate_text2image(
    prompt="美丽的日落风景",
    output_dir="./output",
    resolution="2K"  # 可选: "1K", "2K", "4K"
)
```

#### generate_image2image() 方法

图生图快捷方法。

```python
result = generator.generate_image2image(
    prompt="将背景换成海边",
    image_urls=["https://example.com/image.jpg"],
    output_dir="./output"
)
```

### LogoInfo 类

水印配置类。

```python
logo_info = LogoInfo(
    add_logo=True,              # 是否添加水印
    position=0,                 # 位置: 0-右下, 1-左下, 2-左上, 3-右上
    language=0,                 # 语言: 0-中文(AI生成), 1-英文(Generated by AI)
    opacity=0.8,                # 透明度: 0-1
    logo_text_content="自定义水印"  # 自定义水印文字
)
```

### AIGCMeta 类

AIGC隐式标识配置类（依据《人工智能生成合成内容标识办法》）。

```python
aigc_meta = AIGCMeta(
    producer_id="unique_id",      # 必选：图片唯一ID
    content_producer="服务ID",     # 可选：内容生成服务ID
    content_propagator="传播ID",   # 可选：内容传播服务商ID
    propagate_id="传播唯一ID"      # 可选：传播唯一ID
)
```

### TaskStatus 枚举

任务状态枚举值:

| 值 | 说明 |
|------|------|
| IN_QUEUE | 任务已提交，排队中 |
| GENERATING | 任务处理中 |
| DONE | 处理完成 |
| NOT_FOUND | 任务未找到 |
| EXPIRED | 任务已过期（12小时） |

---

## 命令行使用

### 基本语法

```bash
python jimeng4_generator.py --prompt <提示词> [选项]
```

### 配置优先级

| 优先级 | 方式 | 说明 |
|--------|------|------|
| 1 (最高) | 命令行参数 --ak/--sk | 直接在命令行指定 |
| 2 | 环境变量 VOLC_ACCESSKEY/VOLC_SECRETKEY | 在系统环境中设置 |
| 3 (最低) | 配置文件 config.json | 在脚本目录创建JSON配置文件 |

### 配置文件格式

在脚本所在目录创建 `config.json`：

```json
{
  "ak": "your_access_key",
  "sk": "your_secret_key"
}
```

### 环境变量

| 变量名 | 说明 |
|--------|------|
| VOLC_ACCESSKEY | 火山引擎Access Key |
| VOLC_SECRETKEY | 火山引擎Secret Key |

### 必选参数

| 参数 | 说明 |
|------|------|
| --prompt | 生成提示词 |

### 可选参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| --ak | 从环境变量或config.json获取 | 火山引擎Access Key（优先级最高） |
| --sk | 从环境变量或config.json获取 | 火山引擎Secret Key（优先级最高） |
| --config | 脚本目录下的config.json | 配置文件路径 |
| --output, -o | 当前目录 | 输出目录 |
| --images | - | 参考图片URL（支持多个） |
| --width | - | 图片宽度 |
| --height | - | 图片高度 |
| --size | 4194304 | 图片面积 |
| --scale | 0.5 | 文本影响程度 |
| --force-single | False | 强制生成单图 |
| --min-ratio | 0.333 | 最小宽高比 |
| --max-ratio | 3.0 | 最大宽高比 |
| --prefix | jimeng4 | 文件名前缀 |
| --no-save | False | 不保存图片 |
| --max-retry | 30 | 最大重试次数 |
| --retry-interval | 3.0 | 重试间隔 |

### 水印参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| --add-logo | False | 添加水印 |
| --logo-position | 0 | 水印位置 |
| --logo-language | 0 | 水印语言 |
| --logo-opacity | 1.0 | 水印透明度 |
| --logo-text | - | 自定义水印文字 |

---

## 使用示例

### 示例1: 基本文生图

```python
from jimeng4_generator import JiMeng4Generator

# 使用配置文件 config.json 中的 ak/sk（推荐）
generator = JiMeng4Generator()

result = generator.generate(
    prompt="一只可爱的橘猫在花园里晒太阳，毛茸茸的，温暖治愈风格",
    output_dir="./my_images"
)

if result.success:
    for path in result.image_paths:
        print(f"已保存: {path}")
```

### 示例2: 指定分辨率

```python
# 使用预设分辨率
result = generator.generate_text2image(
    prompt="壮观的日落风景",
    resolution="4K",  # 1K, 2K, 4K
    output_dir="./output"
)

# 或自定义宽高
result = generator.generate(
    prompt="壮观的日落风景",
    width=2560,
    height=1440,  # 16:9比例
    output_dir="./output"
)
```

### 示例3: 图生图

```python
# 单图编辑
result = generator.generate_image2image(
    prompt="将背景替换为海边日落场景，保持主体不变",
    image_urls=["https://example.com/portrait.jpg"],
    output_dir="./edited"
)

# 多图融合（最多10张）
result = generator.generate(
    prompt="将这些人像合成一张合照",
    image_urls=[
        "https://example.com/person1.jpg",
        "https://example.com/person2.jpg",
        "https://example.com/person3.jpg"
    ],
    output_dir="./merged"
)
```

### 示例4: 添加水印

```python
from jimeng4_generator import JiMeng4Generator, LogoInfo

# 使用配置文件 config.json 中的 ak/sk（推荐）
generator = JiMeng4Generator()

logo_info = LogoInfo(
    add_logo=True,
    position=0,  # 右下角
    language=0,  # 中文
    opacity=0.7,
    logo_text_content="AI Generated"
)

result = generator.generate(
    prompt="未来科幻城市",
    logo_info=logo_info,
    output_dir="./watermarked"
)
```

### 示例5: 批量生成

```python
prompts = [
    "春天的樱花盛开",
    "夏天的海滩",
    "秋天的枫叶",
    "冬天的雪景"
]

for i, prompt in enumerate(prompts):
    result = generator.generate(
        prompt=prompt,
        output_dir=f"./seasons",
        filename_prefix=f"season_{i+1}"
    )
    print(f"生成 {prompt}: {'成功' if result.success else '失败'}")
```

### 示例6: 命令行使用

```bash
# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
# 先在脚本目录创建 config.json 文件
python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

# 方式2: 使用环境变量中的 ak/sk
# 先设置环境变量
export VOLC_ACCESSKEY="your_access_key"
export VOLC_SECRETKEY="your_secret_key"
python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

# 方式3: 显式指定 ak/sk（优先级最高，不推荐）
python jimeng4_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪" --output ./output

# 方式4: 指定配置文件路径
python jimeng4_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪" --output ./output

# 图生图
python jimeng4_generator.py --prompt "换成海边背景" --images https://example.com/cat.jpg --output ./output

# 高清4K输出
python jimeng4_generator.py --prompt "壮丽的山脉风景" --width 4096 --height 4096 --output ./4k_output

# 添加水印
python jimeng4_generator.py \
    --prompt "未来城市" \
    --add-logo \
    --logo-position 3 \
    --logo-text "My App" \
    --output ./output
```

---

## 常见问题

### Q1: 如何提高生成速度？

- 使用 `force_single=True` 强制生成单图
- 降低分辨率（使用1K或2K而非4K）
- 减少输入图片数量

### Q2: 图片链接有效期多久？

返回的图片URL有效期为**24小时**，请及时下载保存。

### Q3: 支持哪些图片格式？

- 输入: JPEG、PNG（推荐JPEG）
- 输出: PNG格式

### Q4: 任务多久会过期？

提交的任务在**12小时**后过期，过期后需要重新提交。

### Q5: 如何排查问题？

1. 检查 `result.error_code` 和 `result.message`
2. 保存 `result.request_id` 用于联系技术支持
3. 查看下方的错误码说明

---

## 错误码说明

### 业务错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 10000 | 请求成功 | - |
| 50411 | 输入图片前审核未通过 | 更换输入图片 |
| 50511 | 输出图片后审核未通过 | 修改提示词重试 |
| 50412 | 输入文本前审核未通过 | 修改提示词 |
| 50413 | 输入文本含敏感词/版权词 | 修改提示词 |
| 50518 | 输入版权图审核未通过 | 更换输入图片 |
| 50519 | 输出版权图审核未通过 | 修改提示词重试 |
| 50429 | QPS超限 | 降低请求频率 |
| 50430 | 并发超限 | 降低并发数 |
| 50500 | 内部错误 | 联系技术支持 |

### HTTP状态码

| 状态码 | 说明 |
|--------|------|
| 200 | 成功 |
| 400 | 请求参数错误 |
| 429 | 请求频率超限 |
| 500 | 服务端错误 |

---

## 推荐分辨率参考

### 1K分辨率
- 1024×1024 (1:1)

### 2K分辨率
- 2048×2048 (1:1)
- 2304×1728 (4:3)
- 2496×1664 (3:2)
- 2560×1440 (16:9)
- 3024×1296 (21:9)

### 4K分辨率
- 4096×4096 (1:1)
- 4694×3520 (4:3)
- 4992×3328 (3:2)
- 5404×3040 (16:9)
- 6198×2656 (21:9)

---

## 技术支持

- 火山引擎文档: https://www.volcengine.com/docs/6791/1347773
- GitHub Issues: https://github.com/volcengine/volc-sdk-python/issues

---

## 更新日志

### v1.2.0 (2026-02-22)
- 新增从 config.json 配置文件读取 ak/sk 的支持
- 配置优先级: 参数 > 环境变量 > config.json
- 新增 --config 命令行参数指定配置文件路径
- 更新文档说明配置文件格式

### v1.1.0 (2026-02-22)
- ak/sk 参数改为可选，支持从环境变量获取
- 环境变量: VOLC_ACCESSKEY, VOLC_SECRETKEY
- 命令行 --ak/--sk 参数改为可选

### v1.0.0 (2026-02-22)
- 初始版本
- 支持文生图、图生图
- 支持命令行调用
- 支持水印配置
- 支持AIGC隐式标识
