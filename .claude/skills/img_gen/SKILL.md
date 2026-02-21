---
name: img_gen
description: 即梦4.0 AI图像生成工具，可实现根据文本描述生成图像、基于参考图进行图像编辑、多图组合（支持最多10张参考图输入）、高清输出（支持1K/2K/4K分辨率输出）、批量生成（一次最多生成15张关联图像）；触发示例:`请逐个读取asset目录下的所有md文件，并生成文件所描述的图片，图片放在在md文件所在目录下，名字和格式按照md文件的命令来，如home.png表示生成的图片名为home格式为png`
---

按照如下指导完成图片生成：
1. 使用python命令调用`./jimeng4_generator.py`，可以默认环境已经具备，不要传递ak和sk字段，由脚本自身从环境变量或config.json获取
2. `./jimeng4_generator.py`脚本支持的参数可以查阅`./jimeng4_generator_使用文档.md`
3. 根据用户的要求，将其转换成具体的参数传递给`jimeng4_generator.py`

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
```bash
# 基本文生图（使用config.json中的ak/sk，推荐）
python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

# 图生图
python jimeng4_generator.py --prompt "换成海边背景" --images https://example.com/cat.jpg

# 指定配置文件路径
python jimeng4_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪" --output ./output

# 显式指定 ak/sk（优先级最高，不推荐）
python jimeng4_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪" --output ./output
```
