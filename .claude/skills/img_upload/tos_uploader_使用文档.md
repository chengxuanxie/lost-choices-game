# 火山引擎 TOS 对象存储上传工具使用文档

## 目录

- [简介](#简介)
- [环境准备](#环境准备)
- [安装依赖](#安装依赖)
- [快速开始](#快速开始)
- [API参考](#api参考)
- [命令行使用](#命令行使用)
- [使用示例](#使用示例)
- [常见问题](#常见问题)
- [错误处理](#错误处理)

---

## 简介

本工具是对火山引擎**对象存储服务 TOS（Torch Object Storage）** 的Python封装，提供简洁易用的接口进行对象存储操作。

### 主要功能

- **创建桶**: 创建存储桶，支持设置公共读权限
- **上传文件**: 上传单个文件或整个目录，自动获取公网访问链接
- **删除对象**: 删除桶内的单个对象
- **删除桶**: 删除存储桶（支持强制清空后删除）
- **列出对象**: 查看桶内对象列表

### 特性

- 简洁的API设计
- 支持单文件和目录上传
- 自动检测文件类型
- 公共读桶自动配置策略
- 完整的错误处理
- 命令行支持
- 配置灵活（参数/环境变量/配置文件）

---

## 环境准备

### 前置条件

1. **Python版本**: Python 3.7+
2. **火山引擎账号**: 需要开通TOS服务
3. **AK/SK**: 从火山引擎控制台获取Access Key和Secret Key

### 获取AK/SK

1. 登录[火山引擎控制台](https://console.volcengine.com/)
2. 进入"访问控制" -> "访问密钥"
3. 创建或查看已有的Access Key

### 获取Endpoint和Region

| 区域 | Endpoint | Region |
|------|----------|--------|
| 北京 | tos-cn-beijing.volces.com | cn-beijing |
| 上海 | tos-cn-shanghai.volces.com | cn-shanghai |
| 广州 | tos-cn-guangzhou.volces.com | cn-guangzhou |

### 配置AK/SK

支持三种方式配置，按优先级从高到低：

#### 方式1: 直接传入参数（优先级最高）

```python
uploader = TOSUploader(ak="your_access_key", sk="your_secret_key")
```

#### 方式2: 环境变量

```bash
# Linux/macOS
export VOLC_ACCESSKEY="your_access_key"
export VOLC_SECRETKEY="your_secret_key"
export VOLC_TOS_ENDPOINT="tos-cn-beijing.volces.com"
export VOLC_TOS_REGION="cn-beijing"

# Windows (PowerShell)
$env:VOLC_ACCESSKEY="your_access_key"
$env:VOLC_SECRETKEY="your_secret_key"
```

#### 方式3: 配置文件 config.json（优先级最低）

在脚本所在目录创建 `config.json` 文件：

```json
{
  "ak": "your_access_key",
  "sk": "your_secret_key",
  "endpoint": "tos-cn-beijing.volces.com",
  "region": "cn-beijing"
}
```

> **注意**: 配置文件应添加到 `.gitignore` 中，避免泄露密钥。

---

## 安装依赖

```bash
# 安装火山引擎TOS Python SDK
pip install tos
```

或者使用requirements.txt:

```bash
pip install -r requirements.txt
```

requirements.txt内容:
```
tos>=2.0.0
```

---

## 快速开始

### 代码方式

```python
from tos_uploader import TOSUploader, BucketACL

# 方式1: 使用配置文件 config.json 中的 ak/sk（推荐）
uploader = TOSUploader()

# 方式2: 使用环境变量
# uploader = TOSUploader()

# 方式3: 直接传入参数
# uploader = TOSUploader(ak="your_ak", sk="your_sk")

# 创建公共读桶
result = uploader.create_bucket("my-bucket", BucketACL.PUBLIC_READ)
print(f"创建桶: {'成功' if result.success else '失败'}")

# 上传文件
result = uploader.upload_file(
    bucket_name="my-bucket",
    file_path="./image.png"
)

if result.success:
    print(f"上传成功！")
    print(f"访问URL: {result.url}")
else:
    print(f"上传失败: {result.message}")
```

### 命令行方式

```bash
# 创建公共读桶
python tos_uploader.py create-bucket --bucket my-bucket --public

# 上传文件
python tos_uploader.py upload --bucket my-bucket --file ./image.png

# 获取访问链接（输出中会显示）
# https://my-bucket.tos-cn-beijing.volces.com/image.png
```

---

## API参考

### TOSUploader 类

主上传类，封装所有对象存储功能。

#### 初始化参数

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| ak | str | 否 | 从环境变量或config.json获取 | 火山引擎Access Key |
| sk | str | 否 | 从环境变量或config.json获取 | 火山引擎Secret Key |
| endpoint | str | 否 | tos-cn-beijing.volces.com | TOS服务端点 |
| region | str | 否 | cn-beijing | 区域 |
| config_path | str | 否 | None | 配置文件路径 |

> **配置优先级**: 参数 > 环境变量 > 配置文件 `config.json`

#### create_bucket() 方法

创建存储桶。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称（全局唯一） |
| acl | BucketACL | 否 | PRIVATE | 访问权限 |

**返回值: BucketResult**

| 字段 | 类型 | 说明 |
|------|------|------|
| success | bool | 是否成功 |
| bucket_name | str | 桶名称 |
| message | str | 结果消息 |
| error_code | int | 错误码 |
| request_id | str | 请求ID |

#### upload_file() 方法

上传文件到存储桶。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| file_path | str | 是 | - | 本地文件路径 |
| object_key | str | 否 | 文件名 | 对象键名（存储路径） |
| content_type | str | 否 | 自动检测 | 内容类型 |

**返回值: UploadResult**

| 字段 | 类型 | 说明 |
|------|------|------|
| success | bool | 是否成功 |
| object_key | str | 对象键名 |
| url | str | 公网访问URL |
| bucket | str | 桶名称 |
| message | str | 结果消息 |
| error_code | int | 错误码 |
| request_id | str | 请求ID |

#### upload_directory() 方法

上传整个目录。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| dir_path | str | 是 | - | 本地目录路径 |
| prefix | str | 否 | "" | 对象键前缀 |

#### delete_object() 方法

删除对象。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| object_key | str | 是 | - | 对象键名 |

#### delete_bucket() 方法

删除存储桶。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| force | bool | 否 | False | 是否强制删除（先清空桶内对象） |

#### list_objects() 方法

列出桶内对象。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| prefix | str | 否 | "" | 对象键前缀 |

**返回值: List[str]** - 对象键列表

#### get_object_url() 方法

获取对象的临时签名URL。

**参数说明:**

| 参数 | 类型 | 必选 | 默认值 | 说明 |
|------|------|------|--------|------|
| bucket_name | str | 是 | - | 桶名称 |
| object_key | str | 是 | - | 对象键名 |
| expires | int | 否 | 3600 | URL有效期（秒） |

### BucketACL 枚举

桶访问权限枚举值:

| 值 | 说明 |
|------|------|
| PRIVATE | 私有读写 |
| PUBLIC_READ | 公共读，私有写 |
| PUBLIC_READ_WRITE | 公共读写 |

---

## 命令行使用

### 基本语法

```bash
python tos_uploader.py <command> [选项]
```

### 可用命令

| 命令 | 说明 |
|------|------|
| create-bucket | 创建存储桶 |
| upload | 上传文件 |
| upload-dir | 上传目录 |
| list | 列出桶内对象 |
| delete-object | 删除对象 |
| delete-bucket | 删除存储桶 |

### 通用选项

| 选项 | 默认值 | 说明 |
|------|--------|------|
| --ak | 从环境变量或config.json获取 | 火山引擎Access Key |
| --sk | 从环境变量或config.json获取 | 火山引擎Secret Key |
| --endpoint | tos-cn-beijing.volces.com | TOS服务端点 |
| --region | cn-beijing | 区域 |
| --config | 脚本目录下的config.json | 配置文件路径 |

### create-bucket 选项

| 选项 | 必选 | 说明 |
|------|------|------|
| --bucket, -b | 是 | 桶名称 |
| --public | 否 | 设置为公共读 |

### upload 选项

| 选项 | 必选 | 说明 |
|------|------|------|
| --bucket, -b | 是 | 桶名称 |
| --file, -f | 是 | 本地文件路径 |
| --key, -k | 否 | 对象键名 |

### upload-dir 选项

| 选项 | 必选 | 说明 |
|------|------|------|
| --bucket, -b | 是 | 桶名称 |
| --dir, -d | 是 | 本地目录路径 |
| --prefix, -p | 否 | 对象键前缀 |

### delete-bucket 选项

| 选项 | 必选 | 说明 |
|------|------|------|
| --bucket, -b | 是 | 桶名称 |
| --force | 否 | 强制删除（清空桶内对象） |

---

## 使用示例

### 示例1: 创建公共读桶并上传图片

```python
from tos_uploader import TOSUploader, BucketACL

# 使用配置文件中的 ak/sk
uploader = TOSUploader()

# 创建公共读桶
result = uploader.create_bucket("my-images", BucketACL.PUBLIC_READ)
if not result.success:
    print(f"创建桶失败: {result.message}")
    exit(1)

# 上传图片
result = uploader.upload_file(
    bucket_name="my-images",
    file_path="./photo.jpg"
)

if result.success:
    print(f"图片已上传，访问链接: {result.url}")
    # 输出: https://my-images.tos-cn-beijing.volces.com/photo.jpg
```

### 示例2: 批量上传图片

```python
import os
from tos_uploader import TOSUploader

uploader = TOSUploader()

# 上传整个目录
results = uploader.upload_directory(
    bucket_name="my-images",
    dir_path="./photos",
    prefix="2024/vacation"
)

for result in results:
    if result.success:
        print(f"上传成功: {result.url}")
    else:
        print(f"上传失败: {result.message}")
```

### 示例3: 命令行使用

```bash
# 创建私有桶
python tos_uploader.py create-bucket --bucket my-private-bucket

# 创建公共读桶
python tos_uploader.py create-bucket --bucket my-public-bucket --public

# 上传单个文件
python tos_uploader.py upload --bucket my-public-bucket --file ./image.png

# 上传文件并指定存储路径
python tos_uploader.py upload -b my-public-bucket -f ./photo.jpg -k images/2024/photo.jpg

# 上传整个目录
python tos_uploader.py upload-dir -b my-public-bucket -d ./assets -p static

# 列出桶内对象
python tos_uploader.py list --bucket my-public-bucket

# 删除单个对象
python tos_uploader.py delete-object -b my-public-bucket -k image.png

# 删除桶（需要先清空或使用 --force）
python tos_uploader.py delete-bucket -b my-public-bucket --force
```

### 示例4: 获取临时访问链接

```python
from tos_uploader import TOSUploader

uploader = TOSUploader()

# 获取1小时有效的签名URL（适用于私有桶）
url = uploader.get_object_url(
    bucket_name="my-private-bucket",
    object_key="secret-image.png",
    expires=3600
)
print(f"临时访问链接（1小时有效）: {url}")
```

---

## 常见问题

### Q1: 桶名称有什么要求？

- 3-63个字符
- 只能包含小写字母、数字和短横线（-）
- 必须以字母或数字开头和结尾
- 全局唯一（所有用户）

### Q2: 公共读桶和私有桶有什么区别？

- **公共读桶**: 任何人都可以通过URL直接访问对象
- **私有桶**: 需要签名URL才能访问对象

### Q3: 上传后的URL格式是什么？

```
https://{bucket-name}.{endpoint}/{object-key}
```

例如：
```
https://my-images.tos-cn-beijing.volces.com/photo.jpg
```

### Q4: 如何排查问题？

1. 检查 `result.success` 和 `result.message`
2. 保存 `result.request_id` 用于联系技术支持
3. 确认AK/SK配置正确
4. 确认endpoint和region匹配

---

## 错误处理

### 常见错误码

| 错误码 | 说明 | 处理建议 |
|--------|------|----------|
| 403 | 权限不足 | 检查AK/SK是否正确，是否有对应权限 |
| 404 | 桶或对象不存在 | 检查桶名称和对象键名 |
| 409 | 桶已存在 | 更换桶名称 |
| -1 | 客户端错误 | 检查网络连接和参数 |

### 错误处理示例

```python
result = uploader.upload_file("my-bucket", "./image.png")

if not result.success:
    if result.error_code == 404:
        print("桶不存在，请先创建")
    elif result.error_code == 403:
        print("权限不足，请检查AK/SK")
    else:
        print(f"上传失败: {result.message}")
        if result.request_id:
            print(f"Request ID: {result.request_id}")
```

---

## 技术支持

- 火山引擎TOS文档: https://www.volcengine.com/docs/6349/74837?lang=zh
- TOS Python SDK文档: https://www.volcengine.com/docs/6349/92785
- GitHub Issues: https://github.com/volcengine/volc-sdk-python/issues

---

## 更新日志

### v1.0.0 (2026-02-22)
- 初始版本
- 支持创建桶（公共读/私有）
- 支持上传文件和目录
- 支持删除对象和桶
- 支持列出桶内对象
- 支持获取签名URL
- 命令行支持
