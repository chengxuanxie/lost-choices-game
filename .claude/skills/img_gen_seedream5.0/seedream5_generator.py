#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Seedream 5.0 图像生成器
支持文生图、图生图、多图融合、组图生成等功能

安装依赖: pip install 'volcengine-python-sdk[ark]'
"""

import os
import sys
import json
import argparse
import base64
from pathlib import Path
from typing import Optional, Union, List

try:
    from volcenginesdkarkruntime import Ark
    from volcenginesdkarkruntime.types.images.images import (
        SequentialImageGenerationOptions,
        OptimizePromptOptions
    )
except ImportError:
    print("请先安装SDK: pip install 'volcengine-python-sdk[ark]'")
    sys.exit(1)


class Seedream5Generator:
    """Seedream 5.0 图像生成器"""

    # 支持的模型
    MODELS = {
        '5.0-lite': 'doubao-seedream-5-0-lite-260128',
        '5.0': 'doubao-seedream-5-0-260128',
        '4.5': 'doubao-seedream-4-5-251128',
        '4.0': 'doubao-seedream-4-0-250828',
    }

    # 默认配置
    DEFAULT_MODEL = '5.0-lite'
    DEFAULT_SIZE = '2K'
    DEFAULT_OUTPUT_FORMAT = 'jpeg'
    BASE_URL = 'https://ark.cn-beijing.volces.com/api/v3'
    CONFIG_FILE = 'config.json'  # 默认配置文件名

    def __init__(self, api_key: Optional[str] = None, model: str = None, config_path: Optional[str] = None):
        """
        初始化生成器

        Args:
            api_key: API密钥，如果不提供则从环境变量或config.json读取
            model: 模型名称或模型ID
            config_path: 配置文件路径，默认为脚本目录下的config.json
        """
        # 配置优先级: 参数 > 环境变量 > config.json
        self.api_key = api_key or os.getenv('ARK_API_KEY')

        # 尝试从config.json读取
        if not self.api_key:
            self.api_key = self._load_api_key_from_config(config_path)

        if not self.api_key:
            raise ValueError("请提供API密钥或设置环境变量 ARK_API_KEY，或在config.json中配置api_key")

        # 解析模型
        if model:
            self.model = self.MODELS.get(model, model)
        else:
            self.model = self.MODELS[self.DEFAULT_MODEL]

        self.client = Ark(
            base_url=self.BASE_URL,
            api_key=self.api_key,
        )

    def _load_api_key_from_config(self, config_path: Optional[str] = None) -> Optional[str]:
        """从config.json加载API密钥"""
        # 确定配置文件路径
        if config_path:
            config_file = Path(config_path)
        else:
            # 默认为脚本所在目录的config.json
            config_file = Path(__file__).parent / self.CONFIG_FILE

        if not config_file.exists():
            return None

        try:
            with open(config_file, 'r', encoding='utf-8') as f:
                config = json.load(f)

            # 支持多种字段名
            return config.get('api_key') or config.get('ark_api_key') or config.get('ARK_API_KEY')
        except (json.JSONDecodeError, IOError) as e:
            print(f"警告: 读取配置文件失败: {e}")
            return None

    def generate(
        self,
        prompt: str,
        image: Optional[Union[str, List[str]]] = None,
        size: str = None,
        sequential: bool = False,
        max_images: int = 1,
        stream: bool = False,
        web_search: bool = False,
        output_format: str = None,
        watermark: bool = False,
        response_format: str = 'url',
        optimize_mode: str = None,
        **kwargs
    ) -> dict:
        """
        生成图像

        Args:
            prompt: 文本提示词
            image: 参考图片URL或URL列表
            size: 图像尺寸，如 '2K', '3K', '2048x2048'
            sequential: 是否生成组图
            max_images: 组图最大数量 (1-15)
            stream: 是否使用流式输出
            web_search: 是否启用联网搜索
            output_format: 输出格式 'png' 或 'jpeg'
            watermark: 是否添加水印
            response_format: 返回格式 'url' 或 'b64_json'
            optimize_mode: 提示词优化模式 'standard' 或 'fast'

        Returns:
            生成结果字典
        """
        # 构建请求参数
        params = {
            'model': self.model,
            'prompt': prompt,
            'response_format': response_format,
            'watermark': watermark,
        }

        # 添加参考图
        if image:
            params['image'] = image

        # 设置尺寸
        if size:
            params['size'] = size
        else:
            params['size'] = self.DEFAULT_SIZE

        # 组图生成配置
        if sequential:
            params['sequential_image_generation'] = 'auto'
            params['sequential_image_generation_options'] = SequentialImageGenerationOptions(
                max_images=max_images
            )
        else:
            params['sequential_image_generation'] = 'disabled'

        # 流式输出
        params['stream'] = stream

        # 联网搜索 (仅5.0-lite支持)
        if web_search:
            params['tools'] = [{'type': 'web_search'}]

        # 输出格式 (仅5.0-lite支持)
        if output_format and '5.0' in self.model:
            params['output_format'] = output_format
        elif output_format is None and '5.0' in self.model:
            params['output_format'] = self.DEFAULT_OUTPUT_FORMAT

        # 提示词优化
        if optimize_mode:
            params['optimize_prompt_options'] = OptimizePromptOptions(mode=optimize_mode)

        # 添加额外参数
        params.update(kwargs)

        return params

    def generate_sync(self, **kwargs) -> dict:
        """同步生成图像"""
        params = self.generate(stream=False, **kwargs)
        response = self.client.images.generate(**params)
        return self._parse_response(response)

    def generate_stream(self, **kwargs):
        """流式生成图像"""
        params = self.generate(stream=True, **kwargs)
        stream = self.client.images.generate(**params)

        for event in stream:
            if event is None:
                continue

            result = {'type': event.type}

            if event.type == 'image_generation.partial_failed':
                result['error'] = {
                    'code': str(event.error.code) if event.error else None,
                    'message': str(event.error.message) if event.error else None
                }
            elif event.type == 'image_generation.partial_succeeded':
                if event.error is None:
                    result['url'] = event.url
                    result['size'] = event.size
            elif event.type == 'image_generation.completed':
                if event.error is None:
                    result['usage'] = {
                        'generated_images': event.usage.generated_images if event.usage else 0,
                        'output_tokens': event.usage.output_tokens if event.usage else 0,
                    }
            elif event.type == 'image_generation.partial_image':
                result['partial_index'] = event.partial_image_index
                result['b64_json'] = event.b64_json

            yield result

    def _parse_response(self, response) -> dict:
        """解析响应"""
        result = {
            'model': response.model,
            'created': response.created,
            'images': [],
            'usage': {}
        }

        # 解析图像数据
        for item in response.data:
            img_data = {}
            if hasattr(item, 'url') and item.url:
                img_data['url'] = item.url
            if hasattr(item, 'b64_json') and item.b64_json:
                img_data['b64_json'] = item.b64_json
            if hasattr(item, 'size') and item.size:
                img_data['size'] = item.size
            if hasattr(item, 'error') and item.error:
                img_data['error'] = {
                    'code': str(item.error.code),
                    'message': str(item.error.message)
                }
            result['images'].append(img_data)

        # 解析使用量
        if hasattr(response, 'usage') and response.usage:
            result['usage'] = {
                'generated_images': response.usage.generated_images,
                'output_tokens': response.usage.output_tokens,
                'total_tokens': response.usage.total_tokens,
            }
            if hasattr(response.usage, 'tool_usage') and response.usage.tool_usage:
                result['usage']['web_search_count'] = response.usage.tool_usage.web_search

        return result


def save_image(url: str, output_path: str):
    """从URL下载并保存图片"""
    import urllib.request
    urllib.request.urlretrieve(url, output_path)
    print(f"图片已保存: {output_path}")


def save_b64_image(b64_data: str, output_path: str):
    """保存Base64图片"""
    img_data = base64.b64decode(b64_data)
    with open(output_path, 'wb') as f:
        f.write(img_data)
    print(f"图片已保存: {output_path}")


def main():
    parser = argparse.ArgumentParser(
        description='Seedream 5.0 图像生成器',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
使用示例:
  # 文生图
  python seedream5_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

  # 图生图
  python seedream5_generator.py --prompt "让猫咪戴上墨镜" --image https://example.com/cat.jpg --output ./output

  # 多图融合
  python seedream5_generator.py --prompt "将两张图片融合" --image https://a.jpg https://b.jpg --output ./output

  # 生成组图
  python seedream5_generator.py --prompt "生成四季变化的4张图片" --sequential --max-images 4 --output ./output

  # 启用联网搜索
  python seedream5_generator.py --prompt "生成今日上海天气图" --web-search --output ./output

  # 流式输出
  python seedream5_generator.py --prompt "可爱的猫咪" --stream --output ./output
        """
    )

    # 必需参数
    parser.add_argument('--prompt', '-p', required=True, help='文本提示词')

    # 图像输入
    parser.add_argument('--image', '-i', nargs='+', help='参考图片URL(支持多个)')

    # 输出配置
    parser.add_argument('--output', '-o', default='./output', help='输出目录')
    parser.add_argument('--prefix', default='generated', help='输出文件名前缀')
    parser.add_argument('--format', '-f', choices=['png', 'jpeg'], default='jpeg',
                        help='输出格式 (仅5.0-lite支持)')
    parser.add_argument('--response-format', choices=['url', 'b64_json'], default='url',
                        help='响应格式')

    # 模型配置
    parser.add_argument('--model', '-m', choices=list(Seedream5Generator.MODELS.keys()),
                        default='5.0-lite', help='模型版本')
    parser.add_argument('--size', '-s', default='2K',
                        help='图像尺寸: 2K, 3K 或具体像素如 2048x2048')

    # 组图配置
    parser.add_argument('--sequential', action='store_true', help='生成组图')
    parser.add_argument('--max-images', type=int, default=4, help='组图最大数量(1-15)')

    # 高级功能
    parser.add_argument('--stream', action='store_true', help='流式输出')
    parser.add_argument('--web-search', action='store_true', help='启用联网搜索')
    parser.add_argument('--optimize', choices=['standard', 'fast'], help='提示词优化模式')

    # 其他选项
    parser.add_argument('--watermark', action='store_true', help='添加水印')
    parser.add_argument('--api-key', help='API密钥(也可通过环境变量ARK_API_KEY或config.json设置)')
    parser.add_argument('--config', help='配置文件路径(默认为脚本目录下的config.json)')
    parser.add_argument('--save-json', action='store_true', help='同时保存响应JSON')

    args = parser.parse_args()

    # 创建输出目录
    output_dir = Path(args.output)
    output_dir.mkdir(parents=True, exist_ok=True)

    # 初始化生成器
    try:
        generator = Seedream5Generator(api_key=args.api_key, model=args.model, config_path=args.config)
    except ValueError as e:
        print(f"错误: {e}")
        sys.exit(1)

    print(f"使用模型: {generator.model}")
    print(f"提示词: {args.prompt}")

    # 构建生成参数
    gen_params = {
        'prompt': args.prompt,
        'size': args.size,
        'sequential': args.sequential,
        'max_images': args.max_images,
        'web_search': args.web_search,
        'output_format': args.format,
        'watermark': args.watermark,
        'response_format': args.response_format,
        'optimize_mode': args.optimize,
    }

    # 添加参考图
    if args.image:
        if len(args.image) == 1:
            gen_params['image'] = args.image[0]
        else:
            gen_params['image'] = args.image

    # 生成图像
    if args.stream:
        print("开始流式生成...")
        image_count = 0
        for event in generator.generate_stream(**gen_params):
            if event['type'] == 'image_generation.partial_succeeded' and 'url' in event:
                image_count += 1
                ext = 'png' if args.format == 'png' else 'jpg'
                output_path = output_dir / f"{args.prefix}_{image_count:03d}.{ext}"
                save_image(event['url'], str(output_path))
                print(f"  尺寸: {event.get('size', 'N/A')}")
            elif event['type'] == 'image_generation.completed':
                print(f"生成完成!")
                if 'usage' in event:
                    print(f"  生成图片数: {event['usage'].get('generated_images', 0)}")
            elif event['type'] == 'image_generation.partial_failed':
                print(f"生成失败: {event.get('error')}")
    else:
        print("开始生成...")
        result = generator.generate_sync(**gen_params)

        # 保存图片
        for i, img in enumerate(result.get('images', []), 1):
            ext = 'png' if args.format == 'png' else 'jpg'
            output_path = output_dir / f"{args.prefix}_{i:03d}.{ext}"

            if 'url' in img:
                save_image(img['url'], str(output_path))
            elif 'b64_json' in img:
                save_b64_image(img['b64_json'], str(output_path))

            if 'size' in img:
                print(f"  尺寸: {img['size']}")

        # 输出使用量信息
        usage = result.get('usage', {})
        if usage:
            print(f"\n使用量统计:")
            print(f"  生成图片数: {usage.get('generated_images', 0)}")
            print(f"  输出Token: {usage.get('output_tokens', 0)}")
            if 'web_search_count' in usage:
                print(f"  联网搜索次数: {usage['web_search_count']}")

        # 保存JSON响应
        if args.save_json:
            json_path = output_dir / f"{args.prefix}_response.json"
            with open(json_path, 'w', encoding='utf-8') as f:
                json.dump(result, f, ensure_ascii=False, indent=2)
            print(f"响应已保存: {json_path}")


if __name__ == '__main__':
    main()
