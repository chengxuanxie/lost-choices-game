# 沈墨染 - 图片URL记录

> 此文件记录所有生成图片的TOS公网URL，便于后续图生图操作
>
> **存储桶**: lost-choices-art
> **基础URL**: https://lost-choices-art.tos-cn-beijing.volces.com

---

## 基准参考图

| 图片ID | 文件名 | TOS URL |
|--------|--------|---------|
| shen_moran_full | shen_moran_full_20260222_050352_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_full_20260222_050352_1.png |

---

## 面部表情特写

| 图片ID | 表情 | TOS URL |
|--------|------|---------|
| shen_moran_face_01 | 慵懒 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_face_01_20260222_050444_1.png |
| shen_moran_face_02 | 好奇 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_face_02_20260222_050717_1.png |
| shen_moran_face_03 | 思考 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_face_03_20260222_050826_1.png |
| shen_moran_face_04 | 叛逆 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_face_04_20260222_050932_1.png |

---

## 服装参考

| 图片ID | 服装类型 | TOS URL |
|--------|----------|---------|
| shen_moran_cloth_01 | 画室装束(宽松卫衣+颜料) | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_cloth_01_20260222_051027_1.png |

---

## 姿态参考

| 图片ID | 姿态描述 | TOS URL |
|--------|----------|---------|
| shen_moran_pose_01 | 作画姿态 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_pose_01_20260222_051920_1.png |

---

## 图生图使用说明

```python
from jimeng4_generator import JiMeng4Generator

gen = JiMeng4Generator()

# 使用基准参考图生成新图片
result = gen.generate(
    prompt="沈墨染在画室中，手持画笔创作",
    image_urls=["https://lost-choices-art.tos-cn-beijing.volces.com/characters/shen_moran/shen_moran_full_20260222_050352_1.png"],
    output_dir="./output"
)
```

---

**创建日期**: 2026-02-22
**最后更新**: 2026-02-22
**存储源**: 火山引擎TOS（永久存储）
