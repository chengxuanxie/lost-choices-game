# 林晓薇 - 图片URL记录

> 此文件记录所有生成图片的TOS公网URL，便于后续图生图操作
>
> **存储桶**: lost-choices-art
> **基础URL**: https://lost-choices-art.tos-cn-beijing.volces.com

---

## 基准参考图

| 图片ID | 文件名 | TOS URL |
|--------|--------|---------|
| lin_xiaowei_full | lin_xiaowei_full_20260222_041655_1.png | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_full_20260222_041655_1.png |

---

## 面部表情特写

| 图片ID | 表情 | TOS URL |
|--------|------|---------|
| lin_xiaowei_face_01 | 微笑 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_face_01_20260222_041748_1.png |
| lin_xiaowei_face_02 | 严肃 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_face_02_20260222_041834_1.png |
| lin_xiaowei_face_03 | 担忧 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_face_03_20260222_042138_1.png |
| lin_xiaowei_face_04 | 坚定 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_face_04_20260222_042754_1.png |
| lin_xiaowei_face_05 | 思考 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_face_05_20260222_042838_1.png |

---

## 服装参考

| 图片ID | 服装类型 | TOS URL |
|--------|----------|---------|
| lin_xiaowei_cloth_01 | 日常装束(白衬衫+牛仔裤) | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_cloth_01_20260222_043008_1.png |
| lin_xiaowei_cloth_02 | 外出调查装(黑色外套+工装裤) | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_cloth_02_20260222_043113_1.png |

---

## 姿态参考

| 图片ID | 姿态描述 | TOS URL |
|--------|----------|---------|
| lin_xiaowei_pose_01 | 站立交谈 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_pose_01_20260222_043941_1.png |
| lin_xiaowei_pose_02 | 查看文件 | https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_pose_02_20260222_044111_1.png |

---

## 图生图使用说明

使用上述URL作为参考图时，在新图片生成中保持角色一致性：

```python
from jimeng4_generator import JiMeng4Generator

gen = JiMeng4Generator()

# 使用基准参考图生成新图片
result = gen.generate(
    prompt="林晓薇在咖啡馆场景中，微笑着看向镜头",
    image_urls=["https://lost-choices-art.tos-cn-beijing.volces.com/characters/lin_xiaowei/lin_xiaowei_full_20260222_041655_1.png"],
    output_dir="./output"
)
```

---

**创建日期**: 2026-02-22
**最后更新**: 2026-02-22
**存储源**: 火山引擎TOS（永久存储）
