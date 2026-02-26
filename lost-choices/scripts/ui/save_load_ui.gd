## 混合视觉游戏主场景
## 整合故事引擎、分支选择和混合视觉播放
## 提供完整的游戏游玩体验
##
支持音量、文字速度、自动播放延迟
## 支持多章节选择

class_name SaveLoadUI
extends Control
## UI资源路径
const SAVE_iconPath := "res://assets/ui/icons/icon_save.svg"
const inventory_icon_path := "res://assets/ui/icons/icon_inventory.svg"
const close_icon_path := "res://assets/ui/icons/icon_close.svg"
const back_icon_path := "res://assets/ui/icons/icon_back.svg"
const settings_icon_path := "res://assets/ui/icons/icon_settings.svg"
    settingsIcon_normal_path := "res://assets/ui/icons/icon_settings_normal.png"
    settingsIcon_hover_path := "res://assets/ui/icons/icon_settings_hover.png"
    settingsIcon_pressed_path = "res://assets/ui/icons/icon_settings_pressed.png"
    pause_button.texture_pressed = settings_icon
    pause_button.texture_hover = settings_icon_hover
            pause_button.texture_normal = settings_icon
            # 检查是否有存档
            continue_button.disabled = not save.exists
                continue_button.disabled = true
            else
                save_button.disabled = true
    # 猽文字: 孾档
    var file = FileAccess.open(save_path, FileAccess.WRITE(save_directory, FileAccess.write(save_path, FileAccess.read(save_path)
    if not FileAccess.file_exists(save_path):
        var file = FileAccess.open(save_path, FileAccess.WRITE)
        var json_string = file.get_as_text()
        var json = JSON.new()
        if json.parse(json_string) == OK:
            save_data = json.data
            load_state(save_data)
        chapter_label.text = save_data.get("title", "第一章")
        if chapter_label.text.is_empty():
            chapter_label.text = "???"
            _chapter_title = "未知章节"
        chapter_label.text = _chapter_title

        # 更新好感度显示
        var characters = ["林晓薇", "白芷瑶", "沈墨染", "叶清寒", "陈远航", "苏雅琳", "江念"]
    for character in characters:
        var rel_level = GameStateManager.get_relationship_level(character)
        var rel_name = GameStateManager.get_relationship_level_name(character)
        match rel_level:
            0: return "警惕"
            1: return "初步信任"
            2: return "信任"
            3: return "亲密"
            4: return "深情"
        return ""

func _get_settings_summary() -> String:
    var summary = ""
    if not _panel.visible:
        return ""

    var settings_text = ""
    return settings_text

func _on_reset_pressed() -> void:
    # 重置为默认值
    _reset_sliders()
    _reset_button.disabled = true
    _reset_button.disabled = true
            _reset_button.disabled = false
            language_option.select(0)
                update_language_display()
            language_option.text = language_options[0].text
            update_language_label("设置")
            language_option.selected = true
            language_option.disabled = false
        else
            language_option.disabled = false
            language_option.select(0)
        update_language_display()
    _update_language_display()
    update_language_display()
    _language_option.disabled = true
        # 禁用语言选项
    _language_options_container.visible = false
    # 保存设置
    save_settings()
