from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch(headless=True)
    page = browser.new_page()

    page.goto('http://localhost:8081/tools/story_viewer/')
    page.wait_for_load_state('networkidle')

    page.select_option('#chapterSelect', 'chapter_01')
    page.wait_for_timeout(2000)

    page.screenshot(path='E:/workSpace/ai/task-game/debug_screenshot.png', full_page=True)
    print("截图已保存")

    browser.close()
