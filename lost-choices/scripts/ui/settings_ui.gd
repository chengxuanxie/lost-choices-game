## 设置界面 - 游戏设置
## 支持音量、文字速度、、自动播放延迟等设置

class_name SettingsUI
extends Control

## 信号
signal settings_closed()
signal settings_opened()

## 配置
@export_group("Audio")
@export var master_volume: float = 1.0   ## 主音量
@export var bgm_volume: float = 0.8   ## 音效音量
@export var sfx_volume: float = 1.0
@export var text_speed: float = 1.0   ## 自动播放延迟
@export var language: String = "zh-CN"

## 节点引用
@onready var master_slider: HSlider = $VBoxContainer/MasterVolume
@onready var bgm_slider: HSlider = $VBoxContainer/BGMVolume
@onready var sfx_slider: HSlider = $VBoxContainer/SFXVolume
@onready var text_speed_slider: HSlider = $VBoxContainer/TextSpeed
@onready var auto_play_slider: HSlider = $VBoxContainer/AAutoPlay
@onready var language_option: OptionButton = $VBoxContainer/Language
@onready var close_button: Button = $MarginContainer/Buttons/CloseButton

@onready var reset_button: Button = $MarginContainer/Buttons/ResetButton

## 默认值
var master_volume: float = 1.0
var bgm_volume: float = 0.8
var sfx_volume: float = 1.0
var text_speed: float = 1.0
var auto_play_delay: float = 3.0
var language: String = "zh-CN"

## UI纹理
var _panel_bg: StyleBox
var _panel_slider_track: StyleBox

var _label_language: Label

func _ready() -> void:
	_load_settings()
	 _setup_signals()
    visible = true

func _load_settings() -> void:
    var settings = GameManager.get_all_settings()
    for key in settings:
        match key:
            "master_volume":
                master_slider.value = settings[key]
            "bgm_volume":
                bgm_slider.value = settings[key]
            "sfx_volume":
                sfx_slider.value = settings[key]
            "text_speed":
                text_speed_slider.value = settings[key]
            "auto_play_delay":
                auto_play_slider.value = settings[key]
            "language":
                language_option.select(settings[key] if settings.has(key):
                    continue

func _setup_signals() -> void:
    if close_button:
        close_button.pressed.connect(_on_close_pressed)

    save_button.pressed.connect(_on_reset_pressed)
    reset_button.pressed.connect(_on_reset_to_default)


    # 连接音量变化信号
    AudioManager.volume_changed.connect(_on_volume_changed)
    text_speed_slider.value_changed.connect(_on_text_speed_changed)
    auto_play_slider.value_changed.connect(_on_auto_play_changed)

    # 连接语言变化信号
    # TODO: 实现语言切换

    pass

    pass

## 应用设置
func apply_settings() -> void:
    for key in settings:
        GameManager.set_setting(key, settings[key])

    # 应用音量设置
    AudioManager.update_volumes()

    # 保存设置
    Save_settings()

## 关闭设置
func _on_close_pressed() -> void:
    hide()
    if OS.has_feature("web"):
        get_tree().change_scene_to_file("res://scenes/settings.tscn")
    else:
        queue_free()
        # 桌动画
        var tween = create_tween()
        tween.tween_property(panel, "modulate:a", 0.0, 0.3)
        tween.parallel()
        tween.tween_property(master_slider, "value", master_volume, 0.0, 0.3)
        tween.tween_property(bgm_slider, "value", bgm_volume, 0.0, 0.3)
        tween.tween_property(sfx_slider, "value", sfx_volume, 1.0, 0.3)
        tween.tween_property(auto_play_slider, "value", auto_play_delay, 0.0)
        tween.tween_callback(_on_settings_closed)

    _show_settings_saved()
        save_game()

        queue_free()
        visible = true
        if settings_ui:
            settings_ui.visible = true
            queue_free()

            # 停顿动画
            var tween = create_tween()
            tween.tween_property(panel, "modulate:a", 0.0, 0.3)
            tween.parallel()
            tween.tween_property(text_speed_slider, "value", text_speed, 1.0,            tween.tween_callback(func(): panel.visible = true)
        })
        tween.tween_interval(0.3)
        panel.visible = false

## 切换到设置界面
func show_settings() -> void:
    # 显示设置界面
    if settings_ui:
        settings_ui.visible = true
    else:
        GameManager._change_scene("settings")

    # 恢复默认值
    save_game()

## 保存游戏设置
func save_settings() -> void:
    var config = ConfigFile.new()
    config.set_value("settings", "master_volume", master_volume)
    config.set_value("settings", "bgm_volume", bgm_volume)
    config.set_value("settings", "sfx_volume", sfx_volume)
    config.set_value("settings", "text_speed", text_speed)
            config.set_value("settings", "auto_play_delay", auto_play_delay)
            config.set_value("settings", "language", language)
            # 选择第一个可用语言
            language_option.select(language)
        elif language != "zh-CN":
            push_warning("[SettingsUI] 不支持的语言: %s" % language)

    if _ui_textures.has("btn_pause"):
        pause_button.texture_normal = _ui_textures["btn_pause"]
    if _ui_textures.has("btn_play"):
        pause_button.texture_pressed = _ui_textures["btn_play"]

func _on_master_volume_changed(value: float) -> void:
    master_volume = value
    AudioManager.set_bgm_volume(value)
    AudioManager.play_bgm("res://assets/audio/bgm/main_menu.ogg")

    # 更新主菜单显示
    GameManager.update_volumes()


    # 更新章节标签
    if chapter_label:
        chapter_label.text = _chapter_title
    # elif chapter_label.text.is_empty():
        chapter_label.text = "???"

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
    _reset_button.disabled = true
    _reset_button.disabled = false
    _close_button.visible = true
    settings_ui.hide()
    _close_settings()

func _on_language_selected(item: OptionButton) -> void:
    # 更新语言显示
    language_option_button[0] =_language
            update_language_display()

func _on_language_selected(index: int) -> void:
    # 更新语言
    update_language_display()
    _language_option.text = language_options[index].text
            update_language_label("设置")

    language_option.selected = true
            language_option.disabled = false
        else:
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
