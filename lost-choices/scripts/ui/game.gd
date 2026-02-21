## 游戏主场景脚本
extends Control

# 节点引用
@onready var video_player: VideoStreamPlayer = $VideoContainer/VideoPlayer
@onready var subtitle_label: Label = $SubtitlePanel/SubtitleLabel
@onready var subtitle_panel: PanelContainer = $SubtitlePanel
@onready var choice_container: VBoxContainer = $ChoiceContainer
@onready var pause_button: Button = $PauseButton

func _ready() -> void:
	# 设置视频播放器
	VideoManager.set_video_player(video_player)

	# 连接信号
	StoryEngine.node_changed.connect(_on_node_changed)
	StoryEngine.choices_available.connect(_on_choices_available)
	StoryEngine.story_ended.connect(_on_story_ended)
	VideoManager.video_completed.connect(_on_video_completed)

	pause_button.pressed.connect(_on_pause_pressed)

	# 隐藏字幕面板
	subtitle_panel.visible = false

	# 开始第一章
	StoryEngine.start_chapter("chapter_01")

func _on_node_changed(node_id: String, node_data: Dictionary) -> void:
	print("[Game] 节点变更: %s" % node_id)

	# 更新字幕
	var subtitles = node_data.get("subtitles", [])
	if subtitles.size() > 0:
		_setup_subtitles(subtitles)

func _on_choices_available(choices: Array) -> void:
	# 显示选择按钮
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

	# 添加提示
	var hint = choice.get("hint", "")
	if not hint.is_empty():
		button.text += " (%s)" % hint

	# 检查是否锁定
	var conditions = choice.get("conditions", [])
	var is_locked = not _check_all_conditions(conditions)

	if is_locked:
		button.disabled = true
		button.text = "[锁定] " + button.text

	button.pressed.connect(func(): _on_choice_selected(index))

	return button

func _on_choice_selected(index: int) -> void:
	choice_container.visible = false
	StoryEngine.make_choice(index)

func _on_video_completed(video_id: String) -> void:
	# 检查是否有自动跳转
	var node_data = StoryEngine.get_node_data(StoryEngine.get_current_node())
	var auto_next = node_data.get("auto_next", "")

	if not auto_next.is_empty():
		StoryEngine.jump_to_node(auto_next)

func _on_story_ended(ending_id: String) -> void:
	print("[Game] 故事结束: %s" % ending_id)
	# TODO: 显示结局界面

func _on_pause_pressed() -> void:
	GameManager.pause_game()
	# TODO: 显示暂停菜单

func _setup_subtitles(subtitles: Array) -> void:
	if subtitles.is_empty():
		subtitle_panel.visible = false
		return

	subtitle_panel.visible = true

	# 根据视频时间显示字幕
	for subtitle in subtitles:
		var start_time = subtitle.get("time_start", 0.0)
		var end_time = subtitle.get("time_end", 0.0)
		var text = subtitle.get("text", "")

		# 使用await等待到字幕开始时间
		await get_tree().create_timer(start_time).timeout

		subtitle_label.text = text

		# 等待字幕结束
		await get_tree().create_timer(end_time - start_time).timeout

		subtitle_label.text = ""

func _check_all_conditions(conditions: Array) -> bool:
	for condition in conditions:
		var condition_type = condition.get("type", "")

		match condition_type:
			"relationship":
				var character = condition.get("character", "")
				var required_value = condition.get("value", 0)
				var operator = condition.get("operator", ">=")
				var actual_value = GameStateManager.get_relationship(character)

				if not _compare_values(actual_value, operator, required_value):
					return false

			"flag":
				var key = condition.get("key", "")
				var required_value = condition.get("value", true)
				if GameStateManager.get_flag(key) != required_value:
					return false

			"item":
				if not GameStateManager.has_item(condition.get("item_id", "")):
					return false

	return true

func _compare_values(actual: Variant, operator: String, expected: Variant) -> bool:
	match operator:
		"==": return actual == expected
		"!=": return actual != expected
		">": return actual > expected
		">=": return actual >= expected
		"<": return actual < expected
		"<=": return actual <= expected
		_: return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_pause_pressed()
