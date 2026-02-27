## 混合场景播放器
## 统一管理关键帧序列和短视频播放
class_name HybridScenePlayer
extends Control

## 信号
signal scene_completed()
signal segment_changed(segment_index: int, segment_type: String)

## 配置
@export_group("场景配置")
@export var scene_config: Dictionary = {}

## 内部状态
var _current_segment: int = 0
var _is_playing: bool = false
var _segments: Array = []
var _keyframe_scene: KeyframeScene = null
var _video_player: VideoStreamPlayer = null
var _play_start_time: float = 0.0

func _ready() -> void:
	_setup_players()

func _setup_players() -> void:
	# 创建关键帧场景组件
	_keyframe_scene = KeyframeScene.new()
	_keyframe_scene.name = "KeyframeScene"
	_keyframe_scene.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_keyframe_scene)

	# 创建视频播放器
	_video_player = VideoStreamPlayer.new()
	_video_player.name = "VideoPlayer"
	_video_player.set_anchors_preset(Control.PRESET_FULL_RECT)
	_video_player.visible = false
	_video_player.bus = "Master"  # 使用 Master 总线以便控制音量
	add_child(_video_player)

	# 连接信号
	_keyframe_scene.scene_completed.connect(_on_keyframe_completed)
	_video_player.finished.connect(_on_video_completed)

## 加载场景配置
func load_scene(config: Dictionary) -> void:
	scene_config = config
	_segments = config.get("segments", [])
	_current_segment = 0
	_is_playing = false

	print("[HybridScenePlayer] 加载场景，共 %d 个片段" % _segments.size())

## 播放场景
func play() -> void:
	if _segments.is_empty():
		push_warning("[HybridScenePlayer] 没有场景片段可播放")
		return

	_is_playing = true
	_current_segment = 0
	_play_segment(0)

## 暂停
func pause() -> void:
	_is_playing = false
	if _keyframe_scene and _keyframe_scene._is_playing:
		_keyframe_scene.pause()
	if _video_player and _video_player.is_playing():
		_video_player.paused = true

## 继续
func resume() -> void:
	_is_playing = true
	if _keyframe_scene and _keyframe_scene.keyframes.size() > 0:
		_keyframe_scene.resume()
	if _video_player and _video_player.paused:
		_video_player.paused = false

## 停止
func stop() -> void:
	_is_playing = false
	_current_segment = 0
	_keyframe_scene.stop()
	_video_player.stop()
	_video_player.visible = false

## 获取播放进度
func get_progress() -> float:
	if _segments.is_empty():
		return 0.0

	var total_duration = 0.0
	var elapsed = 0.0

	for i in range(_segments.size()):
		var seg = _segments[i]
		var duration = seg.get("duration", 5.0)

		if i < _current_segment:
			elapsed += duration
		elif i == _current_segment:
			var seg_progress = _get_segment_progress()
			elapsed += duration * seg_progress

		total_duration += duration

	return elapsed / total_duration if total_duration > 0 else 0.0

## 获取当前片段进度
func _get_segment_progress() -> float:
	if _current_segment >= _segments.size():
		return 1.0

	var seg = _segments[_current_segment]
	var seg_type = seg.get("type", "keyframe")
	var duration = seg.get("duration", 5.0)

	if seg_type == "video":
		if _video_player.stream and duration > 0:
			return (Time.get_ticks_msec() / 1000.0 - _play_start_time) / duration
	else:
		return _keyframe_scene.get_progress()

	return 0.0

## 播放指定片段
func _play_segment(index: int) -> void:
	if index >= _segments.size():
		_on_scene_completed()
		return

	var seg = _segments[index]
	var seg_type = seg.get("type", "keyframe")

	print("[HybridScenePlayer] 播放片段 %d: %s" % [index, seg_type])

	segment_changed.emit(index, seg_type)

	if seg_type == "video":
		_play_video_segment(seg)
	else:
		_play_keyframe_segment(seg)

## 播放视频片段
func _play_video_segment(seg: Dictionary) -> void:
	_video_player.visible = true
	_keyframe_scene.visible = false

	print("[HybridScenePlayer] 视频播放器 visible=%s, size=%s" % [_video_player.visible, _video_player.size])

	var video_path = seg.get("path", "")
	if video_path.is_empty() or not ResourceLoader.exists(video_path):
		push_warning("[HybridScenePlayer] 视频不存在: %s" % video_path)
		_advance_segment()
		return

	var video_stream = load(video_path)
	if video_stream == null:
		push_warning("[HybridScenePlayer] 无法加载视频: %s" % video_path)
		_advance_segment()
		return

	_video_player.stream = video_stream
	_video_player.play()
	_play_start_time = Time.get_ticks_msec() / 1000.0
	print("[HybridScenePlayer] 视频播放中: %s" % video_path)

## 播放关键帧片段
func _play_keyframe_segment(seg: Dictionary) -> void:
	_video_player.visible = false
	_keyframe_scene.visible = true

	var frames = seg.get("frames", [])
	var durations = seg.get("durations", [])

	if frames.is_empty():
		push_warning("[HybridScenePlayer] 关键帧片段没有帧数据")
		_advance_segment()
		return

	# 加载关键帧纹理
	var textures: Array[Texture2D] = []
	for frame_path in frames:
		if ResourceLoader.exists(frame_path):
			var tex = load(frame_path)
			if tex is Texture2D:
				textures.append(tex)
			else:
				push_warning("[HybridScenePlayer] 无法加载纹理: %s" % frame_path)
		else:
			push_warning("[HybridScenePlayer] 关键帧文件不存在: %s" % frame_path)

	if textures.is_empty():
		push_warning("[HybridScenePlayer] 无法加载关键帧")
		_advance_segment()
		return

	# 配置着色器效果
	var effects = seg.get("effects", {})
	_keyframe_scene.use_parallax = effects.get("parallax", true)
	_keyframe_scene.use_zoom = effects.get("zoom", true)
	_keyframe_scene.use_light_flicker = effects.get("flicker", true)
	_keyframe_scene.use_vignette = effects.get("vignette", true)

	# 设置关键帧
	var float_durations: Array[float] = []
	for d in durations:
		float_durations.append(float(d))

	_keyframe_scene._is_setup = false
	_keyframe_scene.set_keyframes(textures, float_durations)
	_keyframe_scene.play()

## 前进到下一片段
func _advance_segment() -> void:
	_current_segment += 1
	_play_segment(_current_segment)

## 视频播放完成
func _on_video_completed() -> void:
	if _is_playing:
		_advance_segment()

## 关键帧播放完成
func _on_keyframe_completed() -> void:
	if _is_playing:
		_advance_segment()

## 场景播放完成
func _on_scene_completed() -> void:
	_is_playing = false
	scene_completed.emit()
	print("[HybridScenePlayer] 场景播放完成")

## 从JSON配置创建场景
static func create_from_config(config: Dictionary) -> HybridScenePlayer:
	var player = HybridScenePlayer.new()
	player.load_scene(config)
	return player

#region 公共访问方法

## 获取片段列表
func get_segments() -> Array:
	return _segments.duplicate()

## 获取当前片段索引
func get_current_segment_index() -> int:
	return _current_segment

## 获取片段总数
func get_segment_count() -> int:
	return _segments.size()

## 是否正在播放
func is_playing() -> bool:
	return _is_playing

## 获取当前片段数据
func get_current_segment() -> Dictionary:
	if _current_segment >= 0 and _current_segment < _segments.size():
		return _segments[_current_segment]
	return {}

#endregion
