## 设置界面 - 游戏设置
## 支持音量、文字速度、自动播放延迟等设置
class_name SettingsUI
extends Control

## 信号
signal settings_closed()
signal settings_opened()

## 节点引用
@onready var master_slider: HSlider
@onready var bgm_slider: HSlider
@onready var sfx_slider: HSlider
@onready var text_speed_slider: HSlider
@onready var auto_play_slider: HSlider
@onready var language_option: OptionButton
@onready var close_button: Button
@onready var reset_button: Button
@onready var panel: PanelContainer

## 设置值
var _master_volume: float = 1.0
var _bgm_volume: float = 0.8
var _sfx_volume: float = 1.0
var _text_speed: float = 1.0
var _auto_play_delay: float = 3.0
var _language: String = "zh-CN"

## 默认值
const DEFAULT_MASTER_VOLUME := 1.0
const DEFAULT_BGM_VOLUME := 0.8
const DEFAULT_SFX_VOLUME := 1.0
const DEFAULT_TEXT_SPEED := 1.0
const DEFAULT_AUTO_PLAY_DELAY := 3.0
const DEFAULT_LANGUAGE := "zh-CN"

## 语言选项
var _language_options: Array = [
	{"code": "zh-CN", "name": "简体中文"},
	{"code": "en-US", "name": "English"}
]

func _ready() -> void:
	_load_settings()
	_setup_ui()
	_setup_signals()

func _setup_ui() -> void:
	"""初始化UI组件"""
	# 设置语言选项
	if language_option:
		language_option.clear()
		for lang in _language_options:
			language_option.add_item(lang["name"])
		# 选择当前语言
		for i in range(_language_options.size()):
			if _language_options[i]["code"] == _language:
				language_option.select(i)
				break

	# 应用当前值到滑块
	if master_slider:
		master_slider.min_value = 0.0
		master_slider.max_value = 1.0
		master_slider.step = 0.05
		master_slider.value = _master_volume

	if bgm_slider:
		bgm_slider.min_value = 0.0
		bgm_slider.max_value = 1.0
		bgm_slider.step = 0.05
		bgm_slider.value = _bgm_volume

	if sfx_slider:
		sfx_slider.min_value = 0.0
		sfx_slider.max_value = 1.0
		sfx_slider.step = 0.05
		sfx_slider.value = _sfx_volume

	if text_speed_slider:
		text_speed_slider.min_value = 0.5
		text_speed_slider.max_value = 2.0
		text_speed_slider.step = 0.1
		text_speed_slider.value = _text_speed

	if auto_play_slider:
		auto_play_slider.min_value = 1.0
		auto_play_slider.max_value = 10.0
		auto_play_slider.step = 0.5
		auto_play_slider.value = _auto_play_delay

func _setup_signals() -> void:
	"""连接信号"""
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

	if reset_button:
		reset_button.pressed.connect(_on_reset_to_default)

	if master_slider:
		master_slider.value_changed.connect(_on_master_volume_changed)

	if bgm_slider:
		bgm_slider.value_changed.connect(_on_bgm_volume_changed)

	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_volume_changed)

	if text_speed_slider:
		text_speed_slider.value_changed.connect(_on_text_speed_changed)

	if auto_play_slider:
		auto_play_slider.value_changed.connect(_on_auto_play_changed)

	if language_option:
		language_option.item_selected.connect(_on_language_selected)

func _load_settings() -> void:
	"""从SettingsManager加载设置"""
	_master_volume = SettingsManager.get_setting("master_volume", DEFAULT_MASTER_VOLUME)
	_bgm_volume = SettingsManager.get_setting("bgm_volume", DEFAULT_BGM_VOLUME)
	_sfx_volume = SettingsManager.get_setting("sfx_volume", DEFAULT_SFX_VOLUME)
	_text_speed = SettingsManager.get_setting("text_speed", DEFAULT_TEXT_SPEED)
	_auto_play_delay = SettingsManager.get_setting("auto_play_delay", DEFAULT_AUTO_PLAY_DELAY)
	_language = SettingsManager.get_setting("language", DEFAULT_LANGUAGE)

func _save_settings() -> void:
	"""保存设置到SettingsManager"""
	SettingsManager.set_setting("master_volume", _master_volume)
	SettingsManager.set_setting("bgm_volume", _bgm_volume)
	SettingsManager.set_setting("sfx_volume", _sfx_volume)
	SettingsManager.set_setting("text_speed", _text_speed)
	SettingsManager.set_setting("auto_play_delay", _auto_play_delay)
	SettingsManager.set_setting("language", _language)
	SettingsManager.save_settings()

## 音量变化回调

func _on_master_volume_changed(value: float) -> void:
	_master_volume = value
	AudioManager.set_master_volume(value)

func _on_bgm_volume_changed(value: float) -> void:
	_bgm_volume = value
	AudioManager.set_bgm_volume(value)

func _on_sfx_volume_changed(value: float) -> void:
	_sfx_volume = value
	AudioManager.set_sfx_volume(value)

func _on_text_speed_changed(value: float) -> void:
	_text_speed = value

func _on_auto_play_changed(value: float) -> void:
	_auto_play_delay = value

func _on_language_selected(index: int) -> void:
	if index >= 0 and index < _language_options.size():
		_language = _language_options[index]["code"]

## 按钮回调

func _on_close_pressed() -> void:
	"""关闭设置界面"""
	_save_settings()

	# 播放关闭动画
	if panel:
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 0.0, 0.2)
		tween.tween_callback(func(): hide())
		tween.tween_callback(func(): settings_closed.emit())
	else:
		hide()
		settings_closed.emit()

func _on_reset_to_default() -> void:
	"""重置为默认值"""
	_master_volume = DEFAULT_MASTER_VOLUME
	_bgm_volume = DEFAULT_BGM_VOLUME
	_sfx_volume = DEFAULT_SFX_VOLUME
	_text_speed = DEFAULT_TEXT_SPEED
	_auto_play_delay = DEFAULT_AUTO_PLAY_DELAY
	_language = DEFAULT_LANGUAGE

	# 更新UI
	_setup_ui()

	# 应用默认值
	AudioManager.set_master_volume(_master_volume)
	AudioManager.set_bgm_volume(_bgm_volume)
	AudioManager.set_sfx_volume(_sfx_volume)

## 显示设置界面
func show_settings() -> void:
	visible = true
	_load_settings()
	_setup_ui()

	# 淡入动画
	if panel:
		panel.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.2)

	settings_opened.emit()

## 隐藏设置界面
func hide_settings() -> void:
	_save_settings()
	hide()
	settings_closed.emit()

## 获取设置摘要
func get_settings_summary() -> String:
	return "音量: %.0f%% | 文字速度: %.1fx | 自动播放: %.1fs" % [
		_master_volume * 100,
		_text_speed,
		_auto_play_delay
	]
