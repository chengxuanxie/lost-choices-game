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
## Prompt建议
### 用于文本生成图像的提示词 。建议：
建议用连贯的自然语言描述画面内容（主体+行为+环境等），用短词语描述画面美学（风格、色彩、光影、构图等）
组图生成：当有多图生成意图时，可以通过“一系列”“组图”“帮我生成几张图”等提示词触发组图，最多支持生成10张
比例指定：可在提示词中直接输入比例指令，也支持根据提示词中的应用场景自动推理适配的比例尺寸
提升文字准确率：把想要生成的文字内容插入“”引号中。例如：生成一张海报，标题为“Seedream V4.0”
提升指令响应：专业词汇使用词源语言，效果更准确
提升场景适配度：在有明确应用场景时，推荐写出图像用途和类型。 例如：用于 PPT封面背景

### 用于编辑图像的提示词 。建议：
用清晰明确的指令通常能实现更好的编辑效果，常见公式为 变化动作 + 变化对象 + 变化特征，如： 将骑士的头盔变为金色
当有明确需要保持的角色形象、产品信息、风格等特征时，你可以输入图像作为参考来保持一致性
使用精确的风格词或直接输入图像作为风格参考，有助于获得更理想的效果
上传多张参考图时，明确指出不同图片需参考/编辑的不同元素可提高精准度，例如：将图1中的角色放入图2的背景中，参考图3的风格进行生成##
