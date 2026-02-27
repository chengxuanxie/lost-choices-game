## 音频管理器 - 负责音频播放管理
@warning_ignore("static_called_on_instance")
extends Node

## 信号
signal volume_changed(bus: String, value: float)

## 音频总线名称
const BUS_MASTER: String = "Master"
const BUS_BGM: String = "BGM"
const BUS_SFX: String = "SFX"

## 状态
var _current_bgm: String = ""
var _bgm_player: AudioStreamPlayer
var _is_muted: bool = false

#region 初始化

func _ready() -> void:
	_bgm_player = AudioStreamPlayer.new()
	_bgm_player.bus = BUS_BGM
	add_child(_bgm_player)
	# 初始化音量设置
	update_volumes()
	print("[AudioManager] 音频管理器初始化完成")

#endregion

#region 音量控制

## 更新音量
func update_volumes() -> void:
	var master_vol = GameManager.get_setting("master_volume", 1.0)
	var bgm_vol = GameManager.get_setting("bgm_volume", 0.8)
	var sfx_vol = GameManager.get_setting("sfx_volume", 1.0)

	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_MASTER),
		linear_to_db(master_vol)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_BGM),
		linear_to_db(bgm_vol)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index(BUS_SFX),
		linear_to_db(sfx_vol)
	)

## 设置音量
func set_volume(bus: String, value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus)
	if bus_index >= 0:
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		volume_changed.emit(bus, value)

## 设置BGM音量
func set_bgm_volume(value: float) -> void:
	set_volume(BUS_BGM, value)

## 设置SFX音量
func set_sfx_volume(value: float) -> void:
	set_volume(BUS_SFX, value)

## 设置静音
func set_mute(muted: bool) -> void:
	_is_muted = muted
	var bus_index = AudioServer.get_bus_index(BUS_MASTER)
	if bus_index >= 0:
		AudioServer.set_bus_mute(bus_index, muted)

## 是否静音
func is_muted() -> bool:
	return _is_muted

#endregion

#region BGM播放

## 播放BGM
func play_bgm(resource_path: String, fade_duration: float = 1.0) -> void:
	if _current_bgm == resource_path:
		return

	# 淡出当前BGM
	if _bgm_player.playing:
		await _fade_out(fade_duration / 2)

	# 加载并播放新BGM
	var stream = load(resource_path)
	if stream:
		_bgm_player.stream = stream
		_bgm_player.play()
		_fade_in(fade_duration / 2)
		_current_bgm = resource_path
		print("[AudioManager] 播放BGM: %s" % resource_path)

## 停止BGM
func stop_bgm(fade_duration: float = 1.0) -> void:
	if _bgm_player.playing:
		await _fade_out(fade_duration)
		_bgm_player.stop()
		_current_bgm = ""

## 淡入
func _fade_in(duration: float) -> void:
	var target_volume = GameManager.get_setting("bgm_volume", 0.8)
	var tween = create_tween()
	tween.tween_method(_set_bgm_volume, 0.0, target_volume, duration)
	await tween.finished

## 淡出
func _fade_out(duration: float) -> void:
	var current_volume = GameManager.get_setting("bgm_volume", 0.8)
	var tween = create_tween()
	tween.tween_method(_set_bgm_volume, current_volume, 0.0, duration)
	await tween.finished

func _set_bgm_volume(value: float) -> void:
	_bgm_player.volume_db = linear_to_db(value)

#endregion

#region SFX播放

## 播放音效
func play_sfx(resource_path: String) -> void:
	var stream = load(resource_path)
	if stream:
		var player = AudioStreamPlayer.new()
		player.stream = stream
		player.bus = BUS_SFX
		add_child(player)
		player.play()
		player.finished.connect(player.queue_free)

#endregion
