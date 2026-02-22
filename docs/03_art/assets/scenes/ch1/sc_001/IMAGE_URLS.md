# SC-001 神秘房间 - 图片URL记录

> 此文件记录所有生成图片的TOS公网URL，便于后续图生图操作
>
> **存储桶**: lost-choices-art
> **基础URL**: https://lost-choices-art.tos-cn-beijing.volces.com

---

## 图片列表

| 图片ID | 文件名 | TOS URL |
|--------|--------|---------|
| sc_001_env_01 | sc_001_env_01_20260222_035652_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_env_01_20260222_035652_1.png |
| sc_001_env_02 | sc_001_env_02_20260222_035819_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_env_02_20260222_035819_1.png |
| sc_001_detail_01 | sc_001_detail_01_20260222_040001_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_detail_01_20260222_040001_1.png |
| sc_001_detail_02 | sc_001_detail_02_20260222_040117_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_detail_02_20260222_040117_1.png |
| sc_001_detail_03 | sc_001_detail_03_20260222_040311_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_detail_03_20260222_040311_1.png |
| sc_001_detail_04 | sc_001_detail_04_20260222_040344_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_detail_04_20260222_040344_1.png |
| sc_001_light_01 | sc_001_light_01_20260222_041525_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_light_01_20260222_041525_1.png |

---

## 参考图用途说明

| 图片ID | 用途 | 描述 |
|--------|------|------|
| sc_001_env_01 | 环境全景 | 整体房间氛围，作为视频主背景参考 |
| sc_001_env_02 | 环境全景 | 床铺视角，开场镜头参考 |
| sc_001_detail_01 | 细节特写 | 床头柜特写，交互元素参考 |
| sc_001_detail_02 | 细节特写 | 门和电子锁特写，关键道具 |
| sc_001_detail_03 | 细节特写 | 窗户和窗帘，氛围元素 |
| sc_001_detail_04 | 细节特写 | 墙上神秘符号，重要伏笔 |
| sc_001_light_01 | 光影参考 | 整体光影效果，统一视觉风格 |

---

## 图生图使用示例

```python
from jimeng4_generator import JiMeng4Generator

gen = JiMeng4Generator()

# 使用场景参考图生成视频分镜
result = gen.generate(
    prompt="第一人称视角，慢慢从床上坐起，环顾四周神秘房间",
    image_urls=["https://lost-choices-art.tos-cn-beijing.volces.com/scenes/ch1/sc_001/sc_001_env_01_20260222_035652_1.png"],
    output_dir="./output"
)
```

---

**创建日期**: 2026-02-22
**最后更新**: 2026-02-22
**存储源**: 火山引擎TOS（永久存储）
