## 关键帧场景测试脚本
extends Control

@onready var keyframe_scene: KeyframeScene = $KeyframeScene
@onready var progress_bar: ProgressBar = $UIOverlay/ProgressBar
@onready var info_label: Label = $UIOverlay/InfoLabel
@onready var play_btn: Button = $UIOverlay/ControlPanel/PlayBtn
@onready var pause_btn: Button = $UIOverlay/ControlPanel/PauseBtn
@onready var stop_btn: Button = $UIOverlay/ControlPanel/StopBtn
@onready var shader_toggle: CheckButton = $UIOverlay/ControlPanel/ShaderToggle

# 测试关键帧配置
var test_durations: Array[float] = [4.0, 5.0, 5.0, 4.0]

func _ready() -> void:
	print("[KeyframeTest] 初始化测试场景")

	# 连接按钮信号
	play_btn.pressed.connect(_on_play_pressed)
	pause_btn.pressed.connect(_on_pause_pressed)
	stop_btn.pressed.connect(_on_stop_pressed)
	shader_toggle.toggled.connect(_on_shader_toggled)

	# 加载测试关键帧
	_load_test_keyframes()

func _load_test_keyframes() -> void:
	# 直接加载已知的关键帧文件
	var frame_paths = [
		"res://assets/keyframes/ch1/sc_001/frame_001.png",
		"res://assets/keyframes/ch1/sc_001/frame_002.png",
		"res://assets/keyframes/ch1/sc_001/frame_003.png",
		"res://assets/keyframes/ch1/sc_001/frame_004.png"
	]

	var loaded_count = 0
	var frames: Array[Texture2D] = []

	for path in frame_paths:
		if ResourceLoader.exists(path):
			var texture = load(path)
			if texture is Texture2D:
				frames.append(texture)
				loaded_count += 1
				print("[KeyframeTest] 加载关键帧: %s" % path)

	if loaded_count > 0:
		keyframe_scene.set_keyframes(frames, test_durations)
		# 连接关键帧场景信号
		if not keyframe_scene.frame_changed.is_connected(_on_frame_changed):
			keyframe_scene.frame_changed.connect(_on_frame_changed)
		if not keyframe_scene.scene_completed.is_connected(_on_scene_completed):
			keyframe_scene.scene_completed.connect(_on_scene_completed)

		info_label.text = "已加载关键帧: %d 张\n按空格播放/暂停" % loaded_count
		print("[KeyframeTest] 成功加载 %d 个关键帧" % loaded_count)
	else:
		# 创建占位符纹理用于测试
		_create_placeholder_keyframes()
		info_label.text = "使用占位符测试\n按空格播放/暂停"

func _create_placeholder_keyframes() -> void:
	print("[KeyframeTest] 创建占位符关键帧")

	var frames: Array[Texture2D] = []
	var colors = [
		Color(0.1, 0.1, 0.2),   # 深蓝
		Color(0.15, 0.12, 0.2), # 紫色
		Color(0.12, 0.15, 0.2), # 蓝灰
		Color(0.2, 0.15, 0.1),  # 暖色
	]

	for i in range(4):
		var image = Image.create(640, 360, false, Image.FORMAT_RGBA8)
		var color = colors[i]
		image.fill(color)

		# 添加一些变化（使用较大的采样间隔）
		for x in range(0, 640, 8):
			for y in range(0, 360, 8):
				var noise = randf() * 0.05
				var c = Color(
					clamp(color.r + noise, 0.0, 1.0),
					clamp(color.g + noise, 0.0, 1.0),
					clamp(color.b + noise, 0.0, 1.0),
					1.0
				)
				image.set_pixel(x, y, c)

		# 添加帧编号文字
		var text = "Frame %d" % (i + 1)

		var texture = ImageTexture.create_from_image(image)
		frames.append(texture)

	keyframe_scene.set_keyframes(frames, test_durations)

	# 连接信号
	if not keyframe_scene.frame_changed.is_connected(_on_frame_changed):
		keyframe_scene.frame_changed.connect(_on_frame_changed)
	if not keyframe_scene.scene_completed.is_connected(_on_scene_completed):
		keyframe_scene.scene_completed.connect(_on_scene_completed)

func _process(_delta: float) -> void:
	# 更新进度条
	progress_bar.value = keyframe_scene.get_progress() * 100

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):  # 空格键
		if keyframe_scene._is_playing:
			keyframe_scene.pause()
		else:
			keyframe_scene.play()

func _on_play_pressed() -> void:
	keyframe_scene.play()

func _on_pause_pressed() -> void:
	keyframe_scene.pause()

func _on_stop_pressed() -> void:
	keyframe_scene.stop()

func _on_shader_toggled(enabled: bool) -> void:
	keyframe_scene.use_parallax = enabled
	keyframe_scene.use_zoom = enabled
	keyframe_scene.use_light_flicker = enabled
	keyframe_scene.use_vignette = enabled
	# 需要重新设置场景以应用着色器更改
	var current_frame = keyframe_scene.get_current_frame()
	keyframe_scene._is_setup = false
	keyframe_scene._setup_scene()
	if current_frame >= 0 and current_frame < keyframe_scene.get_frame_count():
		keyframe_scene.seek_to_frame(current_frame)

func _on_frame_changed(frame_index: int) -> void:
	info_label.text = "当前帧: %d / %d\n按空格播放/暂停" % [frame_index + 1, keyframe_scene.get_frame_count()]

func _on_scene_completed() -> void:
	info_label.text = "场景播放完成\n按空格重新播放"
