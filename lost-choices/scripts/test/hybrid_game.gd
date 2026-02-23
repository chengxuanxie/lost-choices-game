## 混合视觉游戏主场景
## 整合故事引擎、分支选择和混合视觉播放
## 提供完整的游戏游玩体验
extends Control

## 节点引用
@onready var hybrid_player: HybridScenePlayer = $HybridPlayer
@onready var subtitle_panel: PanelContainer = $SubtitlePanel
@onready var subtitle_label: Label = $SubtitlePanel/SubtitleLabel
@onready var choice_container: VBoxContainer = $ChoiceContainer
@onready var progress_bar: ProgressBar = $HUD/ProgressBar
@onready var chapter_label: Label = $HUD/ChapterLabel
@onready var pause_button: Button = $PauseButton

## 当前节点数据
var _current_node_data: Dictionary = {}
var _is_waiting_choice: bool = false

func _ready() -> void:
	_setup_signals()
	_setup_hybrid_player()
	_start_demo_chapter()

func _setup_signals() -> void:
	# 连接故事引擎信号
	StoryEngine.node_changed.connect(_on_node_changed)
	StoryEngine.choices_available.connect(_on_choices_available)
	StoryEngine.choice_made.connect(_on_choice_made)
	StoryEngine.story_ended.connect(_on_story_ended)

	# 连接混合播放器信号
	hybrid_player.scene_completed.connect(_on_scene_completed)
	hybrid_player.segment_changed.connect(_on_segment_changed)

	# 连接暂停按钮
	pause_button.pressed.connect(_on_pause_pressed)

func _setup_hybrid_player() -> void:
	"""初始化混合播放器"""
	hybrid_player.load_scene({"segments": []})

func _start_demo_chapter() -> void:
	"""开始演示章节"""
	# 检查是否存在混合视觉章节数据
	var hybrid_chapter_path = "res://data/stories/chapter_01_hybrid.json"
	if ResourceLoader.exists(hybrid_chapter_path):
		StoryEngine.start_chapter("chapter_01_hybrid")
	else:
		# 使用内置演示数据
		_run_builtin_demo()

func _run_builtin_demo() -> void:
	"""运行内置演示（无需外部JSON）"""
	print("[HybridGame] 运行内置演示场景")

	chapter_label.text = "第一章：觉醒 (演示)"

	# 演示第一个节点
	_play_hybrid_node("demo_001", _get_demo_node_001())

#region 混合节点播放

func _play_hybrid_node(node_id: String, node_data: Dictionary) -> void:
	"""播放混合视觉节点"""
	_current_node_data = node_data
	_is_waiting_choice = false

	print("[HybridGame] 播放混合节点: %s" % node_id)

	# 更新字幕
	var subtitle = node_data.get("subtitle", "")
	_show_subtitle(subtitle)

	# 构建混合场景配置
	var scene_config = _build_hybrid_config(node_data)

	# 加载并播放
	hybrid_player.load_scene(scene_config)
	hybrid_player.play()

func _build_hybrid_config(node_data: Dictionary) -> Dictionary:
	"""根据节点数据构建混合场景配置"""
	var segments: Array = []

	# 添加关键帧片段
	var keyframes = node_data.get("keyframes", {})
	if not keyframes.is_empty():
		var frames = keyframes.get("frames", [])
		var durations = keyframes.get("durations", [])
		var effects = keyframes.get("effects", {})

		for i in range(frames.size()):
			var frame_path = frames[i]
			var duration = durations[i] if i < durations.size() else 5.0

			segments.append({
				"id": "kf_%03d" % i,
				"type": "keyframe",
				"duration": duration,
				"frames": [frame_path],
				"durations": [duration],
				"effects": effects
			})

	# 添加视频片段
	var video = node_data.get("video", {})
	if not video.is_empty():
		var video_path = video.get("path", "")
		var video_duration = video.get("duration", 10.0)

		if not video_path.is_empty():
			segments.append({
				"id": "video_main",
				"type": "video",
				"duration": video_duration,
				"path": video_path
			})

	return {
		"scene_id": node_data.get("node_id", "unknown"),
		"name": node_data.get("scene", "未知场景"),
		"segments": segments,
		"total_duration": _calculate_total_duration(segments)
	}

func _calculate_total_duration(segments: Array) -> float:
	var total := 0.0
	for seg in segments:
		total += seg.get("duration", 5.0)
	return total

#endregion

#region 选择系统

func _show_choices(choices: Array) -> void:
	"""显示选择按钮"""
	_is_waiting_choice = true
	choice_container.visible = true

	# 清除旧按钮
	for child in choice_container.get_children():
		child.queue_free()

	# 创建新按钮
	for i in range(choices.size()):
		var choice = choices[i]
		var button = _create_choice_button(choice, i)
		choice_container.add_child(button)

func _create_choice_button(choice: Dictionary, index: int) -> Button:
	var button = Button.new()
	button.text = choice.get("text", "选项")

	# 设置按钮样式
	button.custom_minimum_size = Vector2(500, 50)

	# 检查条件
	var conditions = choice.get("conditions", [])
	var is_locked = not _check_conditions(conditions)

	if is_locked:
		button.disabled = true
		button.text = "[锁定] " + button.text

	button.pressed.connect(func(): _on_choice_button_pressed(index))

	return button

func _check_conditions(conditions: Array) -> bool:
	for condition in conditions:
		var cond_type = condition.get("type", "")
		match cond_type:
			"flag":
				var key = condition.get("key", "")
				var value = condition.get("value", true)
				if GameStateManager.get_flag(key) != value:
					return false
			"variable":
				var key = condition.get("key", "")
				var op = condition.get("operator", ">=")
				var val = condition.get("value", 0)
				var actual = GameStateManager.get_variable(key, 0)
				if not _compare(actual, op, val):
					return false
	return true

func _compare(actual: Variant, op: String, expected: Variant) -> bool:
	match op:
		"==": return actual == expected
		"!=": return actual != expected
		">": return actual > expected
		">=": return actual >= expected
		"<": return actual < expected
		"<=": return actual <= expected
		_: return false

func _on_choice_button_pressed(index: int) -> void:
	"""选择按钮点击回调"""
	choice_container.visible = false
	_is_waiting_choice = false

	var choices = _current_node_data.get("choices", [])
	if index >= 0 and index < choices.size():
		var choice = choices[index]

		# 应用效果
		_apply_effects(choice.get("effects", []))

		# 跳转到下一个节点
		var next_node = choice.get("next_node", "")
		if not next_node.is_empty():
			_handle_node_transition(next_node)

func _apply_effects(effects: Array) -> void:
	for effect in effects:
		var effect_type = effect.get("type", "")
		match effect_type:
			"set_flag":
				GameStateManager.set_flag(effect.get("key", ""), effect.get("value", true))
			"modify_relationship":
				GameStateManager.modify_relationship(
					effect.get("character", ""),
					effect.get("value", 0)
				)
			"set_variable":
				GameStateManager.set_variable(effect.get("key", ""), effect.get("value", 0))

#endregion

#region 节点过渡

func _handle_node_transition(next_node_id: String) -> void:
	"""处理节点过渡"""
	print("[HybridGame] 过渡到节点: %s" % next_node_id)

	# 演示模式：使用内置节点
	match next_node_id:
		"demo_001":
			_play_hybrid_node("demo_001", _get_demo_node_001())
		"demo_002a":
			_play_hybrid_node("demo_002a", _get_demo_node_002a())
		"demo_002b":
			_play_hybrid_node("demo_002b", _get_demo_node_002b())
		"demo_003":
			_play_hybrid_node("demo_003", _get_demo_node_003())
		"demo_ending":
			_show_ending("demo_ending", "演示结束")
		_:
			push_warning("[HybridGame] 未知节点: %s" % next_node_id)
			_show_ending("unknown", "未知结局")

#endregion

#region 字幕系统

func _show_subtitle(text: String) -> void:
	if text.is_empty():
		subtitle_panel.visible = false
	else:
		subtitle_label.text = text
		subtitle_panel.visible = true

#endregion

#region 回调函数

func _on_node_changed(node_id: String, node_data: Dictionary) -> void:
	print("[HybridGame] 节点变更: %s" % node_id)
	_play_hybrid_node(node_id, node_data)

func _on_choices_available(choices: Array) -> void:
	_show_choices(choices)

func _on_choice_made(choice_id: String, choice_data: Dictionary) -> void:
	print("[HybridGame] 做出选择: %s" % choice_id)

func _on_story_ended(ending_id: String) -> void:
	_show_ending(ending_id, "故事结束")

func _on_scene_completed() -> void:
	"""场景播放完成"""
	print("[HybridGame] 场景播放完成")

	# 检查是否有选择
	var choices = _current_node_data.get("choices", [])
	if choices.size() > 0:
		_show_choices(choices)
	else:
		# 检查是否有自动跳转
		var auto_next = _current_node_data.get("auto_next", "")
		if not auto_next.is_empty():
			_handle_node_transition(auto_next)
		else:
			# 显示选择或等待
			_show_subtitle("点击继续...")

func _on_segment_changed(segment_index: int, segment_type: String) -> void:
	"""片段变更"""
	var segments = hybrid_player._segments
	if segment_index >= 0 and segment_index < segments.size():
		var seg = segments[segment_index]
		print("[HybridGame] 片段 %d/%d: %s (%s)" % [
			segment_index + 1,
			segments.size(),
			seg.get("name", ""),
			"视频" if segment_type == "video" else "关键帧"
		])

func _on_pause_pressed() -> void:
	if hybrid_player._is_playing:
		hybrid_player.pause()
	else:
		hybrid_player.resume()

#endregion

#region 结局显示

func _show_ending(ending_id: String, ending_name: String) -> void:
	"""显示结局"""
	print("[HybridGame] 达成结局: %s" % ending_name)

	hybrid_player.stop()
	choice_container.visible = false

	_show_subtitle("【%s】\n感谢游玩演示版本！" % ending_name)

#endregion

#region 内置演示数据

func _get_demo_node_001() -> Dictionary:
	"""演示节点001 - 神秘房间醒来"""
	return {
		"node_id": "demo_001",
		"scene": "SC-001 神秘房间",
		"subtitle": "你在陌生的房间中醒来，头痛欲裂...",
		"keyframes": {
			"frames": [
				"res://assets/keyframes/ch1/sc_001/frame_001.png",
				"res://assets/keyframes/ch1/sc_001/frame_002.png",
				"res://assets/keyframes/ch1/sc_001/frame_003.png"
			],
			"durations": [4.0, 4.0, 4.0],
			"effects": {"parallax": true, "zoom": true, "flicker": true, "vignette": true}
		},
		"video": {
			"path": "res://assets/videos/ch1/sc_001/key_001.ogv",
			"duration": 10.0
		},
		"choices": [
			{
				"id": "choice_trust",
				"text": "冷静下来，观察周围环境",
				"effects": [
					{"type": "set_flag", "key": "calm_response", "value": true}
				],
				"next_node": "demo_002a"
			},
			{
				"id": "choice_panic",
				"text": "试图回忆自己是怎么到这里的",
				"effects": [
					{"type": "set_flag", "key": "panic_response", "value": true},
					{"type": "modify_relationship", "character": "mystery_voice", "value": -5}
				],
				"next_node": "demo_002b"
			}
		]
	}

func _get_demo_node_002a() -> Dictionary:
	"""演示节点002a - 冷静探索"""
	return {
		"node_id": "demo_002a",
		"scene": "SC-002 冷静探索",
		"subtitle": "你发现床头柜上有一张纸条...",
		"keyframes": {
			"frames": [
				"res://assets/keyframes/ch1/sc_001/frame_004.png"
			],
			"durations": [6.0],
			"effects": {"parallax": false, "zoom": true, "flicker": false, "vignette": false}
		},
		"video": {
			"path": "res://assets/videos/ch1/sc_001/key_002.ogv",
			"duration": 10.0
		},
		"auto_next": "demo_003"
	}

func _get_demo_node_002b() -> Dictionary:
	"""演示节点002b - 恐慌回忆"""
	return {
		"node_id": "demo_002b",
		"scene": "SC-002 恐慌回忆",
		"subtitle": "记忆碎片闪过脑海...但什么都抓不住",
		"keyframes": {
			"frames": [
				"res://assets/keyframes/ch1/sc_001/frame_001.png",
				"res://assets/keyframes/ch1/sc_001/frame_003.png"
			],
			"durations": [3.0, 5.0],
			"effects": {"parallax": true, "zoom": false, "flicker": true, "vignette": true}
		},
		"auto_next": "demo_003"
	}

func _get_demo_node_003() -> Dictionary:
	"""演示节点003 - 发现纸条"""
	return {
		"node_id": "demo_003",
		"scene": "SC-003 发现线索",
		"subtitle": "纸条上写着：'相信她，她会带你找到真相'",
		"keyframes": {
			"frames": [
				"res://assets/keyframes/ch1/sc_001/frame_004.png"
			],
			"durations": [5.0],
			"effects": {"parallax": false, "zoom": true, "flicker": false, "vignette": false}
		},
		"video": {
			"path": "res://assets/videos/ch1/sc_001/key_003.ogv",
			"duration": 10.0
		},
		"choices": [
			{
				"id": "choice_trust_her",
				"text": "相信纸条上的话",
				"effects": [
					{"type": "set_flag", "key": "trust_note", "value": true}
				],
				"next_node": "demo_ending"
			},
			{
				"id": "choice_doubt",
				"text": "这可能是个陷阱...",
				"effects": [
					{"type": "set_flag", "key": "doubt_note", "value": true}
				],
				"next_node": "demo_ending"
			}
		]
	}

#endregion

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_pause_pressed()
