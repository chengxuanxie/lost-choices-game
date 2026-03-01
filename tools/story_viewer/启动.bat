@echo off
chcp 65001 >nul
echo ========================================
echo 剧情节点查看器 - 启动服务器
echo ========================================
echo.

cd /d "%~dp0story_viewer"

echo 启动 HTTP 服务器...
echo 访问地址: http://localhost:8080
echo.
echo 按 Ctrl+C 停止服务器
echo.

python -m http.server 8080
