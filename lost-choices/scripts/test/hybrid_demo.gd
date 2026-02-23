## 混合视觉方案演示场景
## 展示关键帧动画和短视频的混合播放效果
extends Control

## 场景节点引用
@onready var hybrid_player: HybridScenePlayer = $HybridPlayer
@onready var info_label: Label = $UIOverlay/InfoPanel/VBox/InfoLabel
@onready var progress_bar: ProgressBar = $UIOverlay/InfoPanel/VBox/ProgressBar
@onready var segment_label: Label = $UIOverlay/InfoPanel/VBox/SegmentLabel
@onready var play_btn: Button = $UIOverlay/ControlPanel/PlayBtn
@onready var pause_btn: Button = $UIOverlay/ControlPanel/PauseBtn
@onready var stop_btn: Button = $UIOverlay/ControlPanel/StopBtn
@onready var skip_btn: Button = $UIOverlay/ControlPanel/SkipBtn
@onready var warning_label: Label = $UIOverlay/WarningLabel

## 配置
var scene_config: Dictionary = {}
var config_path: String = "res://assets/configs/scenes/ch1_sc_001_demo.json"

func _ready() -> void:
	print("[HybridDemo] 初始化混合视觉演示场景")
	_connect_signals()
	_setup_buttons()
	_load_scene_config()
	_check_assets()

func _connect_signals() -> void:
	# 连接HybridScenePlayer信号
	hybrid_player.scene_completed.connect(_on_scene_completed)
	hybrid_player.segment_changed.connect(_on_segment_changed)

func _setup_buttons() -> void:
	play_btn.pressed.connect(_on_play_pressed)
	pause_btn.pressed.connect(_on_pause_pressed)
	stop_btn.pressed.connect(_on_stop_pressed)
	skip_btn.pressed.connect(_on_skip_pressed)

func _load_scene_config() -> void:
	if not ResourceLoader.exists(config_path):
		info_label.text = "配置文件不存在:\n%s" % config_path
		push_error("[HybridDemo] 配置文件不存在: %s" % config_path)
		return

	var file = FileAccess.open(config_path, FileAccess.READ)
	if file == null:
		info_label.text = "无法读取配置文件"
		return

	var json_text = file.get_as_text()
	file.close()

	var json = JSON.new()
	var error = json.parse(json_text)
	if error != OK:
		info_label.text = "JSON解析错误:\n%s" % json.get_error_message()
		return

	scene_config = json.data
	hybrid_player.load_scene(scene_config)

	info_label.text = "场景已加载: %s\n共 %d 个片段\n点击播放开始" % [
		scene_config.get("name", "未知场景"),
		scene_config.get("segments", []).size()
	]

	print("[HybridDemo] 场景配置加载成功: %s" % scene_config.get("name"))

func _check_assets() -> void:
	"""检查资产文件是否存在"""
	var segments = scene_config.get("segments", [])
	var missing_assets: Array = []

	for seg in segments:
		var seg_type = seg.get("type", "keyframe")

		if seg_type == "video":
			var video_path = seg.get("path", "")
			if not video_path.is_empty() and not ResourceLoader.exists(video_path):
				missing_assets.append("视频: %s" % video_path.get_file())

		elif seg_type == "keyframe":
			var frames = seg.get("frames", [])
			for frame_path in frames:
				if not ResourceLoader.exists(frame_path):
					missing_assets.append("关键帧: %s" % frame_path.get_file())

	if missing_assets.size() > 0:
		var warning_text = "缺失资产:\n" + "\n".join(missing_assets)
		print("[HybridDemo] %s" % warning_text)
		# 显示警告但不阻止运行
		if warning_label:
			warning_label.text = "警告: %d 个资产缺失" % missing_assets.size()
			warning_label.visible = true

func _process(_delta: float) -> void:
	if hybrid_player._is_playing:
		var progress = hybrid_player.get_progress()
		progress_bar.value = progress * 100

#region 按钮回调

func _on_play_pressed() -> void:
	if scene_config.is_empty():
		info_label.text = "请先加载场景配置"
		return

	hybrid_player.play()
	info_label.text = "正在播放..."
	play_btn.disabled = true
	pause_btn.disabled = false
	stop_btn.disabled = false

	print("[HybridDemo] 开始播放")

func _on_pause_pressed() -> void:
	if hybrid_player._is_playing:
		hybrid_player.pause()
		info_label.text = "已暂停"
		pause_btn.text = "继续"
		print("[HybridDemo] 已暂停")
	else:
		hybrid_player.resume()
		info_label.text = "正在播放..."
		pause_btn.text = "暂停"
		print("[HybridDemo] 继续播放")

func _on_stop_pressed() -> void:
	hybrid_player.stop()
	info_label.text = "已停止\n点击播放重新开始"
	progress_bar.value = 0
	segment_label.text = ""
	play_btn.disabled = false
	pause_btn.disabled = true
	pause_btn.text = "暂停"
	stop_btn.disabled = true

	print("[HybridDemo] 已停止")

func _on_skip_pressed() -> void:
	"""跳过当前片段"""
	if hybrid_player._current_segment < hybrid_player._segments.size() - 1:
		hybrid_player._advance_segment()
		print("[HybridDemo] 跳过当前片段")

#endregion

#region HybridScenePlayer回调

func _on_segment_changed(segment_index: int, segment_type: String) -> void:
	var segments = scene_config.get("segments", [])
	if segment_index >= 0 and segment_index < segments.size():
		var seg = segments[segment_index]
		segment_label.text = "片段 %d/%d: %s (%s)" % [
			segment_index + 1,
			segments.size(),
			seg.get("name", "未知"),
			"视频" if segment_type == "video" else "关键帧"
		]

func _on_scene_completed() -> void:
	info_label.text = "场景播放完成!\n点击播放重新开始"
	progress_bar.value = 100
	play_btn.disabled = false
	pause_btn.disabled = true
	stop_btn.disabled = true

	print("[HybridDemo] 场景播放完成")

#endregion
