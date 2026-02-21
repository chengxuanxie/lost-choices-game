## 演示场景 - 模拟游戏流程（无需视频文件）
## 用于测试剧情流程和分支选择逻辑
extends Control

# UI节点
@onready var story_text: RichTextLabel = $VBoxContainer/StoryText
@onready var choices_container: VBoxContainer = $VBoxContainer/ChoicesContainer
@onready var status_label: Label = $StatusBar/HBoxContainer/StatusLabel
@onready var node_label: Label = $StatusBar/HBoxContainer/NodeLabel
@onready var relationship_label: Label = $StatusBar/HBoxContainer/RelationshipLabel
@onready var start_button: Button = $VBoxContainer/ButtonsContainer/StartButton
@onready var test_button: Button = $VBoxContainer/ButtonsContainer/TestButton
@onready var back_button: Button = $VBoxContainer/ButtonsContainer/BackButton

# 状态
var _is_simulating: bool = false

func _ready() -> void:
	# 连接故事引擎信号
	StoryEngine.node_changed.connect(_on_node_changed)
	StoryEngine.choices_available.connect(_on_choices_available)
	StoryEngine.story_ended.connect(_on_story_ended)
	StoryEngine.choice_made.connect(_on_choice_made)

	# 连接状态变化信号
	GameStateManager.relationship_changed.connect(_on_relationship_changed)
	GameStateManager.state_changed.connect(_on_state_changed)

	# 连接按钮信号
	start_button.pressed.connect(_on_start_demo_pressed)
	test_button.pressed.connect(_on_test_pressed)
	back_button.pressed.connect(_on_back_pressed)

	_log("=== 迷途抉择 演示模式 ===")
	_log("此模式模拟游戏流程，无需视频文件")
	_log("")
	_log("点击 '开始演示' 按钮开始")
	_log("")

	_update_status_display()

func _log(message: String) -> void:
	story_text.text += message + "\n"

func _clear_choices() -> void:
	for child in choices_container.get_children():
		child.queue_free()

func _update_status_display() -> void:
	node_label.text = "节点: %s" % StoryEngine.get_current_node()
	relationship_label.text = "好感度: %s" % _get_relationship_summary()

func _get_relationship_summary() -> String:
	var relationships = GameStateManager.get_all_relationships()
	if relationships.is_empty():
		return "无"
	var summary = ""
	for character in relationships:
		var value = relationships[character]
		var level = GameStateManager.get_relationship_level_name(character)
		summary += "%s(%d/%s) " % [character, value, level]
	return summary.strip_edges()

#region 按钮事件

func _on_start_demo_pressed() -> void:
	if _is_simulating:
		return

	_is_simulating = true
	story_text.text = ""
	_log("=== 开始第一章：觉醒 ===\n")

	# 开始故事
	StoryEngine.start_chapter("chapter_01")

func _on_back_pressed() -> void:
	StoryEngine.end_current_story()
	GameStateManager.reset_state()
	GameManager._change_scene("main_menu")

func _on_test_pressed() -> void:
	GameManager._change_scene("test_runner")

#endregion

#region 故事引擎回调

func _on_node_changed(node_id: String, node_data: Dictionary) -> void:
	_log("\n[节点: %s]" % node_id)
	_update_status_display()

	# 显示场景描述（代替字幕）
	var scene = node_data.get("scene", "")
	var description = node_data.get("description", "")

	if not scene.is_empty():
		_log("[b]场景:[/b] %s" % scene)
	if not description.is_empty():
		_log("[i]%s[/i]" % description)

	# 检查节点类型
	var node_type = node_data.get("node_type", "video")
	match node_type:
		"ending":
			var ending_id = node_data.get("ending_id", "unknown")
			var ending_name = node_data.get("ending_name", "未知结局")
			_log("\n[color=green]=== 达成结局 ===[/color]")
			_log("[color=green]%s (%s)[/color]" % [ending_name, ending_id])

		"auto":
			# 自动跳转节点
			var auto_next = node_data.get("auto_next", "")
			if not auto_next.is_empty():
				_log("\n[i]自动跳转到下一节点...[/i]")
				await get_tree().create_timer(1.0).timeout
				StoryEngine.jump_to_node(auto_next)

func _on_choices_available(choices: Array) -> void:
	_clear_choices()
	_log("\n[color=yellow]请做出选择：[/color]")

	# 创建选择按钮
	for i in range(choices.size()):
		var choice = choices[i]
		var button = Button.new()
		button.text = "%d. %s" % [i + 1, choice.get("text", "选项")]

		# 检查是否锁定
		var conditions = choice.get("conditions", [])
		var is_locked = not _check_all_conditions(conditions)

		if is_locked:
			button.disabled = true
			button.text = "[锁定] " + button.text

		button.pressed.connect(func(): _on_choice_button_pressed(i))
		choices_container.add_child(button)

		# 显示提示
		var hint = choice.get("hint", "")
		if hint and not hint.is_empty():
			_log("  %d. %s [提示: %s]" % [i + 1, choice.get("text"), hint])
		else:
			_log("  %d. %s" % [i + 1, choice.get("text")])

func _on_choice_button_pressed(index: int) -> void:
	_clear_choices()
	StoryEngine.make_choice(index)

func _on_choice_made(choice_id: String, choice_data: Dictionary) -> void:
	_log("\n[i]你选择了: %s[/i]" % choice_data.get("text", choice_id))

func _on_story_ended(ending_id: String) -> void:
	_is_simulating = false
	_log("\n[color=green]=== 故事结束 ===[/color]")
	_log("结局ID: %s" % ending_id)
	_log("\n感谢体验演示模式！")
	_update_status_display()

#endregion

#region 状态变化回调

func _on_relationship_changed(character: String, value: int) -> void:
	var level = GameStateManager.get_relationship_level_name(character)
	_log("[color=cyan]好感度变化: %s -> %d (%s)[/color]" % [character, value, level])
	_update_status_display()

func _on_state_changed(key: String, value: Variant) -> void:
	_log("[color=orange]状态变化: %s = %s[/color]" % [key, str(value)])

#endregion

#region 条件检查

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

#endregion
