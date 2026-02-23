---
name: video_gen
description: 即梦AI视频生成3.0 Pro工具，支持文生视频和图生视频。每次使用这个skill前都必须询问是否要使用。文生视频根据文本描述生成高质量1080P视频；图生视频基于输入图片生成动态视频内容，支持单图或多图（最多4张）输入。触发示例:`请生成一个视频：一只可爱的猫咪在花园里玩耍` 或 `请将这张图片生成为视频 https://example.com/cat.jpg` 或 `请用这几张图片生成一个视频 https://a.jpg https://b.jpg`
---
注意事项：API费用较高，每次使用这个skill前都必须询问是否要使用。
按照如下指导完成视频生成：
1. 使用python命令调用`./jimeng_video_generator.py`，可以默认环境已经具备，不要传递ak和sk字段，由脚本自身从环境变量或config.json获取
2. `./jimeng_video_generator.py`脚本支持的参数可以查阅`./jimeng_video_generator_使用文档.md`
3. 根据用户的要求，将其转换成具体的参数传递给`jimeng_video_generator.py`

## 功能说明

### 文生视频 (Text to Video)
根据文本描述生成视频，支持丰富的场景描述和动作指令。

```bash
# 文生视频示例
python jimeng_video_generator.py --prompt "一只可爱的橘猫在阳光明媚的花园里追逐蝴蝶" --output ./output
```

### 图生视频 (Image to Video)
基于输入图片生成动态视频，支持单图或多图输入（最多4张）。

```bash
# 图生视频（单图）
python jimeng_video_generator.py --prompt "让猫咪眨眼并摇尾巴" --image https://example.com/cat.jpg --output ./output

# 图生视频（多图，最多4张）
python jimeng_video_generator.py --prompt "让这些人一起跳舞" --images https://example.com/person1.jpg https://example.com/person2.jpg --output ./output
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
```bash
# 基本文生视频（使用config.json中的ak/sk，推荐）
python jimeng_video_generator.py --prompt "一只可爱的猫咪在玩耍" --output ./output

# 图生视频
python jimeng_video_generator.py --prompt "让画面动起来" --image https://example.com/cat.jpg --output ./output

# 指定配置文件路径
python jimeng_video_generator.py --config /path/to/config.json --prompt "夕阳下的海滩" --output ./output

# 显式指定 ak/sk（优先级最高，不推荐）
python jimeng_video_generator.py --ak your_ak --sk your_sk --prompt "城市夜景" --output ./output
```
## Prompt建议
### 用于生成视频的提示词 。建议：
【提示词结构】
1、基础结构：主体 / 背景 / 镜头 + 动作
2、多个镜头连贯叙事：镜头1 + 主体 + 动作1 + 镜头2 + 主体 + 动作2 ...
3、 多个连续动作：
时序性的多个连续动作： 主体1 + 运动1 + 运动2
多主体的不同动作：主体1 + 运动1 + 主体2 + 运动2 ...

### 【提示词词典】
1、运镜
切换：“镜头切换”
平移：“镜头向上/下/左/右移动”
推轨：“镜头拉近/拉远”
环形跟踪：“镜头环绕”、“航拍”、“广角”、“镜头360度旋转”
跟随：“镜头跟随”
固定：“固定镜头”、“镜头静止不动”
聚焦：“镜头特写”
手持：“镜头晃动 / 抖动”、“手持拍摄”、“动态不稳定”
2、程度副词：可以通过程度副词，突出主体动作频率与强度，或者特征，如“快速” 、“大幅度”、“高频率”、“剧烈”、“缓缓”
