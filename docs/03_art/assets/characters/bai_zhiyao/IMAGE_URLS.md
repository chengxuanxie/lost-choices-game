# 白芷瑶 - 图片URL记录

> 此文件记录所有生成图片的TOS公网URL，便于后续图生图操作
>
> **存储桶**: lost-choices-art
> **基础URL**: https://lost-choices-art.tos-cn-beijing.volces.com

---

## 基准参考图

| 图片ID | 文件名 | TOS URL |
|--------|--------|---------|
| bai_zhiyao_full | bai_zhiyao_full_20260222_044330_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_full_20260222_044330_1.png |

---

## 面部表情特写

| 图片ID | 表情 | TOS URL |
|--------|------|---------|
| bai_zhiyao_face_01 | 温柔微笑 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_face_01_20260222_044419_1.png |
| bai_zhiyao_face_02 | 倾听 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_face_02_20260222_044504_1.png |
| bai_zhiyao_face_03 | 关心 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_face_03_20260222_044600_1.png |
| bai_zhiyao_face_04 | 神秘 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_face_04_20260222_044801_1.png |

---

## 服装参考

| 图片ID | 服装类型 | TOS URL |
|--------|----------|---------|
| bai_zhiyao_cloth_01 | 工作装束(米色针织开衫+长裙) | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_cloth_01_20260222_044902_1.png |
| bai_zhiyao_cloth_02 | 正式装束(淡蓝色连衣裙) | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_cloth_02_20260222_044949_1.png |

---

## 姿态参考

| 图片ID | 姿态描述 | TOS URL |
|--------|----------|---------|
| bai_zhiyao_pose_01 | 坐姿倾听 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_pose_01_20260222_045039_1.png |

---

## 图生图使用说明

```python
from jimeng4_generator import JiMeng4Generator

gen = JiMeng4Generator()

# 使用基准参考图生成新图片
result = gen.generate(
    prompt="白芷瑶在心理咨询室中，温柔地看着镜头",
    image_urls=["https://lost-choices-art.tos-cn-beijing.volces.com/characters/bai_zhiyao/bai_zhiyao_full_20260222_044330_1.png"],
    output_dir="./output"
)
```

---

**创建日期**: 2026-02-22
**最后更新**: 2026-02-22
**存储源**: 火山引擎TOS（永久存储）
