## 视频播放测试脚本
## 注意: Godot 4.x 的 Theora/OGV 格式无法获取视频时长，需要预设
extends Control

@onready var video_player: VideoStreamPlayer = $VideoContainer/VideoPlayer
@onready var video_progress: ProgressBar = $VideoContainer/VideoProgress
@onready var info_label: Label = $UIOverlay/InfoLabel
@onready var play_btn: Button = $UIOverlay/ControlPanel/PlayBtn
@onready var pause_btn: Button = $UIOverlay/ControlPanel/PauseBtn
@onready var stop_btn: Button = $UIOverlay/ControlPanel/StopBtn
@onready var replay_btn: Button = $UIOverlay/ControlPanel/ReplayBtn

# 视频配置 (包含预设时长)
var video_configs: Array[Dictionary] = [
	{
		"path": "res://assets/videos/ch1/sc_001/key_001.ogv",
		"name": "key_001 - 醒来过程",
		"duration": 10.0
	},
	{
		"path": "res://assets/videos/ch1/sc_001/key_002.ogv",
		"name": "key_002 - 观察房间",
		"duration": 10.0
	},
	{
		"path": "res://assets/videos/ch1/sc_001/key_003.ogv",
		"name": "key_003 - 发现物品",
		"duration": 10.0
	}
]
var current_video_index: int = -1
var video_start_time: float = 0.0

func _ready() -> void:
	print("[VideoTest] 初始化视频测试场景")

	# 连接按钮信号
	play_btn.pressed.connect(_on_play_pressed)
	pause_btn.pressed.connect(_on_pause_pressed)
	stop_btn.pressed.connect(_on_stop_pressed)
	replay_btn.pressed.connect(_on_replay_pressed)

	# 连接视频选择按钮
	var video_list = $UIOverlay/VideoList
	for i in range(min(3, video_configs.size())):
		var btn_name = "Video%dBtn" % (i + 1)
		var btn = video_list.get_node_or_null(btn_name)
		if btn:
			btn.pressed.connect(_on_video_selected.bind(i))

	# 连接视频播放器信号
	video_player.finished.connect(_on_video_finished)

	# 检查视频文件
	_check_video_files()

func _check_video_files() -> void:
	var found_count = 0
	for i in range(video_configs.size()):
		var path = video_configs[i]["path"]
		if ResourceLoader.exists(path):
			found_count += 1
			print("[VideoTest] 找到视频: %s" % path)
		else:
			print("[VideoTest] 视频不存在: %s" % path)

	info_label.text = "视频播放测试\n找到 %d/%d 个视频文件\n请从左侧选择视频" % [found_count, video_configs.size()]

func _process(_delta: float) -> void:
	# 更新进度条
	if video_player and video_player.is_playing() and current_video_index >= 0:
		var config = video_configs[current_video_index]
		var duration = config.get("duration", 10.0)
		var elapsed = Time.get_ticks_msec() / 1000.0 - video_start_time
		var progress = clamp(elapsed / duration, 0.0, 1.0)
		video_progress.value = progress * 100

func _on_video_selected(index: int) -> void:
	if index < 0 or index >= video_configs.size():
		return

	var config = video_configs[index]
	var path = config["path"]

	if not ResourceLoader.exists(path):
		info_label.text = "视频文件不存在:\n%s" % path
		return

	current_video_index = index

	# 加载视频
	var video_stream = load(path)
	if video_stream == null:
		info_label.text = "无法加载视频:\n%s" % path
		return

	video_player.stream = video_stream
	info_label.text = "已选择: %s\n点击播放按钮开始" % config["name"]
	print("[VideoTest] 加载视频: %s" % path)

func _on_play_pressed() -> void:
	if video_player.stream == null:
		info_label.text = "请先选择一个视频"
		return

	video_player.play()
	video_start_time = Time.get_ticks_msec() / 1000.0

	if current_video_index >= 0:
		info_label.text = "正在播放: %s" % video_configs[current_video_index]["name"]
	print("[VideoTest] 开始播放")

func _on_pause_pressed() -> void:
	video_player.paused = not video_player.paused
	if video_player.paused:
		info_label.text = "已暂停"
	else:
		if current_video_index >= 0:
			info_label.text = "正在播放: %s" % video_configs[current_video_index]["name"]

func _on_stop_pressed() -> void:
	video_player.stop()
	if current_video_index >= 0:
		info_label.text = "已停止: %s\n点击播放重新开始" % video_configs[current_video_index]["name"]
	video_progress.value = 0

func _on_replay_pressed() -> void:
	video_player.stop()
	video_player.play()
	video_start_time = Time.get_ticks_msec() / 1000.0

	if current_video_index >= 0:
		info_label.text = "重播: %s" % video_configs[current_video_index]["name"]

func _on_video_finished() -> void:
	if current_video_index >= 0:
		info_label.text = "播放完成: %s\n选择其他视频或点击重播" % video_configs[current_video_index]["name"]
	video_progress.value = 100
	print("[VideoTest] 视频播放完成")
