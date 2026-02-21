# -*- coding: utf-8 -*-
"""
火山引擎即梦4.0 AI图像生成服务封装

该模块封装了火山引擎即梦4.0的图像生成API，提供简洁的接口进行文生图、图生图等操作。

使用示例:
    from jimeng4_generator import JiMeng4Generator

    # 方式1: 使用环境变量中的 ak/sk
    # 设置环境变量: VOLC_ACCESSKEY=your_ak, VOLC_SECRETKEY=your_sk
    generator = JiMeng4Generator()

    # 方式2: 直接传入 ak/sk
    generator = JiMeng4Generator(ak="your_ak", sk="your_sk")

    # 文生图
    result = generator.generate(
        prompt="一只可爱的猫咪在花园里玩耍",
        output_dir="./output"
    )

    # 图生图
    result = generator.generate(
        prompt="将背景换成海边",
        image_urls=["https://example.com/image.jpg"],
        output_dir="./output"
    )
"""

import os
import time
import json
import requests
from typing import Optional, List, Dict, Any, Union
from pathlib import Path
from dataclasses import dataclass, field
from enum import Enum

from volcengine.visual.VisualService import VisualService


class TaskStatus(Enum):
    """任务状态枚举"""
    IN_QUEUE = "in_queue"          # 任务已提交
    GENERATING = "generating"      # 任务处理中
    DONE = "done"                  # 处理完成
    NOT_FOUND = "not_found"        # 任务未找到
    EXPIRED = "expired"            # 任务已过期


@dataclass
class LogoInfo:
    """水印配置信息"""
    add_logo: bool = False                 # 是否添加水印
    position: int = 0                       # 水印位置: 0-右下角, 1-左下角, 2-左上角, 3-右上角
    language: int = 0                       # 水印语言: 0-中文, 1-英文
    opacity: float = 1.0                    # 不透明度 0-1
    logo_text_content: str = ""             # 自定义水印内容

    def to_dict(self) -> Dict[str, Any]:
        """转换为字典"""
        result = {
            "add_logo": self.add_logo,
            "position": self.position,
            "language": self.language,
            "opacity": self.opacity
        }
        if self.logo_text_content:
            result["logo_text_content"] = self.logo_text_content
        return result


@dataclass
class AIGCMeta:
    """AIGC隐式标识配置"""
    producer_id: str = ""                   # 内容生成服务商给此图片数据的唯一ID（必选）
    content_producer: str = ""              # 内容生成服务ID
    content_propagator: str = ""            # 内容传播服务商ID
    propagate_id: str = ""                  # 传播服务商给此图片数据的唯一ID

    def to_dict(self) -> Dict[str, Any]:
        """转换为字典"""
        result = {}
        if self.producer_id:
            result["producer_id"] = self.producer_id
        if self.content_producer:
            result["content_producer"] = self.content_producer
        if self.content_propagator:
            result["content_propagator"] = self.content_propagator
        if self.propagate_id:
            result["propagate_id"] = self.propagate_id
        return result


@dataclass
class GenerateResult:
    """生成结果"""
    success: bool                           # 是否成功
    status: TaskStatus                      # 任务状态
    image_paths: List[str] = field(default_factory=list)   # 本地保存的图片路径
    image_urls: List[str] = field(default_factory=list)    # 图片URL列表
    task_id: str = ""                       # 任务ID
    message: str = ""                       # 消息
    error_code: int = 0                     # 错误码
    request_id: str = ""                    # 请求ID


# 环境变量名称
ENV_ACCESS_KEY = "VOLC_ACCESSKEY"
ENV_SECRET_KEY = "VOLC_SECRETKEY"

# 默认配置文件路径
DEFAULT_CONFIG_FILE = "config.json"


def _load_config_from_file(config_path: Optional[str] = None) -> Dict[str, str]:
    """
    从配置文件加载 ak/sk 配置

    Args:
        config_path: 配置文件路径，未指定时使用默认路径

    Returns:
        包含 ak/sk 的字典
    """
    config = {}

    # 确定配置文件路径
    if config_path:
        file_path = Path(config_path)
    else:
        # 默认在与本脚本同目录下查找 config.json
        file_path = Path(__file__).parent / DEFAULT_CONFIG_FILE

    if file_path.exists():
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                if "ak" in data:
                    config["ak"] = data["ak"]
                if "sk" in data:
                    config["sk"] = data["sk"]
        except (json.JSONDecodeError, IOError) as e:
            print(f"警告: 读取配置文件 {file_path} 失败: {e}")

    return config


class JiMeng4Generator:
    """
    即梦4.0图像生成器

    封装火山引擎即梦4.0的图像生成API，支持文生图、图生图等功能。

    Attributes:
        ak: 火山引擎Access Key（未传入时从环境变量VOLC_ACCESSKEY获取）
        sk: 火山引擎Secret Key（未传入时从环境变量VOLC_SECRETKEY获取）
        req_key: 服务标识，默认为jimeng_t2i_v40
        max_retry: 最大重试次数
        retry_interval: 重试间隔（秒）
    """

    # 服务标识
    REQ_KEY = "jimeng_t2i_v40"

    # 默认分辨率配置
    RESOLUTION_1K = (1024, 1024)
    RESOLUTION_2K = (2048, 2048)
    RESOLUTION_4K = (4096, 4096)

    # 推荐分辨率列表
    RECOMMENDED_RESOLUTIONS = {
        "1K": [(1024, 1024)],  # 1:1
        "2K": [
            (2048, 2048),   # 1:1
            (2304, 1728),   # 4:3
            (2496, 1664),   # 3:2
            (2560, 1440),   # 16:9
            (3024, 1296),   # 21:9
        ],
        "4K": [
            (4096, 4096),   # 1:1
            (4694, 3520),   # 4:3
            (4992, 3328),   # 3:2
            (5404, 3040),   # 16:9
            (6198, 2656),   # 21:9
        ]
    }

    def __init__(
        self,
        ak: Optional[str] = None,
        sk: Optional[str] = None,
        max_retry: int = 30,
        retry_interval: float = 3.0,
        config_path: Optional[str] = None
    ):
        """
        初始化生成器

        Args:
            ak: 火山引擎Access Key，优先级: 参数 > 环境变量 > config.json
            sk: 火山引擎Secret Key，优先级: 参数 > 环境变量 > config.json
            max_retry: 查询结果最大重试次数，默认30次
            retry_interval: 查询结果重试间隔（秒），默认3秒
            config_path: 配置文件路径，未指定时使用默认路径 config.json

        Raises:
            ValueError: 当ak或sk未提供且环境变量和配置文件中都未设置时
        """
        # 从参数或环境变量获取 ak/sk
        self.ak = ak or os.environ.get(ENV_ACCESS_KEY)
        self.sk = sk or os.environ.get(ENV_SECRET_KEY)

        # 如果环境变量未设置，尝试从配置文件读取
        if not self.ak or not self.sk:
            config = _load_config_from_file(config_path)
            if not self.ak and "ak" in config:
                self.ak = config["ak"]
            if not self.sk and "sk" in config:
                self.sk = config["sk"]

        if not self.ak:
            raise ValueError(
                f"未提供Access Key，请通过以下方式之一提供:\n"
                f"  1. 参数 ak='your_ak'\n"
                f"  2. 环境变量 {ENV_ACCESS_KEY}\n"
                f"  3. 配置文件 config.json"
            )
        if not self.sk:
            raise ValueError(
                f"未提供Secret Key，请通过以下方式之一提供:\n"
                f"  1. 参数 sk='your_sk'\n"
                f"  2. 环境变量 {ENV_SECRET_KEY}\n"
                f"  3. 配置文件 config.json"
            )

        self.max_retry = max_retry
        self.retry_interval = retry_interval

        # 初始化视觉服务
        self._visual_service = VisualService()
        self._visual_service.set_ak(self.ak)
        self._visual_service.set_sk(self.sk)

    def generate(
        self,
        prompt: str,
        image_urls: Optional[List[str]] = None,
        output_dir: Optional[str] = None,
        width: Optional[int] = None,
        height: Optional[int] = None,
        size: Optional[int] = None,
        scale: float = 0.5,
        force_single: bool = False,
        min_ratio: float = 1/3,
        max_ratio: float = 3.0,
        logo_info: Optional[LogoInfo] = None,
        aigc_meta: Optional[AIGCMeta] = None,
        return_url: bool = True,
        save_images: bool = True,
        filename_prefix: str = "jimeng4"
    ) -> GenerateResult:
        """
        生成图像

        Args:
            prompt: 提示词，中英文均可，最长800字符
            image_urls: 参考图片URL列表，0-10张，用于图生图场景
            output_dir: 输出目录，默认为当前工作目录
            width: 生成图片宽度，需与height同时传入
            height: 生成图片高度，需与width同时传入
            size: 生成图片面积，默认4194304(2048*2048)，范围[1024*1024, 4096*4096]
            scale: 文本描述影响程度，范围[0, 1]，默认0.5
            force_single: 是否强制生成单图，默认False
            min_ratio: 生成图宽/高最小比例，默认1/3
            max_ratio: 生成图宽/高最大比例，默认3
            logo_info: 水印配置
            aigc_meta: AIGC隐式标识配置
            return_url: 是否返回图片URL，默认True
            save_images: 是否保存图片到本地，默认True
            filename_prefix: 保存文件名前缀，默认"jimeng4"

        Returns:
            GenerateResult: 生成结果对象
        """
        # 设置输出目录
        if output_dir:
            output_path = Path(output_dir)
            output_path.mkdir(parents=True, exist_ok=True)
        else:
            output_path = Path.cwd()

        # 构建请求参数
        form = {
            "req_key": self.REQ_KEY,
            "prompt": prompt,
            "scale": scale,
            "force_single": force_single,
            "min_ratio": min_ratio,
            "max_ratio": max_ratio,
            "return_url": return_url
        }

        # 添加图片URL（图生图场景）
        if image_urls:
            form["image_urls"] = image_urls

        # 添加分辨率参数
        if width and height:
            form["width"] = width
            form["height"] = height
        elif size:
            form["size"] = size

        # 提交任务
        submit_result = self._submit_task(form)

        if not submit_result.get("success", False):
            return GenerateResult(
                success=False,
                status=TaskStatus.NOT_FOUND,
                message=submit_result.get("message", "提交任务失败"),
                error_code=submit_result.get("code", 0),
                request_id=submit_result.get("request_id", "")
            )

        task_id = submit_result.get("task_id", "")
        print(f"任务已提交，task_id: {task_id}")

        # 构建查询参数
        query_form = {
            "req_key": self.REQ_KEY,
            "task_id": task_id,
            "return_url": return_url
        }

        # 添加水印和AIGC配置
        req_json = {}
        if logo_info:
            req_json["logo_info"] = logo_info.to_dict()
        if aigc_meta:
            req_json["aigc_meta"] = aigc_meta.to_dict()
        req_json["return_url"] = return_url

        if req_json:
            query_form["req_json"] = json.dumps(req_json)

        # 轮询查询结果
        result = self._poll_result(query_form)

        if not result.success:
            return result

        # 保存图片
        if save_images and result.image_urls:
            saved_paths = self._save_images(
                result.image_urls,
                output_path,
                filename_prefix
            )
            result.image_paths = saved_paths

        return result

    def generate_text2image(
        self,
        prompt: str,
        output_dir: Optional[str] = None,
        resolution: str = "2K",
        **kwargs
    ) -> GenerateResult:
        """
        文生图快捷方法

        Args:
            prompt: 提示词
            output_dir: 输出目录
            resolution: 分辨率，可选"1K", "2K", "4K"，默认"2K"
            **kwargs: 其他参数，传递给generate方法

        Returns:
            GenerateResult: 生成结果
        """
        # 根据分辨率设置size
        resolution_sizes = {
            "1K": 1024 * 1024,
            "2K": 2048 * 2048,
            "4K": 4096 * 4096
        }
        size = resolution_sizes.get(resolution.upper(), 2048 * 2048)

        return self.generate(
            prompt=prompt,
            output_dir=output_dir,
            size=size,
            **kwargs
        )

    def generate_image2image(
        self,
        prompt: str,
        image_urls: List[str],
        output_dir: Optional[str] = None,
        **kwargs
    ) -> GenerateResult:
        """
        图生图快捷方法

        Args:
            prompt: 提示词，描述如何修改图片
            image_urls: 参考图片URL列表
            output_dir: 输出目录
            **kwargs: 其他参数

        Returns:
            GenerateResult: 生成结果
        """
        return self.generate(
            prompt=prompt,
            image_urls=image_urls,
            output_dir=output_dir,
            **kwargs
        )

    def _submit_task(self, form: Dict[str, Any]) -> Dict[str, Any]:
        """
        提交生成任务

        Args:
            form: 请求参数

        Returns:
            提交结果
        """
        try:
            resp = self._visual_service.cv_sync2async_submit_task(form)

            if resp.get("code") == 10000:
                return {
                    "success": True,
                    "task_id": resp.get("data", {}).get("task_id", ""),
                    "request_id": resp.get("request_id", "")
                }
            else:
                return {
                    "success": False,
                    "code": resp.get("code", 0),
                    "message": resp.get("message", "未知错误"),
                    "request_id": resp.get("request_id", "")
                }
        except Exception as e:
            return {
                "success": False,
                "code": -1,
                "message": str(e)
            }

    def _poll_result(self, form: Dict[str, Any]) -> GenerateResult:
        """
        轮询查询结果

        Args:
            form: 查询参数

        Returns:
            GenerateResult: 生成结果
        """
        for i in range(self.max_retry):
            try:
                resp = self._visual_service.cv_sync2async_get_result(form)

                code = resp.get("code", 0)
                data = resp.get("data", {})
                status_str = data.get("status", "") if data else ""
                message = resp.get("message", "")

                # 检查外层code
                if code != 10000:
                    return GenerateResult(
                        success=False,
                        status=TaskStatus.NOT_FOUND,
                        message=message,
                        error_code=code,
                        request_id=resp.get("request_id", "")
                    )

                # 解析状态
                try:
                    status = TaskStatus(status_str)
                except ValueError:
                    status = TaskStatus.NOT_FOUND

                # 根据状态处理
                if status == TaskStatus.DONE:
                    image_urls = data.get("image_urls", [])
                    return GenerateResult(
                        success=True,
                        status=status,
                        image_urls=image_urls,
                        task_id=form.get("task_id", ""),
                        message="生成成功",
                        request_id=resp.get("request_id", "")
                    )
                elif status in [TaskStatus.NOT_FOUND, TaskStatus.EXPIRED]:
                    return GenerateResult(
                        success=False,
                        status=status,
                        message=f"任务{status_str}",
                        request_id=resp.get("request_id", "")
                    )
                else:
                    # in_queue 或 generating
                    print(f"任务状态: {status_str}，等待中... ({i+1}/{self.max_retry})")
                    time.sleep(self.retry_interval)

            except Exception as e:
                print(f"查询异常: {str(e)}，重试中... ({i+1}/{self.max_retry})")
                time.sleep(self.retry_interval)

        return GenerateResult(
            success=False,
            status=TaskStatus.NOT_FOUND,
            message=f"超过最大重试次数({self.max_retry})",
            task_id=form.get("task_id", "")
        )

    def _save_images(
        self,
        image_urls: List[str],
        output_path: Path,
        filename_prefix: str
    ) -> List[str]:
        """
        保存图片到本地

        Args:
            image_urls: 图片URL列表
            output_path: 输出路径
            filename_prefix: 文件名前缀

        Returns:
            保存的文件路径列表
        """
        saved_paths = []
        timestamp = time.strftime("%Y%m%d_%H%M%S")

        for i, url in enumerate(image_urls):
            try:
                response = requests.get(url, timeout=60)
                response.raise_for_status()

                # 生成文件名
                filename = f"{filename_prefix}_{timestamp}_{i+1}.png"
                filepath = output_path / filename

                # 保存文件
                with open(filepath, "wb") as f:
                    f.write(response.content)

                saved_paths.append(str(filepath))
                print(f"图片已保存: {filepath}")

            except Exception as e:
                print(f"保存图片失败: {url}, 错误: {str(e)}")

        return saved_paths


def main():
    """
    命令行入口函数
    """
    import argparse

    parser = argparse.ArgumentParser(
        description="火山引擎即梦4.0 AI图像生成工具",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例用法:
  # 文生图（使用环境变量或config.json中的ak/sk）
  python jimeng4_generator.py --prompt "一只可爱的猫咪" --output ./output

  # 图生图
  python jimeng4_generator.py --prompt "换成海边背景" --images https://xxx.jpg --output ./output

  # 指定分辨率
  python jimeng4_generator.py --prompt "美丽风景" --width 2048 --height 1440

  # 显式指定ak/sk（优先级最高）
  python jimeng4_generator.py --ak your_ak --sk your_sk --prompt "一只可爱的猫咪"

  # 指定配置文件路径
  python jimeng4_generator.py --config /path/to/config.json --prompt "一只可爱的猫咪"

配置优先级:
  1. 命令行参数 --ak/--sk
  2. 环境变量 VOLC_ACCESSKEY/VOLC_SECRETKEY
  3. 配置文件 config.json

环境变量:
  VOLC_ACCESSKEY: 火山引擎Access Key
  VOLC_SECRETKEY: 火山引擎Secret Key

配置文件格式 (config.json):
  {
    "ak": "your_access_key",
    "sk": "your_secret_key"
  }
        """
    )

    # ak/sk 改为可选参数，未提供时从环境变量或配置文件获取
    parser.add_argument("--ak", default=None, help="火山引擎Access Key（优先级: 参数 > 环境变量 > config.json）")
    parser.add_argument("--sk", default=None, help="火山引擎Secret Key（优先级: 参数 > 环境变量 > config.json）")
    parser.add_argument("--config", default=None, help="配置文件路径，默认为脚本目录下的 config.json")
    parser.add_argument("--prompt", required=True, help="生成提示词")

    # 可选参数
    parser.add_argument("--output", "-o", default=None, help="输出目录，默认当前目录")
    parser.add_argument("--images", nargs="+", help="参考图片URL列表（图生图）")
    parser.add_argument("--width", type=int, help="生成图片宽度")
    parser.add_argument("--height", type=int, help="生成图片高度")
    parser.add_argument("--size", type=int, default=2048*2048, help="生成图片面积，默认2048*2048")
    parser.add_argument("--scale", type=float, default=0.5, help="文本影响程度，范围[0,1]，默认0.5")
    parser.add_argument("--force-single", action="store_true", help="强制生成单图")
    parser.add_argument("--min-ratio", type=float, default=1/3, help="最小宽高比")
    parser.add_argument("--max-ratio", type=float, default=3.0, help="最大宽高比")
    parser.add_argument("--prefix", default="jimeng4", help="输出文件名前缀")
    parser.add_argument("--no-save", action="store_true", help="不保存图片到本地")
    parser.add_argument("--max-retry", type=int, default=30, help="最大重试次数")
    parser.add_argument("--retry-interval", type=float, default=3.0, help="重试间隔(秒)")

    # 水印参数
    parser.add_argument("--add-logo", action="store_true", help="添加水印")
    parser.add_argument("--logo-position", type=int, default=0, help="水印位置: 0-右下, 1-左下, 2-左上, 3-右上")
    parser.add_argument("--logo-language", type=int, default=0, help="水印语言: 0-中文, 1-英文")
    parser.add_argument("--logo-opacity", type=float, default=1.0, help="水印透明度")
    parser.add_argument("--logo-text", default="", help="自定义水印内容")

    args = parser.parse_args()

    # 创建生成器（ak/sk 未提供时从环境变量或配置文件获取）
    try:
        generator = JiMeng4Generator(
            ak=args.ak,
            sk=args.sk,
            max_retry=args.max_retry,
            retry_interval=args.retry_interval,
            config_path=args.config
        )
    except ValueError as e:
        print(f"错误: {e}")
        return 1

    # 配置水印
    logo_info = None
    if args.add_logo:
        logo_info = LogoInfo(
            add_logo=True,
            position=args.logo_position,
            language=args.logo_language,
            opacity=args.logo_opacity,
            logo_text_content=args.logo_text
        )

    # 生成图像
    result = generator.generate(
        prompt=args.prompt,
        image_urls=args.images,
        output_dir=args.output,
        width=args.width,
        height=args.height,
        size=args.size,
        scale=args.scale,
        force_single=args.force_single,
        min_ratio=args.min_ratio,
        max_ratio=args.max_ratio,
        logo_info=logo_info,
        save_images=not args.no_save,
        filename_prefix=args.prefix
    )

    # 输出结果
    if result.success:
        print(f"\n生成成功!")
        print(f"任务ID: {result.task_id}")
        print(f"图片数量: {len(result.image_urls)}")
        if result.image_paths:
            print(f"保存路径:")
            for path in result.image_paths:
                print(f"  - {path}")
    else:
        print(f"\n生成失败!")
        print(f"错误码: {result.error_code}")
        print(f"错误信息: {result.message}")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())
