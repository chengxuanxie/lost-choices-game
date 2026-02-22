# -*- coding: utf-8 -*-
"""
火山引擎即梦AI视频生成3.0 Pro服务封装

该模块封装了火山引擎即梦视频生成3.0 Pro的API，提供简洁的接口进行文生视频、图生视频等操作。

使用示例:
    from jimeng_video_generator import JiMengVideoGenerator

    # 方式1: 使用环境变量中的 ak/sk
    # 设置环境变量: VOLC_ACCESSKEY=your_ak, VOLC_SECRETKEY=your_sk
    generator = JiMengVideoGenerator()

    # 方式2: 直接传入 ak/sk
    generator = JiMengVideoGenerator(ak="your_ak", sk="your_sk")

    # 文生视频
    result = generator.generate_text2video(
        prompt="一只可爱的猫咪在花园里玩耍",
        output_dir="./output"
    )

    # 图生视频（单图）
    result = generator.generate_image2video(
        prompt="让猫咪眨眼",
        image_url="https://example.com/cat.jpg",
        output_dir="./output"
    )

    # 图生视频（多图）
    result = generator.generate_image2video(
        prompt="让这些人物一起跳舞",
        image_urls=["https://example.com/person1.jpg", "https://example.com/person2.jpg"],
        output_dir="./output"
    )
"""

import os
import time
import json
import requests
from typing import Optional, List, Dict, Any
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
class VideoResult:
    """视频生成结果"""
    success: bool                           # 是否成功
    status: TaskStatus                      # 任务状态
    video_paths: List[str] = field(default_factory=list)   # 本地保存的视频路径
    video_urls: List[str] = field(default_factory=list)    # 视频URL列表
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


class JiMengVideoGenerator:
    """
    即梦AI视频生成3.0 Pro生成器

    封装火山引擎即梦视频生成3.0 Pro的API，支持文生视频、图生视频等功能。

    Attributes:
        ak: 火山引擎Access Key（未传入时从环境变量VOLC_ACCESSKEY获取）
        sk: 火山引擎Secret Key（未传入时从环境变量VOLC_SECRETKEY获取）
        max_retry: 最大重试次数
        retry_interval: 重试间隔（秒）
    """

    # 服务标识 - 文生视频
    REQ_KEY_T2V = "jimeng_ti2v_v30_pro"
    # 服务标识 - 图生视频
    REQ_KEY_I2V = "jimeng_ti2v_v30_pro"

    def __init__(
        self,
        ak: Optional[str] = None,
        sk: Optional[str] = None,
        max_retry: int = 120,
        retry_interval: float = 5.0,
        config_path: Optional[str] = None
    ):
        """
        初始化生成器

        Args:
            ak: 火山引擎Access Key，优先级: 参数 > 环境变量 > config.json
            sk: 火山引擎Secret Key，优先级: 参数 > 环境变量 > config.json
            max_retry: 查询结果最大重试次数，默认120次（视频生成耗时较长）
            retry_interval: 查询结果重试间隔（秒），默认5秒
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
        image_url: Optional[str] = None,
        image_urls: Optional[List[str]] = None,
        output_dir: Optional[str] = None,
        seed: Optional[int] = None,
        save_video: bool = True,
        filename_prefix: str = "jimeng_video"
    ) -> VideoResult:
        """
        生成视频（支持文生视频和图生视频）

        Args:
            prompt: 提示词，描述视频内容
            image_url: 单张参考图片URL（图生视频场景），与image_urls二选一
            image_urls: 多张参考图片URL列表（图生视频场景），与image_url二选一，最多支持4张
            output_dir: 输出目录，默认为当前工作目录
            seed: 随机种子，用于复现结果
            save_video: 是否保存视频到本地，默认True
            filename_prefix: 保存文件名前缀，默认"jimeng_video"

        Returns:
            VideoResult: 生成结果对象
        """
        # 设置输出目录
        if output_dir:
            output_path = Path(output_dir)
            output_path.mkdir(parents=True, exist_ok=True)
        else:
            output_path = Path.cwd()

        # 处理图片URL参数
        final_image_urls = []
        if image_urls:
            final_image_urls = image_urls
        elif image_url:
            final_image_urls = [image_url]

        # 根据是否传入图片URL决定使用文生视频还是图生视频
        req_key = self.REQ_KEY_I2V if final_image_urls else self.REQ_KEY_T2V
        mode = "图生视频" if final_image_urls else "文生视频"
        image_count = len(final_image_urls) if final_image_urls else 0

        # 构建请求参数
        form = {
            "req_key": req_key,
            "prompt": prompt,
        }

        # 添加图片URL（图生视频场景）
        if final_image_urls:
            form["image_urls"] = final_image_urls

        # 添加随机种子
        if seed is not None:
            form["seed"] = seed

        # 提交任务
        submit_result = self._submit_task(form)

        if not submit_result.get("success", False):
            return VideoResult(
                success=False,
                status=TaskStatus.NOT_FOUND,
                message=submit_result.get("message", "提交任务失败"),
                error_code=submit_result.get("code", 0),
                request_id=submit_result.get("request_id", "")
            )

        task_id = submit_result.get("task_id", "")
        if image_count > 0:
            print(f"[{mode}] 任务已提交（{image_count}张参考图），task_id: {task_id}")
        else:
            print(f"[{mode}] 任务已提交，task_id: {task_id}")

        # 构建查询参数
        query_form = {
            "req_key": req_key,
            "task_id": task_id
        }

        # 轮询查询结果
        result = self._poll_result(query_form, mode)

        if not result.success:
            return result

        # 保存视频
        if save_video and result.video_urls:
            saved_paths = self._save_videos(
                result.video_urls,
                output_path,
                filename_prefix
            )
            result.video_paths = saved_paths

        return result

    def generate_text2video(
        self,
        prompt: str,
        output_dir: Optional[str] = None,
        seed: Optional[int] = None,
        **kwargs
    ) -> VideoResult:
        """
        文生视频快捷方法

        Args:
            prompt: 提示词，描述视频内容
            output_dir: 输出目录
            seed: 随机种子
            **kwargs: 其他参数，传递给generate方法

        Returns:
            VideoResult: 生成结果
        """
        return self.generate(
            prompt=prompt,
            output_dir=output_dir,
            seed=seed,
            **kwargs
        )

    def generate_image2video(
        self,
        prompt: str,
        image_url: Optional[str] = None,
        image_urls: Optional[List[str]] = None,
        output_dir: Optional[str] = None,
        seed: Optional[int] = None,
        **kwargs
    ) -> VideoResult:
        """
        图生视频快捷方法

        Args:
            prompt: 提示词，描述视频动态效果
            image_url: 单张参考图片URL，与image_urls二选一
            image_urls: 多张参考图片URL列表，与image_url二选一，最多支持4张
            output_dir: 输出目录
            seed: 随机种子
            **kwargs: 其他参数

        Returns:
            VideoResult: 生成结果
        """
        return self.generate(
            prompt=prompt,
            image_url=image_url,
            image_urls=image_urls,
            output_dir=output_dir,
            seed=seed,
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

    def _poll_result(self, form: Dict[str, Any], mode: str = "视频生成") -> VideoResult:
        """
        轮询查询结果

        Args:
            form: 查询参数
            mode: 生成模式描述

        Returns:
            VideoResult: 生成结果
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
                    return VideoResult(
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
                    # 尝试多种可能的字段名
                    video_urls = data.get("video_urls", [])
                    if not video_urls:
                        video_url = data.get("video_url", "")
                        if video_url:
                            video_urls = [video_url]
                    if not video_urls:
                        video_urls = data.get("videos", [])
                    if not video_urls:
                        video_urls = data.get("video_list", [])
                    if not video_urls:
                        video_urls = data.get("results", [])
                    return VideoResult(
                        success=True,
                        status=status,
                        video_urls=video_urls,
                        task_id=form.get("task_id", ""),
                        message="生成成功",
                        request_id=resp.get("request_id", "")
                    )
                elif status in [TaskStatus.NOT_FOUND, TaskStatus.EXPIRED]:
                    return VideoResult(
                        success=False,
                        status=status,
                        message=f"任务{status_str}",
                        request_id=resp.get("request_id", "")
                    )
                else:
                    # in_queue 或 generating
                    elapsed_time = (i + 1) * self.retry_interval
                    print(f"[{mode}] 任务状态: {status_str}，已等待 {elapsed_time:.0f} 秒... ({i+1}/{self.max_retry})")
                    time.sleep(self.retry_interval)

            except Exception as e:
                print(f"[{mode}] 查询异常: {str(e)}，重试中... ({i+1}/{self.max_retry})")
                time.sleep(self.retry_interval)

        return VideoResult(
            success=False,
            status=TaskStatus.NOT_FOUND,
            message=f"超过最大重试次数({self.max_retry})，总等待时间超过 {self.max_retry * self.retry_interval:.0f} 秒",
            task_id=form.get("task_id", "")
        )

    def _save_videos(
        self,
        video_urls: List[str],
        output_path: Path,
        filename_prefix: str
    ) -> List[str]:
        """
        保存视频到本地

        Args:
            video_urls: 视频URL列表
            output_path: 输出路径
            filename_prefix: 文件名前缀

        Returns:
            保存的文件路径列表
        """
        saved_paths = []
        timestamp = time.strftime("%Y%m%d_%H%M%S")

        for i, url in enumerate(video_urls):
            try:
                response = requests.get(url, timeout=300, stream=True)
                response.raise_for_status()

                # 生成文件名
                filename = f"{filename_prefix}_{timestamp}_{i+1}.mp4"
                filepath = output_path / filename

                # 保存文件
                with open(filepath, "wb") as f:
                    for chunk in response.iter_content(chunk_size=8192):
                        f.write(chunk)

                saved_paths.append(str(filepath))
                print(f"视频已保存: {filepath}")

            except Exception as e:
                print(f"保存视频失败: {url}, 错误: {str(e)}")

        return saved_paths


def main():
    """
    命令行入口函数
    """
    import argparse

    parser = argparse.ArgumentParser(
        description="火山引擎即梦AI视频生成3.0 Pro工具",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例用法:
  # 文生视频（使用环境变量或config.json中的ak/sk）
  python jimeng_video_generator.py --prompt "一只可爱的猫咪在花园里玩耍" --output ./output

  # 图生视频（单图）
  python jimeng_video_generator.py --prompt "让猫咪眨眼" --image https://xxx.jpg --output ./output

  # 图生视频（多图，最多4张）
  python jimeng_video_generator.py --prompt "让这些人一起跳舞" --images https://xxx1.jpg https://xxx2.jpg --output ./output

  # 指定随机种子（用于复现结果）
  python jimeng_video_generator.py --prompt "夕阳下的海滩" --seed 12345 --output ./output

  # 显式指定ak/sk（优先级最高）
  python jimeng_video_generator.py --ak your_ak --sk your_sk --prompt "城市夜景" --output ./output

  # 指定配置文件路径
  python jimeng_video_generator.py --config /path/to/config.json --prompt "森林中的小鹿" --output ./output

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

注意:
  - 视频生成耗时较长，通常需要1-10分钟，请耐心等待
  - 默认最大等待时间为10分钟（120次重试 x 5秒），可通过 --max-retry 和 --retry-interval 调整
  - 图生视频支持单图(--image)或多图(--images)，多图最多4张
        """
    )

    # ak/sk 改为可选参数，未提供时从环境变量或配置文件获取
    parser.add_argument("--ak", default=None, help="火山引擎Access Key（优先级: 参数 > 环境变量 > config.json）")
    parser.add_argument("--sk", default=None, help="火山引擎Secret Key（优先级: 参数 > 环境变量 > config.json）")
    parser.add_argument("--config", default=None, help="配置文件路径，默认为脚本目录下的 config.json")
    parser.add_argument("--prompt", required=True, help="生成提示词，描述视频内容")

    # 可选参数
    parser.add_argument("--image", "-i", default=None, help="单张参考图片URL（图生视频模式）")
    parser.add_argument("--images", nargs="+", default=None, help="多张参考图片URL列表（图生视频模式，最多4张）")
    parser.add_argument("--output", "-o", default=None, help="输出目录，默认当前目录")
    parser.add_argument("--seed", type=int, default=None, help="随机种子，用于复现结果")
    parser.add_argument("--prefix", default="jimeng_video", help="输出文件名前缀")
    parser.add_argument("--no-save", action="store_true", help="不保存视频到本地")
    parser.add_argument("--max-retry", type=int, default=120, help="最大重试次数，默认120")
    parser.add_argument("--retry-interval", type=float, default=5.0, help="重试间隔(秒)，默认5.0")

    args = parser.parse_args()

    # 创建生成器（ak/sk 未提供时从环境变量或配置文件获取）
    try:
        generator = JiMengVideoGenerator(
            ak=args.ak,
            sk=args.sk,
            max_retry=args.max_retry,
            retry_interval=args.retry_interval,
            config_path=args.config
        )
    except ValueError as e:
        print(f"错误: {e}")
        return 1

    # 判断生成模式和图片参数
    has_images = args.image or args.images
    mode = "图生视频" if has_images else "文生视频"
    image_count = 0
    if args.images:
        image_count = len(args.images)
    elif args.image:
        image_count = 1

    print(f"生成模式: {mode}")
    print(f"提示词: {args.prompt}")
    if has_images:
        print(f"参考图片数量: {image_count}")
        if args.images:
            for i, img in enumerate(args.images):
                print(f"  图片{i+1}: {img}")
        elif args.image:
            print(f"  图片: {args.image}")

    # 生成视频
    result = generator.generate(
        prompt=args.prompt,
        image_url=args.image,
        image_urls=args.images,
        output_dir=args.output,
        seed=args.seed,
        save_video=not args.no_save,
        filename_prefix=args.prefix
    )

    # 输出结果
    if result.success:
        print(f"\n生成成功!")
        print(f"任务ID: {result.task_id}")
        print(f"视频数量: {len(result.video_urls)}")
        if result.video_urls:
            print(f"视频URL:")
            for url in result.video_urls:
                print(f"  - {url}")
        if result.video_paths:
            print(f"保存路径:")
            for path in result.video_paths:
                print(f"  - {path}")
    else:
        print(f"\n生成失败!")
        print(f"错误码: {result.error_code}")
        print(f"错误信息: {result.message}")
        return 1

    return 0


if __name__ == "__main__":
    exit(main())
