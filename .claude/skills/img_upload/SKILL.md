---
name: img_upload
description: 火山引擎 TOS 对象存储操作，支持对桶和桶内对象的各种操作，可用于保存图片/视频等内容获得公网可访问链接
---

按照如下指导完成图片/视频上传并获得公网可访问url：
1. 阅读`tos_uploader_使用文档`了解用法；
2. 根据用户诉求识别对象要保存在哪个桶上，如果桶不存在则需要通过`tos_uploader.py`脚本新建桶；
3. 检查图片对象在桶内是否已经存在，如果存在则不需要重新上传；
4. 如果桶时私有桶，则需要通过`tos_uploader.py`脚本将桶访问策略更新为公共读，如果只需要临时公网访问可以通过`tos_uploader.py`脚本将对象进行URL的预签名；
5. 通过`tos_uploader.py`脚本获取图片的公网可访问URL

## 重要说明

### 路径分隔符
**object_key（对象键）必须使用正斜杠 `/` 作为路径分隔符**，无论操作系统是什么。

脚本会自动将反斜杠 `\` 转换为正斜杠 `/`，因为：
- TOS 对象存储使用正斜杠作为路径分隔符
- URL 中只能使用正斜杠
- Windows 系统的本地路径使用反斜杠，但上传时必须转换为正斜杠

**正确示例:**
```
characters/lin_xiaowei/lin_xiaowei_full.png
scenes/ch1/sc_001/sc_001_env_01.png
```

**错误示例（会导致URL无法正常访问）:**
```
characters\lin_xiaowei\lin_xiaowei_full.png  ❌
scenes\ch1\sc_001\sc_001_env_01.png  ❌
```

## 配置优先级
脚本支持三种方式配置AK/SK，按优先级从高到低：
1. **命令行参数**: --ak / --sk（优先级最高）
2. **环境变量**: VOLC_ACCESSKEY / VOLC_SECRETKEY
3. **配置文件**: config.json（优先级最低，位于脚本同目录）

## 配置文件格式 (config.json)
```json
{
  "ak": "your_access_key",
  "sk": "your_secret_key"
}
```

## 使用示例
### 命令行方式

```bash
# 创建公共读桶
python tos_uploader.py create-bucket --bucket my-bucket --public

# 上传文件
python tos_uploader.py upload --bucket my-bucket --file ./image.png

# 获取访问链接（输出中会显示）
# https://my-bucket.tos-cn-beijing.volces.com/image.png
```
