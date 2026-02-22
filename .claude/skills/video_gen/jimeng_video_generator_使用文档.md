# 即梦AI视频生成3.0 Pro使用文档

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

本工具是对火山引擎**即梦AI视频生成3.0 Pro**服务的Python封装，提供简洁易用的接口进行视频生成操作。

### 主要功能

- **文生视频**: 根据文本描述生成高质量1080P视频
- **图生视频**: 基于输入图片生成动态视频内容
  - 单图生视频：单张图片动态化
  - 多图生视频：最多支持4张图片输入，生成多人物/多主体视频
- **多镜头叙事**: 支持复杂场景和动作描述
- **高清输出**: 1080P专业级视频质量

### 特性

- 简洁的API设计
- 自动保存视频到本地
- 支持文生视频和图生视频两种模式
- 完整的错误处理
- 命令行支持
- 配置灵活（参数/环境变量/配置文件）

---

## 环境准备

### 前置条件

1. **Python版本**: Python 3.7+
2. **火山引擎账号**: 需要开通即梦AI视频生成3.0 Pro服务
3. **AK/SK**: 从火山引擎控制台获取Access Key和Secret Key

### 获取AK/SK

1. 登录[火山引擎控制台](https://console.volcengine.com/)
2. 进入"访问控制" -> "访问密钥"
3. 创建或查看已有的Access Key

### 配置AK/SK

支持三种方式配置AK/SK，按优先级从高到低：

#### 方式1: 直接传入参数（优先级最高）

```python
generator = JiMengVideoGenerator(ak="your_access_key", sk="your_secret_key")
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

# 安装requests库（用于下载视频）
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
from jimeng_video_generator import JiMengVideoGenerator

# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
# 需先在脚本目录创建 config.json 文件
generator = JiMengVideoGenerator()

# 方式2: 使用环境变量中的 ak/sk
# 需先设置环境变量: VOLC_ACCESSKEY, VOLC_SECRETKEY
# generator = JiMengVideoGenerator()

# 方式3: 直接传入 ak/sk（优先级最高）
# generator = JiMengVideoGenerator(ak="your_access_key", sk="your_secret_key")

# 文生视频
result = generator.generate_text2video(
    prompt="一只可爱的橘猫在阳光明媚的花园里追逐蝴蝶，毛茸茸的，治愈系风格",
    output_dir="./output"
)

# 检查结果
if result.success:
    print(f"生成成功！保存路径: {result.video_paths}")
else:
    print(f"生成失败: {result.message}")
```

### 命令行方式

```bash
# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
python jimeng_video_generator.py --prompt "一只可爱的猫咪在玩耍" --output ./output

# 方式2: 使用环境变量中的 ak/sk
# 需用户先自行设置环境变量: VOLC_ACCESSKEY, VOLC_SECRETKEY
# python jimeng_video_generator.py --prompt "一只可爱的猫咪在玩耍" --output ./output

# 方式3: 显式指定 ak/sk（优先级最高，不安全）
python jimeng_video_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪在玩耍" --output ./output

# 方式4: 指定配置文件路径
python jimeng_video_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪在玩耍" --output ./output

# 图生视频（单图）
python jimeng_video_generator.py --prompt "让猫咪眨眼" --image https://example.com/cat.jpg --output ./output

# 图生视频（多图，最多4张）
python jimeng_video_generator.py --prompt "让这些人一起跳舞" --images https://example.com/person1.jpg https://example.com/person2.jpg --output ./output
```

---

## API参考

### JiMengVideoGenerator 类

主生成器类，封装所有视频生成功能。

#### 初始化参数

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| ak | str | 否 | 从环境变量或config.json获取 | 火山引擎Access Key |
| sk | str | 否 | 从环境变量或config.json获取 | 火山引擎Secret Key |
| max_retry | int | 否 | 120 | 查询结果最大重试次数 |
| retry_interval | float | 否 | 5.0 | 重试间隔（秒） |
| config_path | str | 否 | None | 配置文件路径，默认为脚本目录下的config.json |

> **配置优先级**: 参数 > 环境变量 `VOLC_ACCESSKEY`/`VOLC_SECRETKEY` > 配置文件 `config.json`。若三种方式都未设置，将抛出 `ValueError` 异常。

> **注意**: 视频生成耗时较长，默认配置为最大等待10分钟（120次重试 x 5秒间隔）。

#### generate() 方法

核心生成方法，支持文生视频和图生视频。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| prompt | str | 是 | - | 提示词，描述视频内容 |
| image_url | str | 否 | None | 单张参考图片URL（图生视频模式），与image_urls二选一 |
| image_urls | List[str] | 否 | None | 多张参考图片URL列表（图生视频模式），与image_url二选一，最多4张 |
| output_dir | str | 否 | 当前目录 | 输出目录 |
| seed | int | 否 | None | 随机种子，用于复现结果 |
| save_video | bool | 否 | True | 是否保存视频到本地 |
| filename_prefix | str | 否 | "jimeng_video" | 文件名前缀 |

**返回值: VideoResult**

| 字段 | 类型 | 说明 |
|------|------|------|
| success | bool | 是否成功 |
| status | TaskStatus | 任务状态 |
| video_paths | List[str] | 本地保存的视频路径 |
| video_urls | List[str] | 视频URL列表（24小时有效） |
| task_id | str | 任务ID |
| message | str | 结果消息 |
| error_code | int | 错误码 |
| request_id | str | 请求ID（用于排查问题） |

#### generate_text2video() 方法

文生视频快捷方法。

```python
result = generator.generate_text2video(
    prompt="一只可爱的猫咪在花园里玩耍",
    output_dir="./output",
    seed=12345  # 可选，用于复现结果
)
```

#### generate_image2video() 方法

图生视频快捷方法，支持单图或多图输入。

```python
# 单图生视频
result = generator.generate_image2video(
    prompt="让猫咪眨眼并摇尾巴",
    image_url="https://example.com/cat.jpg",
    output_dir="./output"
)

# 多图生视频（最多4张）
result = generator.generate_image2video(
    prompt="让这些人一起跳舞",
    image_urls=["https://example.com/person1.jpg", "https://example.com/person2.jpg"],
    output_dir="./output"
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
python jimeng_video_generator.py --prompt <提示词> [选项]
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
| --image, -i | - | 单张参考图片URL（图生视频模式） |
| --images | - | 多张参考图片URL列表（图生视频模式，最多4张） |
| --output, -o | 当前目录 | 输出目录 |
| --seed | - | 随机种子，用于复现结果 |
| --prefix | jimeng_video | 文件名前缀 |
| --no-save | False | 不保存视频 |
| --max-retry | 120 | 最大重试次数 |
| --retry-interval | 5.0 | 重试间隔（秒） |

---

## 使用示例

### 示例1: 基本文生视频

```python
from jimeng_video_generator import JiMengVideoGenerator

# 使用配置文件 config.json 中的 ak/sk（推荐）
generator = JiMengVideoGenerator()

result = generator.generate_text2video(
    prompt="一只可爱的橘猫在花园里追逐蝴蝶，阳光洒在它毛茸茸的身上",
    output_dir="./my_videos"
)

if result.success:
    for path in result.video_paths:
        print(f"已保存: {path}")
```

### 示例2: 图生视频

```python
# 单图生成视频
result = generator.generate_image2video(
    prompt="让猫咪眨眨眼，然后摇摇尾巴",
    image_url="https://example.com/cat.jpg",
    output_dir="./edited"
)

# 多图生成视频（最多4张）
result = generator.generate_image2video(
    prompt="让这两个人一起跳舞",
    image_urls=["https://example.com/person1.jpg", "https://example.com/person2.jpg"],
    output_dir="./edited"
)
```

### 示例3: 使用随机种子复现结果

```python
# 使用固定种子可以复现相同的视频
result = generator.generate(
    prompt="夕阳下的海滩，海浪轻轻拍打沙滩",
    seed=12345,
    output_dir="./output"
)
```

### 示例4: 命令行使用

```bash
# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
# 先在脚本目录创建 config.json 文件
python jimeng_video_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

# 方式2: 使用环境变量中的 ak/sk
# 先设置环境变量
export VOLC_ACCESSKEY="your_access_key"
export VOLC_SECRETKEY="your_secret_key"
python jimeng_video_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

# 方式3: 显式指定 ak/sk（优先级最高，不推荐）
python jimeng_video_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

# 方式4: 指定配置文件路径
python jimeng_video_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

# 图生视频（单图）
python jimeng_video_generator.py --prompt "让猫咪眨眼" --image https://example.com/cat.jpg --output ./output

# 图生视频（多图，最多4张）
python jimeng_video_generator.py --prompt "让这些人一起跳舞" --images https://example.com/person1.jpg https://example.com/person2.jpg --output ./output

# 使用随机种子
python jimeng_video_generator.py --prompt "夕阳下的海滩" --seed 12345 --output ./output
```

### 示例5: 批量生成

```python
prompts = [
    "春天的樱花盛开，花瓣随风飘落",
    "夏天的海滩，海浪轻轻拍打沙滩",
    "秋天的枫叶林，满地金黄",
    "冬天的雪景，雪花纷飞"
]

for i, prompt in enumerate(prompts):
    result = generator.generate(
        prompt=prompt,
        output_dir=f"./seasons",
        filename_prefix=f"season_{i+1}"
    )
    print(f"生成 {prompt}: {'成功' if result.success else '失败'}")
```

---

## 常见问题

### Q1: 视频生成需要多长时间？

视频生成通常需要**1-10分钟**，具体时间取决于：
- 视频内容的复杂度
- 当前服务负载情况
- 是否为图生视频（图生视频通常更快）

默认配置为最大等待10分钟（120次重试 x 5秒间隔），可通过 `--max-retry` 和 `--retry-interval` 调整。

### Q2: 视频链接有效期多久？

返回的视频URL有效期为**24小时**，请及时下载保存。

### Q3: 支持哪些图片格式（图生视频）？

- 输入: JPEG、PNG（推荐JPEG）
- 输出: MP4格式

### Q4: 图生视频支持多少张图片？

图生视频支持**单图或多图**输入：
- 单图：使用 `--image` 参数指定单张图片URL
- 多图：使用 `--images` 参数指定多张图片URL（最多4张）

多图生视频适用于生成多人物/多主体互动的视频场景。

### Q5: 任务多久会过期？

提交的任务在**12小时**后过期，过期后需要重新提交。

### Q6: 如何提高生成质量？

- 提供详细、具体的提示词
- 描述场景、动作、光线等细节
- 对于图生视频，使用清晰、高质量的参考图片

### Q7: 如何排查问题？

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
| 50511 | 输出视频后审核未通过 | 修改提示词重试 |
| 50412 | 输入文本前审核未通过 | 修改提示词 |
| 50413 | 输入文本含敏感词/版权词 | 修改提示词 |
| 50518 | 输入版权图审核未通过 | 更换输入图片 |
| 50519 | 输出版权内容审核未通过 | 修改提示词重试 |
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

## 技术支持

- 火山引擎文档: https://www.volcengine.com/docs/85621/1777001
- GitHub Issues: https://github.com/volcengine/volc-sdk-python/issues

---

## 更新日志

### v1.0.0 (2026-02-22)
- 初始版本
- 支持文生视频、图生视频
- 支持命令行调用
- 配置优先级: 参数 > 环境变量 > config.json
