from playwright.sync_api import sync_playwright
import time

# 使用 Playwright 调试
with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()

    # 捕获所有网络请求
    failed_requests = []
    def on_response(response):
        if response.status >= 400:
            failed_requests.append(f"{response.status}: {response.url}")

    page.on("response", on_response)

    # 捕获控制台日志
    console_logs = []
    page.on("console", lambda msg: console_logs.append(f"{msg.type}: {msg.text}"))

    # 导航到页面
    page.goto('http://localhost:8080/tools/story_viewer/')
    page.wait_for_load_state('networkidle')

    # 等待一下让 JS 初始化
    page.wait_for_timeout(3000)

    # 截图查看
    page.screenshot(path='E:/workSpace/ai/task-game/debug_screenshot.png', full_page=True)
    print("截图已保存到 debug_screenshot.png")

    # 打印失败的请求
    print("\n=== Failed Requests ===")
    for req in failed_requests:
        print(req)

    # 打印控制台日志
    print("\n=== Console Logs ===")
    for log in console_logs:
        print(log)

    browser.close()

print("\n调试完成")
