#!/usr/bin/env python3
"""
剧情分支查看器
用于可视化 chapter_01_hybrid.json 的剧情结构和节点数据
"""

import json
import os
from pathlib import Path

def load_chapter_data(json_path: str) -> dict:
    """加载章节数据"""
    with open(json_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def analyze_nodes(nodes: dict) -> dict:
    """分析节点数据"""
    analysis = {
        'total_nodes': len(nodes),
        'node_types': {},
        'nodes_with_choices': 0,
        'nodes_with_video': 0,
        'nodes_with_keyframes': 0,
        'endings': [],
        'choice_counts': {},
        'next_node_refs': set()
    }

    for node_id, node_data in nodes.items():
        # 统计节点类型
        node_type = node_data.get('node_type', 'unknown')
        analysis['node_types'][node_type] = analysis['node_types'].get(node_type, 0) + 1

        # 检查视频
        if 'video' in node_data and node_data['video']:
            analysis['nodes_with_video'] += 1

        # 检查关键帧
        if 'keyframes' in node_data and node_data['keyframes']:
            analysis['nodes_with_keyframes'] += 1

        # 检查选择
        choices = node_data.get('choices', [])
        if choices:
            analysis['nodes_with_choices'] += 1
            analysis['choice_counts'][node_id] = len(choices)

            # 收集下一个节点引用
            for choice in choices:
                next_node = choice.get('next_node', '')
                if next_node:
                    analysis['next_node_refs'].add(next_node)

        # 收集结局
        if node_type == 'ending':
            ending_info = {
                'id': node_id,
                'name': node_data.get('ending_name', node_id),
                'description': node_data.get('description', '')
            }
            analysis['endings'].append(ending_info)

    return analysis

def check_broken_links(nodes: dict) -> list:
    """检查断开的链接"""
    broken = []
    all_node_ids = set(nodes.keys())

    for node_id, node_data in nodes.items():
        choices = node_data.get('choices', [])
        for choice in choices:
            next_node = choice.get('next_node', '')
            if next_node and next_node not in all_node_ids:
                broken.append({
                    'from': node_id,
                    'choice': choice.get('text', '')[:30],
                    'to': next_node
                })

    return broken

def generate_markdown(data: dict, output_path: str):
    """生成 Markdown 可视化文档"""
    nodes = data.get('nodes', {})
    analysis = analyze_nodes(nodes)
    broken_links = check_broken_links(nodes)

    md = f"""# {data.get('title', '未知章节')} - 剧情结构分析

## 基本信息

| 属性 | 值 |
|------|-----|
| 章节ID | {data.get('chapter_id', 'N/A')} |
| 描述 | {data.get('description', 'N/A')} |
| 起始节点 | {data.get('start_node', 'N/A')} |

## 统计概览

| 指标 | 数量 |
|------|------|
| 总节点数 | {analysis['total_nodes']} |
| 有视频节点 | {analysis['nodes_with_video']} |
| 有关键帧节点 | {analysis['nodes_with_keyframes']} |
| 有选择的节点 | {analysis['nodes_with_choices']} |
| 结局数量 | {len(analysis['endings'])} |

### 节点类型分布

"""

    for node_type, count in analysis['node_types'].items():
        md += f"- **{node_type}**: {count} 个\n"

    md += f"""
## 节点列表

| 节点ID | 类型 | 场景名 | 选择数 | 视频 | 关键帧 |
|--------|------|--------|--------|------|--------|
"""

    for node_id, node_data in nodes.items():
        node_type = node_data.get('node_type', 'unknown')
        scene = node_data.get('scene', '-')
        choices = len(node_data.get('choices', []))
        has_video = '✓' if node_data.get('video') else '-'
        has_kf = '✓' if node_data.get('keyframes') else '-'
        md += f"| {node_id} | {node_type} | {scene} | {choices} | {has_video} | {has_kf} |\n"

    md += f"""
## 节点详情

"""

    for node_id, node_data in nodes.items():
        md += f"""
### {node_id}: {node_data.get('scene', '未知场景')}

- **类型**: {node_data.get('node_type', 'unknown')}
- **描述**: {node_data.get('description', '无')}

"""

        # 视频信息
        video = node_data.get('video', {})
        if video:
            md += f"- **视频**: {video.get('path', 'N/A')} (时长: {video.get('duration', 'N/A')}s)\n"

        # 关键帧信息
        keyframes = node_data.get('keyframes', {})
        if keyframes:
            frames = keyframes.get('frames', [])
            md += f"- **关键帧**: {len(frames)} 张\n"

        # 选择信息
        choices = node_data.get('choices', [])
        if choices:
            md += f"\n**选择项 ({len(choices)} 个):**\n"
            for i, choice in enumerate(choices, 1):
                next_node = choice.get('next_node', '-')
                effects = choice.get('effects', [])
                effect_summary = f"{len(effects)} 个效果" if effects else "无效果"
                md += f"{i}. **{choice.get('text', '未知选项')}**\n"
                md += f"   - 下一节点: `{next_node}`\n"
                md += f"   - 效果: {effect_summary}\n"

    # 结局详情
    if analysis['endings']:
        md += f"""
## 结局列表

"""
        for ending in analysis['endings']:
            md += f"""### {ending['id']}: {ending['name']}

{ending['description']}

"""

    # 断开的链接检查
    if broken_links:
        md += f"""
## ⚠️ 问题检测

### 断开的节点链接

| 来源节点 | 选择 | 目标节点 |
|----------|------|----------|
"""
        for broken in broken_links:
            md += f"| {broken['from']} | {broken['choice']} | {broken['to']} |\n"

    # 写入文件
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(md)

    print(f"✅ 剧情结构分析已生成: {output_path}")
    print(f"   - 总节点数: {analysis['total_nodes']}")
    print(f"   - 有视频节点: {analysis['nodes_with_video']}")
    print(f"   - 结局数: {len(analysis['endings'])}")
    if broken_links:
        print(f"   - ⚠️ 断开链接: {len(broken_links)} 个")

def generate_dot_graph(data: dict, output_path: str):
    """生成 DOT 图形格式（可用于 Graphviz）"""
    nodes = data.get('nodes', {})

    dot = """digraph story_flow {
    rankdir=LR;
    node [shape=box, style=rounded];

"""

    # 添加节点
    for node_id, node_data in nodes.items():
        node_type = node_data.get('node_type', 'unknown')
        scene = node_data.get('scene', node_id)

        # 根据类型设置不同颜色
        if node_type == 'ending':
            color = 'lightgreen'
        elif node_type == 'choice':
            color = 'lightblue'
        else:
            color = 'lightgray'

        # 转义引号
        scene_escaped = scene.replace('"', '\\"')
        dot += f'    "{node_id}" [label="{node_id}\\n{scene_escaped}", fillcolor={color}];\n'

    dot += "\n"

    # 添加边（选择关系）
    for node_id, node_data in nodes.items():
        choices = node_data.get('choices', [])
        for choice in choices:
            next_node = choice.get('next_node', '')
            if next_node:
                choice_text = choice.get('text', '')[:20].replace('"', '\\"')
                dot += f'    "{node_id}" -> "{next_node}" [label="{choice_text}"];\n'

    dot += "}\n"

    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(dot)

    print(f"✅ DOT 图形已生成: {output_path}")
    print("   (可使用 Graphviz 或在线工具转换为图片)")

if __name__ == '__main__':
    import sys
    # 设置 UTF-8 输出
    sys.stdout.reconfigure(encoding='utf-8')

    # 配置路径
    base_path = Path(__file__).parent.parent / 'lost-choices' / 'data' / 'stories'
    json_path = base_path / 'chapter_01_hybrid.json'

    print("=" * 50)
    print("剧情分支查看器")
    print("=" * 50)

    if not json_path.exists():
        print(f"❌ 文件不存在: {json_path}")
        exit(1)

    # 加载数据
    print(f"\n📂 加载: {json_path}")
    data = load_chapter_data(json_path)

    # 生成 Markdown 文档
    md_output = base_path / 'chapter_01_structure.md'
    generate_markdown(data, str(md_output))

    # 生成 DOT 图形
    dot_output = base_path / 'chapter_01_flow.dot'
    generate_dot_graph(data, str(dot_output))

    print("\n✅ 完成!")
