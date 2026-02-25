# -*- coding: utf-8 -*-
"""
动态漫生成器 - Motion Comic Generator

将关键帧图片和对话脚本合成为带语音的视频。

功能：
- Edge-TTS: 文字转语音
- FFmpeg: 图片+音频合成视频、视频拼接

使用示例:
    # 生成配音
    python motion_comic_generator.py tts --text "你好世界" --output ./output/voice.mp3

    # 从配置文件生成完整动态漫
    python motion_comic_generator.py generate --config ./story.json --output ./output/comic.mp4

    # 从命令行参数生成
    python motion_comic_generator.py generate \\
        --frames ./frame1.png ./frame2.png \\
        --texts "第一句台词" "第二句台词" \\
        --output ./output/comic.mp4

    # 查看可用音色
    python motion_comic_generator.py list-voices --language zh-CN
"""

import os
import sys
import json
import asyncio
import subprocess
import argparse
import tempfile
import time
from pathlib import Path
from typing import Optional, List, Dict
from dataclasses import dataclass


# 默认配置
DEFAULT_CONFIG = {
    "output_dir": "./output",
    "default_voice": "zh-CN-XiaoxiaoNeural",
    "fps": 24,
    "resolution": "720p",
    "max_retries": 3,  # TTS最大重试次数
    "retry_delay": 1.0  # 重试初始延迟（秒）
}

# 备用音色映射（当主音色失败时使用）
FALLBACK_VOICES = {
    "zh-CN-XiaoxiaoNeural": ["zh-CN-XiaoyiNeural", "zh-CN-XiaochenNeural"],
    "zh-CN-XiaoyiNeural": ["zh-CN-XiaoxiaoNeural", "zh-CN-XiaochenNeural"],
    "zh-CN-YunxiNeural": ["zh-CN-YunjianNeural", "zh-CN-YunfengNeural"],
    "zh-CN-YunjianNeural": ["zh-CN-YunxiNeural", "zh-CN-YunfengNeural"],
    "zh-CN-YunfengNeural": ["zh-CN-YunjianNeural", "zh-CN-YunxiNeural"],
}

# 常用音色列表
POPULAR_VOICES = {
    "zh-CN": {
        "female": ["zh-CN-XiaoxiaoNeural", "zh-CN-XiaoyiNeural", "zh-CN-XiaochenNeural"],
        "male": ["zh-CN-YunxiNeural", "zh-CN-YunjianNeural", "zh-CN-YunfengNeural"]
    },
    "en-US": {
        "female": ["en-US-JennyNeural", "en-US-AnaNeural"],
        "male": ["en-US-GuyNeural", "en-US-ChristopherNeural"]
    },
    "en-GB": {
        "female": ["en-GB-SoniaNeural", "en-GB-MiaNeural"],
        "male": ["en-GB-RyanNeural", "en-GB-ThomasNeural"]
    },
    "ja-JP": {
        "female": ["ja-JP-NanamiNeural", "ja-JP-AoiNeural"],
        "male": ["ja-JP-KeitaNeural", "ja-JP-DaichiNeural"]
    }
}


@dataclass
class Scene:
    """场景数据类"""
    frame: str                    # 关键帧图片路径
    text: str                     # 台词文本
    voice: str = "zh-CN-XiaoxiaoNeural"  # 音色
    duration: float = 0           # 持续时间（0表示自动根据音频）
    audio: Optional[str] = None   # 预置音频路径（可选）


@dataclass
class GenerateResult:
    """生成结果"""
    success: bool
    output_path: str = ""
    message: str = ""
    scenes_generated: int = 0


class TTSGenerator:
    """Edge-TTS 语音生成器（带重试和备用音色机制）"""

    def __init__(self, max_retries: int = 3, retry_delay: float = 1.0):
        self._check_edge_tts()
        self.max_retries = max_retries
        self.retry_delay = retry_delay

    def _check_edge_tts(self):
        """检查 edge-tts 是否安装"""
        try:
            import edge_tts
        except ImportError:
            print("正在安装 edge-tts...")
            subprocess.run([sys.executable, "-m", "pip", "install", "edge-tts"],
                         check=True, capture_output=True)
            import edge_tts

    async def generate_async(
        self,
        text: str,
        output_path: str,
        voice: str = "zh-CN-XiaoxiaoNeural",
        rate: str = "+0%",
        volume: str = "+0%"
    ) -> bool:
        """
        异步生成语音

        Args:
            text: 要转换的文本
            output_path: 输出文件路径
            voice: 音色名称
            rate: 语速调节 (-50% to +100%)
            volume: 音量调节 (-50% to +100%)

        Returns:
            是否成功
        """
        import edge_tts

        try:
            communicate = edge_tts.Communicate(
                text=text,
                voice=voice,
                rate=rate,
                volume=volume
            )

            Path(output_path).parent.mkdir(parents=True, exist_ok=True)
            await communicate.save(output_path)

            # 验证文件是否生成且非空
            if Path(output_path).exists() and Path(output_path).stat().st_size > 0:
                return True
            else:
                print("TTS生成失败: 音频文件为空")
                return False
        except Exception as e:
            print(f"TTS生成失败: {e}")
            return False

    def generate_with_retry(
        self,
        text: str,
        output_path: str,
        voice: str = "zh-CN-XiaoxiaoNeural",
        rate: str = "+0%",
        volume: str = "+0%"
    ) -> bool:
        """
        带重试机制的语音生成

        当主音色失败时，会尝试备用音色。

        Args:
            text: 要转换的文本
            output_path: 输出文件路径
            voice: 音色名称
            rate: 语速调节
            volume: 音量调节

        Returns:
            是否成功
        """
        # 收集所有要尝试的音色
        voices_to_try = [voice]
        if voice in FALLBACK_VOICES:
            voices_to_try.extend(FALLBACK_VOICES[voice])

        for current_voice in voices_to_try:
            for attempt in range(self.max_retries):
                if attempt > 0:
                    # 指数退避
                    delay = self.retry_delay * (2 ** (attempt - 1))
                    print(f"  重试 {attempt}/{self.max_retries}，等待 {delay:.1f} 秒...")
                    time.sleep(delay)

                if current_voice != voice:
                    print(f"  尝试备用音色: {current_voice}")

                success = asyncio.run(self.generate_async(
                    text, output_path, current_voice, rate, volume
                ))

                if success:
                    if current_voice != voice:
                        print(f"  备用音色 {current_voice} 生成成功")
                    return True

                # 如果不是"No audio was received"错误，不重试
                # 这里简化处理，所有错误都重试

        print(f"  所有音色尝试失败")
        return False

    def generate(
        self,
        text: str,
        output_path: str,
        voice: str = "zh-CN-XiaoxiaoNeural",
        rate: str = "+0%",
        volume: str = "+0%",
        use_retry: bool = True
    ) -> bool:
        """
        同步生成语音

        Args:
            text: 要转换的文本
            output_path: 输出文件路径
            voice: 音色名称
            rate: 语速调节
            volume: 音量调节
            use_retry: 是否启用重试机制（默认启用）

        Returns:
            是否成功
        """
        if use_retry:
            return self.generate_with_retry(text, output_path, voice, rate, volume)
        else:
            return asyncio.run(self.generate_async(text, output_path, voice, rate, volume))

    @staticmethod
    async def list_voices_async(language: str = None) -> List[Dict]:
        """获取可用音色列表"""
        import edge_tts
        voices = await edge_tts.list_voices()

        if language:
            voices = [v for v in voices if v.get("Locale", "").startswith(language)]

        return voices

    @staticmethod
    def list_voices(language: str = None) -> List[Dict]:
        """同步获取可用音色列表"""
        return asyncio.run(TTSGenerator.list_voices_async(language))


class VideoProcessor:
    """视频处理工具类"""

    @classmethod
    def concat_videos(cls, video_paths: List[str], output_path: str) -> bool:
        """
        拼接多个视频

        Args:
            video_paths: 视频路径列表
            output_path: 输出路径

        Returns:
            是否成功
        """
        if not video_paths:
            return False

        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        # 使用FFmpeg concat demuxer
        try:
            import imageio_ffmpeg
            ffmpeg_exe = imageio_ffmpeg.get_ffmpeg_exe()
        except ImportError:
            ffmpeg_exe = "ffmpeg"

        # 创建临时列表文件
        with tempfile.NamedTemporaryFile(mode='w', suffix='.txt', delete=False) as f:
            for path in video_paths:
                # 使用绝对路径避免问题
                abs_path = Path(path).resolve()
                f.write(f"file '{abs_path}'\n")
            list_file = f.name

        try:
            cmd = [
                ffmpeg_exe, "-y",
                "-f", "concat",
                "-safe", "0",
                "-i", list_file,
                "-c", "copy",
                output_path
            ]

            result = subprocess.run(cmd, capture_output=True, text=True)
            return result.returncode == 0
        finally:
            if os.path.exists(list_file):
                os.unlink(list_file)

    @classmethod
    def create_video_from_image_audio(
        cls,
        image_path: str,
        audio_path: str,
        output_path: str,
        fps: int = 24,
        resolution_height: int = 720
    ) -> bool:
        """
        根据音频时长生成静态图片视频

        Args:
            image_path: 图片路径
            audio_path: 音频路径（用于获取时长和作为音轨）
            output_path: 输出路径
            fps: 帧率
            resolution_height: 输出高度（宽度按比例缩放）

        Returns:
            是否成功
        """
        Path(output_path).parent.mkdir(parents=True, exist_ok=True)

        try:
            import imageio_ffmpeg
            ffmpeg_exe = imageio_ffmpeg.get_ffmpeg_exe()
        except ImportError:
            ffmpeg_exe = "ffmpeg"

        cmd = [
            ffmpeg_exe, "-y",
            "-loop", "1",
            "-i", image_path,
            "-i", audio_path,
            "-c:v", "libx264",
            "-tune", "stillimage",
            "-c:a", "aac",
            "-b:a", "192k",
            "-pix_fmt", "yuv420p",
            "-vf", f"scale=-2:{resolution_height}",
            "-shortest",
            "-r", str(fps),
            output_path
        ]

        result = subprocess.run(cmd, capture_output=True, text=True)
        return result.returncode == 0


class MotionComicGenerator:
    """动态漫生成器主类"""

    def __init__(self, config_path: Optional[str] = None):
        self.config = DEFAULT_CONFIG.copy()

        # 加载配置文件
        if config_path:
            self._load_config(config_path)
        else:
            default_config = Path(__file__).parent / "config.json"
            if default_config.exists():
                self._load_config(str(default_config))

        # 初始化TTS生成器（使用配置中的重试参数）
        self.tts = TTSGenerator(
            max_retries=self.config.get("max_retries", 3),
            retry_delay=self.config.get("retry_delay", 1.0)
        )

    def _load_config(self, config_path: str):
        """加载配置文件"""
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                user_config = json.load(f)
                self.config.update(user_config)
        except Exception as e:
            print(f"加载配置文件失败: {e}")

    def generate_tts(
        self,
        text: str,
        output_path: str,
        voice: Optional[str] = None
    ) -> bool:
        """
        生成语音

        Args:
            text: 要转换的文本
            output_path: 输出文件路径
            voice: 音色名称

        Returns:
            是否成功
        """
        voice = voice or self.config.get("default_voice", "zh-CN-XiaoxiaoNeural")
        return self.tts.generate(text, output_path, voice)

    def generate_scene(
        self,
        image_path: str,
        text: str,
        output_path: str,
        voice: Optional[str] = None
    ) -> bool:
        """
        生成单个场景视频（图片+文字->视频）

        Args:
            image_path: 图片路径
            text: 台词文本
            output_path: 输出路径
            voice: 音色

        Returns:
            是否成功
        """
        voice = voice or self.config.get("default_voice", "zh-CN-XiaoxiaoNeural")

        # 临时音频文件
        with tempfile.NamedTemporaryFile(suffix='.mp3', delete=False) as f:
            audio_path = f.name

        try:
            # 1. 生成语音
            print(f"生成语音: {text[:30]}...")
            if not self.tts.generate(text, audio_path, voice):
                return False

            # 2. 生成视频（静态图片+音频）
            print("合成视频...")
            resolution = self.config.get("resolution", "720p")
            height = int(resolution.replace("p", "")) if "p" in str(resolution) else 720

            if not VideoProcessor.create_video_from_image_audio(
                image_path, audio_path, output_path,
                fps=self.config.get("fps", 24),
                resolution_height=height
            ):
                return False

            return Path(output_path).exists()
        finally:
            if os.path.exists(audio_path):
                os.unlink(audio_path)

    def generate_from_config(
        self,
        config_path: str,
        output_path: Optional[str] = None
    ) -> GenerateResult:
        """
        从配置文件生成完整动态漫

        Args:
            config_path: 故事配置文件路径
            output_path: 输出路径

        Returns:
            生成结果
        """
        try:
            with open(config_path, 'r', encoding='utf-8') as f:
                story_config = json.load(f)
        except Exception as e:
            return GenerateResult(False, message=f"读取配置文件失败: {e}")

        scenes = story_config.get("scenes", [])
        if not scenes:
            return GenerateResult(False, message="配置文件中没有场景")

        output_dir = Path(self.config.get("output_dir", "./output"))
        output_dir.mkdir(parents=True, exist_ok=True)

        # 确定输出路径
        if not output_path:
            title = story_config.get("title", "motion_comic")
            output_path = str(output_dir / f"{title}.mp4")

        scene_videos = []

        for i, scene_data in enumerate(scenes):
            scene = Scene(**scene_data)
            scene_output = str(output_dir / f"scene_{i+1:03d}.mp4")

            print(f"\n处理场景 {i+1}/{len(scenes)}...")

            # 生成场景视频
            if scene.audio:
                # 使用预置音频
                print(f"使用预置音频: {scene.audio}")
                resolution = self.config.get("resolution", "720p")
                height = int(resolution.replace("p", "")) if "p" in str(resolution) else 720

                if not VideoProcessor.create_video_from_image_audio(
                    scene.frame, scene.audio, scene_output,
                    resolution_height=height
                ):
                    return GenerateResult(False, message=f"场景 {i+1} 生成失败")
            else:
                # 生成语音+视频
                if not self.generate_scene(
                    scene.frame, scene.text, scene_output, scene.voice
                ):
                    return GenerateResult(False, message=f"场景 {i+1} 生成失败")

            scene_videos.append(scene_output)

        # 拼接所有场景
        print("\n拼接视频...")
        if not VideoProcessor.concat_videos(scene_videos, output_path):
            return GenerateResult(False, message="视频拼接失败")

        print(f"\n生成完成: {output_path}")
        return GenerateResult(
            success=True,
            output_path=output_path,
            scenes_generated=len(scenes),
            message="生成成功"
        )

    def generate_from_args(
        self,
        frames: List[str],
        texts: List[str],
        voices: Optional[List[str]] = None,
        output_path: str = "./output/comic.mp4"
    ) -> GenerateResult:
        """
        从命令行参数生成动态漫

        Args:
            frames: 关键帧图片路径列表
            texts: 台词文本列表
            voices: 音色列表
            output_path: 输出路径

        Returns:
            生成结果
        """
        if len(frames) != len(texts):
            return GenerateResult(
                False,
                message="关键帧数量与台词数量不匹配"
            )

        default_voice = self.config.get("default_voice", "zh-CN-XiaoxiaoNeural")
        if not voices:
            voices = [default_voice] * len(frames)
        elif len(voices) < len(frames):
            voices = voices + [default_voice] * (len(frames) - len(voices))

        output_dir = Path(output_path).parent
        output_dir.mkdir(parents=True, exist_ok=True)

        scene_videos = []

        for i, (frame, text, voice) in enumerate(zip(frames, texts, voices)):
            scene_output = str(output_dir / f"scene_{i+1:03d}.mp4")

            print(f"\n处理场景 {i+1}/{len(frames)}...")

            if not self.generate_scene(frame, text, scene_output, voice):
                return GenerateResult(False, message=f"场景 {i+1} 生成失败")

            scene_videos.append(scene_output)

        # 拼接所有场景
        print("\n拼接视频...")
        if not VideoProcessor.concat_videos(scene_videos, output_path):
            return GenerateResult(False, message="视频拼接失败")

        print(f"\n生成完成: {output_path}")
        return GenerateResult(
            success=True,
            output_path=output_path,
            scenes_generated=len(frames),
            message="生成成功"
        )


def main():
    """命令行入口"""
    parser = argparse.ArgumentParser(
        description="动态漫生成器 - 将关键帧图片和对话脚本合成为带语音的视频",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例用法:
  # 生成配音
  python motion_comic_generator.py tts --text "你好世界" --output ./output/voice.mp3

  # 从配置文件生成完整动态漫
  python motion_comic_generator.py generate --config ./story.json --output ./output/comic.mp4

  # 从命令行参数生成
  python motion_comic_generator.py generate \\
      --frames ./frame1.png ./frame2.png \\
      --texts "第一句台词" "第二句台词" \\
      --voices "zh-CN-YunxiNeural" "zh-CN-XiaoxiaoNeural" \\
      --output ./output/comic.mp4

  # 查看可用音色
  python motion_comic_generator.py list-voices --language zh-CN
        """
    )

    subparsers = parser.add_subparsers(dest="command", help="可用命令")

    # TTS 命令
    tts_parser = subparsers.add_parser("tts", help="生成语音")
    tts_parser.add_argument("--text", "-t", required=True, help="要转换的文本")
    tts_parser.add_argument("--output", "-o", required=True, help="输出文件路径")
    tts_parser.add_argument("--voice", "-v", default="zh-CN-XiaoxiaoNeural", help="音色")
    tts_parser.add_argument("--rate", default="+0%", help="语速")
    tts_parser.add_argument("--volume", default="+0%", help="音量")

    # 生成命令
    gen_parser = subparsers.add_parser("generate", help="生成动态漫")
    gen_parser.add_argument("--config", "-c", help="配置文件路径")
    gen_parser.add_argument("--frames", nargs="+", help="关键帧图片路径")
    gen_parser.add_argument("--texts", nargs="+", help="台词文本")
    gen_parser.add_argument("--voices", nargs="+", help="音色列表")
    gen_parser.add_argument("--output", "-o", default="./output/comic.mp4", help="输出路径")

    # 查看音色命令
    voices_parser = subparsers.add_parser("list-voices", help="查看可用音色")
    voices_parser.add_argument("--language", "-l", help="筛选语言 (如 zh-CN, en-US)")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return 1

    generator = MotionComicGenerator()

    if args.command == "tts":
        print(f"生成语音: {args.text[:50]}...")
        success = generator.generate_tts(args.text, args.output, args.voice)
        if success:
            print(f"已保存: {args.output}")
            return 0
        else:
            print("生成失败")
            return 1

    elif args.command == "generate":
        if args.config:
            result = generator.generate_from_config(args.config, args.output)
        elif args.frames and args.texts:
            result = generator.generate_from_args(
                args.frames, args.texts, args.voices, args.output
            )
        else:
            print("错误: 需要提供 --config 或 --frames 和 --texts")
            return 1

        if result.success:
            print(f"\n生成成功!")
            print(f"输出路径: {result.output_path}")
            print(f"场景数量: {result.scenes_generated}")
            return 0
        else:
            print(f"\n生成失败: {result.message}")
            return 1

    elif args.command == "list-voices":
        print("正在获取音色列表...")
        voices = TTSGenerator.list_voices(args.language)

        print(f"\n找到 {len(voices)} 个音色:\n")
        for voice in voices[:50]:
            name = voice.get("ShortName", "Unknown")
            gender = voice.get("Gender", "Unknown")
            locale = voice.get("Locale", "Unknown")
            print(f"  {name:<35} [{gender}] ({locale})")

        if len(voices) > 50:
            print(f"\n  ... 还有 {len(voices) - 50} 个音色")

        return 0

    return 0


if __name__ == "__main__":
    exit(main())
