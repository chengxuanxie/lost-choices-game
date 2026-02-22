#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
火山引擎对象存储服务 TOS（Torch Object Storage）上传工具

功能:
- 创建桶（可指定为公共读）
- 上传文件并获得公网可访问链接
- 删除桶

配置优先级: 参数 > 环境变量 > config.json
"""

import os
import sys
import json
import argparse
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional, List, Dict
from enum import Enum

try:
    import tos
except ImportError:
    print("请先安装 tos 库: pip install tos")
    sys.exit(1)


# 环境变量名称
ENV_ACCESS_KEY = "VOLC_ACCESSKEY"
ENV_SECRET_KEY = "VOLC_SECRETKEY"
ENV_ENDPOINT = "VOLC_TOS_ENDPOINT"
ENV_REGION = "VOLC_TOS_REGION"

# 默认配置
DEFAULT_ENDPOINT = "tos-cn-beijing.volces.com"
DEFAULT_REGION = "cn-beijing"


class BucketACL(Enum):
    """桶访问权限"""
    PRIVATE = "private"
    PUBLIC_READ = "public-read"
    PUBLIC_READ_WRITE = "public-read-write"


@dataclass
class UploadResult:
    """上传结果"""
    success: bool
    object_key: str = ""
    url: str = ""
    bucket: str = ""
    message: str = ""
    error_code: int = 0
    request_id: str = ""


@dataclass
class BucketResult:
    """桶操作结果"""
    success: bool
    bucket_name: str = ""
    message: str = ""
    error_code: int = 0
    request_id: str = ""


class TOSUploader:
    """TOS 上传工具类"""

    def __init__(
        self,
        ak: Optional[str] = None,
        sk: Optional[str] = None,
        endpoint: Optional[str] = None,
        region: Optional[str] = None,
        config_path: Optional[str] = None
    ):
        """
        初始化 TOS 客户端

        配置优先级: 参数 > 环境变量 > config.json

        Args:
            ak: 火山引擎 Access Key
            sk: 火山引擎 Secret Key
            endpoint: TOS 服务端点，如 tos-cn-beijing.volces.com
            region: 区域，如 cn-beijing
            config_path: 配置文件路径，默认为脚本目录下的 config.json
        """
        config = self._load_config(config_path)

        self.ak = ak or config.get("ak") or os.environ.get(ENV_ACCESS_KEY)
        self.sk = sk or config.get("sk") or os.environ.get(ENV_SECRET_KEY)
        self.endpoint = endpoint or config.get("endpoint") or os.environ.get(ENV_ENDPOINT) or DEFAULT_ENDPOINT
        self.region = region or config.get("region") or os.environ.get(ENV_REGION) or DEFAULT_REGION

        if not self.ak or not self.sk:
            raise ValueError(
                f"缺少 AK/SK 配置。请通过以下方式之一提供:\n"
                f"1. 直接传入参数: TOSUploader(ak='...', sk='...')\n"
                f"2. 环境变量: {ENV_ACCESS_KEY}, {ENV_SECRET_KEY}\n"
                f"3. 配置文件 config.json"
            )

        self.client = tos.TosClientV2(
            ak=self.ak,
            sk=self.sk,
            endpoint=self.endpoint,
            region=self.region
        )

    def _load_config(self, config_path: Optional[str] = None) -> Dict[str, str]:
        """从配置文件加载配置"""
        if config_path is None:
            config_path = Path(__file__).parent / "config.json"
        else:
            config_path = Path(config_path)

        if config_path.exists():
            try:
                with open(config_path, "r", encoding="utf-8") as f:
                    return json.load(f)
            except Exception as e:
                print(f"警告: 读取配置文件失败: {e}")

        return {}

    def create_bucket(
        self,
        bucket_name: str,
        acl: BucketACL = BucketACL.PRIVATE
    ) -> BucketResult:
        """
        创建存储桶

        Args:
            bucket_name: 桶名称（全局唯一，3-63字符，小写字母、数字和短横线）
            acl: 访问权限，默认私有

        Returns:
            BucketResult: 操作结果
        """
        try:
            # 先创建桶（不传acl参数）
            result = self.client.create_bucket(bucket=bucket_name)

            # 设置桶策略为公共读（如果需要）
            if acl == BucketACL.PUBLIC_READ:
                self._set_public_read_policy(bucket_name)

            return BucketResult(
                success=True,
                bucket_name=bucket_name,
                message=f"桶 '{bucket_name}' 创建成功，权限: {acl.value}",
                request_id=getattr(result, 'request_id', '')
            )

        except tos.exceptions.TosClientError as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"客户端错误: {e}",
                error_code=-1
            )
        except tos.exceptions.TosServerError as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"服务端错误: {e}",
                error_code=e.status_code,
                request_id=getattr(e, 'request_id', '')
            )
        except Exception as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"未知错误: {e}",
                error_code=-1
            )

    def _set_public_read_policy(self, bucket_name: str):
        """设置桶为公共读策略"""
        policy = {
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "tos:GetObject",
                        "tos:GetObjectVersion"
                    ],
                    "Resource": [
                        f"trn:tos:::{bucket_name}/*"
                    ],
                    "Principal": "*"
                }
            ]
        }

        try:
            self.client.put_bucket_policy(
                bucket=bucket_name,
                policy=json.dumps(policy)
            )
        except Exception as e:
            print(f"警告: 设置公共读策略失败: {e}")

    def upload_file(
        self,
        bucket_name: str,
        file_path: str,
        object_key: Optional[str] = None,
        content_type: Optional[str] = None
    ) -> UploadResult:
        """
        上传文件到存储桶

        Args:
            bucket_name: 桶名称
            file_path: 本地文件路径
            object_key: 对象键名（存储路径），默认使用文件名
            content_type: 内容类型，自动检测常见格式

        Returns:
            UploadResult: 上传结果，包含公网访问URL
        """
        file_path = Path(file_path)

        if not file_path.exists():
            return UploadResult(
                success=False,
                message=f"文件不存在: {file_path}"
            )

        # 生成对象键名
        if object_key is None:
            object_key = file_path.name

        # 强制使用正斜杠（TOS和URL需要正斜杠，与操作系统无关）
        object_key = object_key.replace("\\", "/")

        # 自动检测 content_type
        if content_type is None:
            content_type = self._detect_content_type(file_path)

        try:
            with open(file_path, "rb") as f:
                result = self.client.put_object(
                    bucket=bucket_name,
                    key=object_key,
                    content=f,
                    content_type=content_type
                )

            # 构建公网访问URL
            url = f"https://{bucket_name}.{self.endpoint}/{object_key}"

            return UploadResult(
                success=True,
                object_key=object_key,
                url=url,
                bucket=bucket_name,
                message=f"上传成功: {file_path.name} -> {object_key}",
                request_id=getattr(result, 'request_id', '')
            )

        except tos.exceptions.TosClientError as e:
            return UploadResult(
                success=False,
                message=f"客户端错误: {e}",
                error_code=-1
            )
        except tos.exceptions.TosServerError as e:
            return UploadResult(
                success=False,
                message=f"服务端错误: {e}",
                error_code=e.status_code,
                request_id=getattr(e, 'request_id', '')
            )
        except Exception as e:
            return UploadResult(
                success=False,
                message=f"未知错误: {e}",
                error_code=-1
            )

    def upload_directory(
        self,
        bucket_name: str,
        dir_path: str,
        prefix: str = ""
    ) -> List[UploadResult]:
        """
        上传整个目录

        Args:
            bucket_name: 桶名称
            dir_path: 本地目录路径
            prefix: 对象键前缀（模拟目录结构）

        Returns:
            List[UploadResult]: 所有文件的上传结果
        """
        dir_path = Path(dir_path)

        if not dir_path.is_dir():
            return [UploadResult(
                success=False,
                message=f"目录不存在: {dir_path}"
            )]

        results = []
        for file_path in dir_path.rglob("*"):
            if file_path.is_file():
                # 计算相对路径作为对象键
                relative_path = file_path.relative_to(dir_path)
                # 强制使用正斜杠（TOS和URL需要正斜杠，与操作系统无关）
                relative_path_str = str(relative_path).replace("\\", "/")
                object_key = f"{prefix}/{relative_path_str}".lstrip("/")

                result = self.upload_file(
                    bucket_name=bucket_name,
                    file_path=str(file_path),
                    object_key=object_key
                )
                results.append(result)

        return results

    def delete_object(
        self,
        bucket_name: str,
        object_key: str
    ) -> BucketResult:
        """
        删除对象

        Args:
            bucket_name: 桶名称
            object_key: 对象键名

        Returns:
            BucketResult: 操作结果
        """
        try:
            result = self.client.delete_object(
                bucket=bucket_name,
                key=object_key
            )

            return BucketResult(
                success=True,
                bucket_name=bucket_name,
                message=f"对象 '{object_key}' 删除成功",
                request_id=getattr(result, 'request_id', '')
            )

        except tos.exceptions.TosServerError as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"删除失败: {e}",
                error_code=e.status_code,
                request_id=getattr(e, 'request_id', '')
            )
        except Exception as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"未知错误: {e}",
                error_code=-1
            )

    def delete_bucket(self, bucket_name: str, force: bool = False) -> BucketResult:
        """
        删除存储桶

        Args:
            bucket_name: 桶名称
            force: 是否强制删除（先删除桶内所有对象）

        Returns:
            BucketResult: 操作结果
        """
        try:
            # 如果强制删除，先清空桶内对象
            if force:
                self._empty_bucket(bucket_name)

            result = self.client.delete_bucket(bucket=bucket_name)

            return BucketResult(
                success=True,
                bucket_name=bucket_name,
                message=f"桶 '{bucket_name}' 删除成功",
                request_id=getattr(result, 'request_id', '')
            )

        except tos.exceptions.TosServerError as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"删除失败: {e}",
                error_code=e.status_code,
                request_id=getattr(e, 'request_id', '')
            )
        except Exception as e:
            return BucketResult(
                success=False,
                bucket_name=bucket_name,
                message=f"未知错误: {e}",
                error_code=-1
            )

    def _empty_bucket(self, bucket_name: str):
        """清空桶内所有对象"""
        try:
            # 列出所有对象
            truncated = True
            continuation_token = ""

            while truncated:
                result = self.client.list_objects_type2(
                    bucket=bucket_name,
                    continuation_token=continuation_token
                )

                # 删除列出的对象
                if hasattr(result, 'contents') and result.contents:
                    for obj in result.contents:
                        self.client.delete_object(
                            bucket=bucket_name,
                            key=obj.key
                        )

                truncated = getattr(result, 'is_truncated', False)
                continuation_token = getattr(result, 'next_continuation_token', "")

        except Exception as e:
            print(f"警告: 清空桶失败: {e}")

    def list_objects(self, bucket_name: str, prefix: str = "") -> List[str]:
        """
        列出桶内对象

        Args:
            bucket_name: 桶名称
            prefix: 对象键前缀

        Returns:
            List[str]: 对象键列表
        """
        objects = []

        try:
            truncated = True
            continuation_token = ""

            while truncated:
                result = self.client.list_objects_type2(
                    bucket=bucket_name,
                    prefix=prefix,
                    continuation_token=continuation_token
                )

                if hasattr(result, 'contents') and result.contents:
                    for obj in result.contents:
                        objects.append(obj.key)

                truncated = getattr(result, 'is_truncated', False)
                continuation_token = getattr(result, 'next_continuation_token', "")

        except Exception as e:
            print(f"列出对象失败: {e}")

        return objects

    def get_object_url(self, bucket_name: str, object_key: str, expires: int = 3600) -> str:
        """
        获取对象的临时访问URL（签名URL）

        Args:
            bucket_name: 桶名称
            object_key: 对象键名
            expires: URL有效期（秒），默认1小时

        Returns:
            str: 签名URL
        """
        try:
            result = self.client.pre_signed_url(
                http_method='GET',
                bucket=bucket_name,
                key=object_key,
                expires=expires
            )
            return result.signed_url
        except Exception as e:
            print(f"获取签名URL失败: {e}")
            return ""

    @staticmethod
    def _detect_content_type(file_path: Path) -> str:
        """检测文件内容类型"""
        suffix = file_path.suffix.lower()
        content_types = {
            '.jpg': 'image/jpeg',
            '.jpeg': 'image/jpeg',
            '.png': 'image/png',
            '.gif': 'image/gif',
            '.webp': 'image/webp',
            '.bmp': 'image/bmp',
            '.svg': 'image/svg+xml',
            '.pdf': 'application/pdf',
            '.json': 'application/json',
            '.xml': 'application/xml',
            '.html': 'text/html',
            '.txt': 'text/plain',
            '.css': 'text/css',
            '.js': 'application/javascript',
            '.mp4': 'video/mp4',
            '.mp3': 'audio/mpeg',
            '.zip': 'application/zip',
        }
        return content_types.get(suffix, 'application/octet-stream')


def main():
    """命令行入口"""
    parser = argparse.ArgumentParser(
        description="火山引擎 TOS 对象存储工具",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
示例:
  # 创建私有桶
  python tos_uploader.py create-bucket --bucket my-bucket

  # 创建公共读桶
  python tos_uploader.py create-bucket --bucket my-bucket --public

  # 上传文件
  python tos_uploader.py upload --bucket my-bucket --file ./image.png

  # 上传文件并指定对象键名
  python tos_uploader.py upload --bucket my-bucket --file ./image.png --key images/photo.png

  # 上传目录
  python tos_uploader.py upload-dir --bucket my-bucket --dir ./images --prefix assets

  # 列出桶内对象
  python tos_uploader.py list --bucket my-bucket

  # 删除对象
  python tos_uploader.py delete-object --bucket my-bucket --key image.png

  # 删除桶（需要先清空）
  python tos_uploader.py delete-bucket --bucket my-bucket --force
        """
    )

    # 通用参数
    parser.add_argument("--ak", help="火山引擎 Access Key（优先级最高）")
    parser.add_argument("--sk", help="火山引擎 Secret Key（优先级最高）")
    parser.add_argument("--endpoint", default=DEFAULT_ENDPOINT, help=f"TOS 服务端点（默认: {DEFAULT_ENDPOINT}）")
    parser.add_argument("--region", default=DEFAULT_REGION, help=f"区域（默认: {DEFAULT_REGION}）")
    parser.add_argument("--config", help="配置文件路径")

    subparsers = parser.add_subparsers(dest="command", help="可用命令")

    # create-bucket 子命令
    create_parser = subparsers.add_parser("create-bucket", help="创建存储桶")
    create_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    create_parser.add_argument("--public", action="store_true", help="设置为公共读")

    # upload 子命令
    upload_parser = subparsers.add_parser("upload", help="上传文件")
    upload_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    upload_parser.add_argument("--file", "-f", required=True, help="本地文件路径")
    upload_parser.add_argument("--key", "-k", help="对象键名（默认使用文件名）")

    # upload-dir 子命令
    upload_dir_parser = subparsers.add_parser("upload-dir", help="上传目录")
    upload_dir_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    upload_dir_parser.add_argument("--dir", "-d", required=True, help="本地目录路径")
    upload_dir_parser.add_argument("--prefix", "-p", default="", help="对象键前缀")

    # list 子命令
    list_parser = subparsers.add_parser("list", help="列出桶内对象")
    list_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    list_parser.add_argument("--prefix", "-p", default="", help="对象键前缀")

    # delete-object 子命令
    delete_obj_parser = subparsers.add_parser("delete-object", help="删除对象")
    delete_obj_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    delete_obj_parser.add_argument("--key", "-k", required=True, help="对象键名")

    # delete-bucket 子命令
    delete_bucket_parser = subparsers.add_parser("delete-bucket", help="删除存储桶")
    delete_bucket_parser.add_argument("--bucket", "-b", required=True, help="桶名称")
    delete_bucket_parser.add_argument("--force", action="store_true", help="强制删除（清空桶内对象）")

    args = parser.parse_args()

    if not args.command:
        parser.print_help()
        return

    try:
        uploader = TOSUploader(
            ak=args.ak,
            sk=args.sk,
            endpoint=args.endpoint,
            region=args.region,
            config_path=args.config
        )

        if args.command == "create-bucket":
            acl = BucketACL.PUBLIC_READ if args.public else BucketACL.PRIVATE
            result = uploader.create_bucket(args.bucket, acl)
            print(f"{'成功' if result.success else '失败'}: {result.message}")
            if result.request_id:
                print(f"Request ID: {result.request_id}")

        elif args.command == "upload":
            result = uploader.upload_file(
                bucket_name=args.bucket,
                file_path=args.file,
                object_key=args.key
            )
            print(f"{'成功' if result.success else '失败'}: {result.message}")
            if result.success:
                print(f"对象键: {result.object_key}")
                print(f"访问URL: {result.url}")
            if result.request_id:
                print(f"Request ID: {result.request_id}")

        elif args.command == "upload-dir":
            results = uploader.upload_directory(
                bucket_name=args.bucket,
                dir_path=args.dir,
                prefix=args.prefix
            )
            success_count = sum(1 for r in results if r.success)
            print(f"上传完成: {success_count}/{len(results)} 成功")
            for r in results:
                status = "OK" if r.success else "FAIL"
                print(f"  [{status}] {r.object_key or r.message}")

        elif args.command == "list":
            objects = uploader.list_objects(args.bucket, args.prefix)
            print(f"桶 '{args.bucket}' 内对象 ({len(objects)} 个):")
            for obj in objects:
                print(f"  {obj}")

        elif args.command == "delete-object":
            result = uploader.delete_object(args.bucket, args.key)
            print(f"{'成功' if result.success else '失败'}: {result.message}")

        elif args.command == "delete-bucket":
            result = uploader.delete_bucket(args.bucket, args.force)
            print(f"{'成功' if result.success else '失败'}: {result.message}")

    except ValueError as e:
        print(f"配置错误: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"执行失败: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
