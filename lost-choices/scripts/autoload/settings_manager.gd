## 游戏设置管理器
## 管理游戏的各项设置，包括音频、视频、语言等
## 注意：此脚本作为 Autoload 单例，不需要 class_name
extends Node

## 设置变更信号
signal settings_changed(category: String, key: String, value: Variant)
signal volume_changed(bus_name: String, value: float)

## 设置文件路径
const SETTINGS_FILE := "user://settings.cfg"

## 默认设置
var _settings: Dictionary = {
	"audio": {
		"master_volume": 1.0,
		"music_volume": 0.8,
		"sfx_volume": 1.0,
		"voice_volume": 1.0,
		"ambient_volume": 0.7
	},
	"video": {
		"fullscreen": false,
		"vsync": true,
		"brightness": 1.0,
		"quality": "high"
	},
	"gameplay": {
		"auto_save": true,
		"auto_save_interval": 300,  # 5分钟
		"text_speed": 1.0,
		"skip_seen": true,
		"choice_timer": true
	},
	"language": {
		"current": "zh_CN",
		"subtitle_enabled": true
	}
}

## 音频总线映射
const AUDIO_BUSES := {
	"master": "Master",
	"music": "Music",
	"sfx": "SFX",
	"voice": "Voice",
	"ambient": "Ambient"
}

func _ready() -> void:
	_load_settings()
	_apply_audio_settings()

#region 公共方法

## 获取设置值
func get_setting(category: String, key: String, default: Variant = null) -> Variant:
	if _settings.has(category) and _settings[category].has(key):
		return _settings[category][key]
	return default

## 设置值
func set_setting(category: String, key: String, value: Variant) -> void:
	if not _settings.has(category):
		_settings[category] = {}

	_settings[category][key] = value
	settings_changed.emit(category, key, value)

	# 特殊处理音频设置
	if category == "audio" and AUDIO_BUSES.has(key):
		_set_volume(key, value)

	_save_settings()

## 获取整个分类的设置
func get_category(category: String) -> Dictionary:
	return _settings.get(category, {}).duplicate()

## 重置设置为默认值
func reset_to_defaults() -> void:
	_settings = {
		"audio": {
			"master_volume": 1.0,
			"music_volume": 0.8,
			"sfx_volume": 1.0,
			"voice_volume": 1.0,
			"ambient_volume": 0.7
		},
		"video": {
			"fullscreen": false,
			"vsync": true,
			"brightness": 1.0,
			"quality": "high"
		},
		"gameplay": {
			"auto_save": true,
			"auto_save_interval": 300,
			"text_speed": 1.0,
			"auto_play_delay": 3.0,
			"skip_seen": true,
			"choice_timer": true
		},
		"language": {
			"current": "zh_CN",
			"subtitle_enabled": true
		}
	}

	_apply_audio_settings()
	_apply_video_settings()
	_save_settings()

	settings_changed.emit("all", "reset", true)

#endregion

#region 音频设置

## 设置音量
func set_volume(bus_name: String, value: float) -> void:
	set_setting("audio", bus_name, value)

## 获取音量
func get_volume(bus_name: String) -> float:
	return get_setting("audio", bus_name, 1.0)

## 静音切换
func toggle_mute(bus_name: String = "master") -> bool:
	var current = get_volume(bus_name)
	var new_value = 0.0 if current > 0 else 1.0
	set_volume(bus_name, new_value)
	return new_value == 0.0

func _set_volume(bus_name: String, value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(AUDIO_BUSES.get(bus_name, "Master"))
	if bus_idx >= 0:
		var db = linear_to_db(value)
		AudioServer.set_bus_volume_db(bus_idx, db)
		volume_changed.emit(bus_name, value)

func _apply_audio_settings() -> void:
	for bus_name in AUDIO_BUSES.keys():
		var volume = get_setting("audio", bus_name, 1.0)
		_set_volume(bus_name, volume)

#endregion

#region 视频设置

## 设置全屏
func set_fullscreen(enabled: bool) -> void:
	set_setting("video", "fullscreen", enabled)

	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

## 设置VSync
func set_vsync(enabled: bool) -> void:
	set_setting("video", "vsync", enabled)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if enabled else DisplayServer.VSYNC_DISABLED
	)

## 设置亮度
func set_brightness(value: float) -> void:
	set_setting("video", "brightness", value)
	# 亮度调整需要通过着色器或后处理实现

func _apply_video_settings() -> void:
	var fullscreen = get_setting("video", "fullscreen", false)
	var vsync = get_setting("video", "vsync", true)

	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)

#endregion

#region 持久化

func _load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(SETTINGS_FILE)

	if err != OK:
		print("[SettingsManager] 使用默认设置")
		return

	for category in _settings.keys():
		for key in _settings[category].keys():
			var value = config.get_value(category, key, _settings[category][key])
			_settings[category][key] = value

	print("[SettingsManager] 设置已加载")

func _save_settings() -> void:
	var config = ConfigFile.new()

	for category in _settings.keys():
		for key in _settings[category].keys():
			config.set_value(category, key, _settings[category][key])

	var err = config.save(SETTINGS_FILE)
	if err != OK:
		push_error("[SettingsManager] 保存设置失败: %s" % err)
	else:
		print("[SettingsManager] 设置已保存")

#endregion
