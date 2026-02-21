## 游戏管理器 - 全局游戏状态和控制
## 负责游戏生命周期管理、场景切换、全局设置
@warning_ignore("static_called_on_instance")
extends Node

## 信号定义
signal game_started
signal game_paused
signal game_resumed
signal game_ended
signal scene_changed(scene_name: String)

## 游戏状态枚举
enum GameState {
	MENU,
	PLAYING,
	PAUSED,
	DIALOG,
	CHOICE,
	LOADING,
	CUTSCENE
}

## 配置
const VERSION: String = "0.1.0"
const GAME_NAME: String = "迷途抉择"

## 状态变量
var _current_state: GameState = GameState.MENU
var _previous_state: GameState = GameState.MENU
var _play_time: float = 0.0
var _session_id: String = ""
var _is_initialized: bool = false

## 设置
var _settings: Dictionary = {
	"master_volume": 1.0,
	"bgm_volume": 0.8,
	"sfx_volume": 1.0,
	"text_speed": 1.0,
	"auto_play_delay": 3.0,
	"language": "zh-CN"
}

#region 生命周期

func _ready() -> void:
	_initialize()

func _process(delta: float) -> void:
	if _current_state == GameState.PLAYING:
		_play_time += delta

func _initialize() -> void:
	if _is_initialized:
		return

	_session_id = _generate_session_id()
	_load_settings()
	_is_initialized = true

	print("[GameManager] 游戏管理器初始化完成")
	print("[GameManager] 版本: %s, 会话ID: %s" % [VERSION, _session_id])

#endregion

#region 状态管理

## 获取当前游戏状态
func get_current_state() -> GameState:
	return _current_state

## 设置游戏状态
func set_state(new_state: GameState) -> void:
	if _current_state == new_state:
		return

	_previous_state = _current_state
	_current_state = new_state

	match new_state:
		GameState.PAUSED:
			game_paused.emit()
			get_tree().paused = true
		GameState.PLAYING:
			if _previous_state == GameState.PAUSED:
				game_resumed.emit()
				get_tree().paused = false

	print("[GameManager] 状态切换: %s -> %s" % [_state_to_string(_previous_state), _state_to_string(new_state)])

## 暂停游戏
func pause_game() -> void:
	if _current_state == GameState.PLAYING:
		set_state(GameState.PAUSED)

## 继续游戏
func resume_game() -> void:
	if _current_state == GameState.PAUSED:
		set_state(GameState.PLAYING)

## 切换到菜单
func go_to_menu() -> void:
	set_state(GameState.MENU)
	_change_scene("main_menu")

#endregion

#region 场景管理

## 切换场景
func change_scene(scene_path: String) -> void:
	_change_scene(scene_path)

## 切换场景（内部）
func _change_scene(scene_path: String) -> void:
	var full_path: String
	if scene_path.ends_with(".tscn"):
		full_path = scene_path
	else:
		full_path = "res://scenes/%s.tscn" % scene_path

	print("[GameManager] 切换场景: %s" % full_path)
	scene_changed.emit(scene_path)
	get_tree().change_scene_to_file(full_path)

## 重新加载当前场景
func reload_current_scene() -> void:
	get_tree().reload_current_scene()

#endregion

#region 游戏流程

## 开始新游戏
func start_new_game() -> void:
	GameStateManager.reset_state()
	_play_time = 0.0
	set_state(GameState.PLAYING)
	game_started.emit()
	_change_scene("game")
	print("[GameManager] 开始新游戏")

## 从存档继续
func continue_game(slot: int) -> bool:
	var success = await SaveManager.load_game(slot)
	if success:
		set_state(GameState.PLAYING)
		_change_scene("game")
		return true
	return false

## 退出游戏
func quit_game() -> void:
	game_ended.emit()
	print("[GameManager] 退出游戏")
	get_tree().quit()

#endregion

#region 设置管理

## 获取设置
func get_setting(key: String, default: Variant = null) -> Variant:
	return _settings.get(key, default)

## 设置设置
func set_setting(key: String, value: Variant) -> void:
	_settings[key] = value
	_apply_setting(key, value)
	_save_settings()

## 应用设置
func _apply_setting(key: String, value: Variant) -> void:
	match key:
		"master_volume", "bgm_volume", "sfx_volume":
			AudioManager.update_volumes()
		"language":
			# TODO: 实现语言切换
			pass

## 保存设置
func _save_settings() -> void:
	var config = ConfigFile.new()
	for key in _settings:
		config.set_value("settings", key, _settings[key])
	config.save("user://settings.cfg")

## 加载设置
func _load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		for key in _settings:
			var value = config.get_value("settings", key, _settings[key])
			_settings[key] = value

#endregion

#region 工具方法

## 获取游戏时间（秒）
func get_play_time() -> float:
	return _play_time

## 获取格式化游戏时间
func get_formatted_play_time() -> String:
	var total_seconds = int(_play_time)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

## 获取会话ID
func get_session_id() -> String:
	return _session_id

## 生成会话ID
func _generate_session_id() -> String:
	return "%d_%s" % [Time.get_unix_time_from_system(), str(randi()).sha256_text().substr(0, 8)]

## 状态转字符串
func _state_to_string(state: GameState) -> String:
	match state:
		GameState.MENU: return "MENU"
		GameState.PLAYING: return "PLAYING"
		GameState.PAUSED: return "PAUSED"
		GameState.DIALOG: return "DIALOG"
		GameState.CHOICE: return "CHOICE"
		GameState.LOADING: return "LOADING"
		GameState.CUTSCENE: return "CUTSCENE"
		_: return "UNKNOWN"

#endregion
