## 游戏主控制器 - 完整的游戏运行时控制器
## 整合所有游戏系统：剧情、视频、字幕、选择、物品
## 这是生产环境使用的主控制器
class_name GameController
extends Control

## 信号
signal game_ready()
signal chapter_changed(chapter_id: String)
signal node_changed(node_id: String)

## UI资源路径常量
const UI_PATHS := {
	"choice_normal": "res://assets/ui/buttons/choice_card_normal.png",
	"choice_hover": "res://assets/ui/buttons/choice_card_hover.png",
	"choice_locked": "res://assets/ui/buttons/choice_card_locked.png",
	"choice_selected": "res://assets/ui/buttons/choice_card_selected.png",
	"btn_pause": "res://assets/ui/buttons/btn_pause.png",
	"btn_play": "res://assets/ui/buttons/btn_play.png",
	"inventory_icon": "res://assets/ui/icons/icon_inventory.svg"
}

## 节点引用
@onready var hybrid_player: HybridScenePlayer = $HybridPlayer
@onready var subtitle_panel: PanelContainer = $SubtitlePanel
@onready var subtitle_label: RichTextLabel = $SubtitlePanel/SubtitleLabel
@onready var choice_container: VBoxContainer = $ChoiceContainer
@onready var hud_container: HBoxContainer = $HUD
@onready var chapter_label: Label = $HUD/ChapterLabel
@onready var progress_bar: ProgressBar = $HUD/ProgressBar
@onready var pause_button: TextureButton = $PauseButton
@onready var inventory_button: TextureButton = $InventoryButton

## 组件引用
var subtitle_manager: SubtitleManager
var choice_timer: ChoiceTimer
var inventory_ui: InventoryUI

## 状态
var _current_node_data: Dictionary = {}
var _is_waiting_choice: bool = false
var _is_paused: bool = false
var _chapter_title: String = ""

## UI纹理缓存
var _ui_textures: Dictionary = {}

#region 生命周期

func _ready() -> void:
	_setup_components()
	_load_ui_resources()
	_setup_signals()
	_initialize_game()

func _process(delta: float) -> void:
	# 更新字幕
	if subtitle_manager and hybrid_player.is_playing():
		var current_time = _get_current_play_time()
		subtitle_manager.update(current_time)

	# 更新进度条
	_update_progress_display()

#endregion

#region 初始化

func _setup_components() -> void:
	# 创建字幕管理器
	subtitle_manager = SubtitleManager.new()
	add_child(subtitle_manager)
	subtitle_manager.subtitle_changed.connect(_on_subtitle_changed)
	subtitle_manager.subtitle_cleared.connect(_on_subtitle_cleared)

	# 创建选择计时器
	choice_timer = ChoiceTimer.new()
	add_child(choice_timer)
	choice_timer.timeout.connect(_on_choice_timeout)

	# 初始化混合播放器
	if hybrid_player:
		hybrid_player.load_scene({"segments": []})

func _load_ui_resources() -> void:
	for key in UI_PATHS:
		var path = UI_PATHS[key]
		if ResourceLoader.exists(path):
			_ui_textures[key] = load(path)
		else:
			push_warning("[GameController] UI资源不存在: %s" % path)

	# 应用暂停按钮纹理
	if pause_button and _ui_textures.has("btn_pause"):
		pause_button.texture_normal = _ui_textures["btn_pause"]
		if _ui_textures.has("btn_play"):
			pause_button.texture_pressed = _ui_textures["btn_play"]

func _setup_signals() -> void:
	# 故事引擎信号
	StoryEngine.node_changed.connect(_on_story_node_changed)
	StoryEngine.choices_available.connect(_on_story_choices_available)
	StoryEngine.choice_made.connect(_on_story_choice_made)
	StoryEngine.story_ended.connect(_on_story_ended)

	# 混合播放器信号
	if hybrid_player:
		hybrid_player.scene_completed.connect(_on_scene_completed)
		hybrid_player.segment_changed.connect(_on_segment_changed)

	# UI按钮信号
	if pause_button:
		pause_button.pressed.connect(_toggle_pause)
	if inventory_button:
		inventory_button.pressed.connect(_toggle_inventory)

func _initialize_game() -> void:
	print("[GameController] 游戏控制器初始化完成")
	game_ready.emit()

#endregion

#region 游戏流程控制

## 开始新游戏
func start_new_game(chapter_id: String = "chapter_01") -> void:
	GameStateManager.reset_state()
	StoryEngine.start_chapter(chapter_id)

## 从存档继续
func continue_from_save(slot: int) -> void:
	await SaveManager.load_game(slot)

## 播放剧情节点
func play_node(node_data: Dictionary) -> void:
	_current_node_data = node_data
	_is_waiting_choice = false

	var node_id = node_data.get("node_id", "unknown")
	print("[GameController] 播放节点: %s" % node_id)
	node_changed.emit(node_id)

	# 加载字幕
	if subtitle_manager:
		subtitle_manager.load_from_node(node_data)
		subtitle_manager.start()

	# 构建并播放场景
	var scene_config = _build_scene_config(node_data)
	if hybrid_player:
		hybrid_player.load_scene(scene_config)
		hybrid_player.play()

	# 处理物品获取
	_process_item_acquisitions(node_data)

## 构建场景配置
func _build_scene_config(node_data: Dictionary) -> Dictionary:
	var segments: Array = []

	# 添加关键帧片段
	var keyframes = node_data.get("keyframes", {})
	if not keyframes.is_empty():
		var frames = keyframes.get("frames", [])
		var durations = keyframes.get("durations", [])
		var effects = keyframes.get("effects", {})

		for i in range(frames.size()):
			var frame_path = frames[i]
			var duration = float(durations[i]) if i < durations.size() else 5.0

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
		var video_duration = float(video.get("duration", 10.0))

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
		total += float(seg.get("duration", 5.0))
	return total

#endregion

#region 选择系统

## 显示选择选项
func show_choices(choices: Array) -> void:
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

	# 检查是否有时间限制
	var time_limit = _current_node_data.get("choice_time_limit", 0)
	if time_limit > 0:
		choice_timer.start(time_limit, 0)

## 创建选择按钮
func _create_choice_button(choice: Dictionary, index: int) -> Control:
	var button = TextureButton.new()
	button.custom_minimum_size = Vector2(560, 70)
	button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED

	var choice_text = choice.get("text", "选项")
	var conditions = choice.get("conditions", [])
	var is_locked = not _check_conditions(conditions)

	# 设置纹理
	if is_locked:
		if _ui_textures.has("choice_locked"):
			button.texture_normal = _ui_textures["choice_locked"]
		button.disabled = true
	else:
		if _ui_textures.has("choice_normal"):
			button.texture_normal = _ui_textures["choice_normal"]
		if _ui_textures.has("choice_hover"):
			button.texture_hover = _ui_textures["choice_hover"]
		if _ui_textures.has("choice_selected"):
			button.texture_pressed = _ui_textures["choice_selected"]

	# 添加文本标签
	var label = Label.new()
	label.text = choice_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	label.add_theme_color_override("font_outline_color", Color(0.9, 0.9, 0.9))
	label.add_theme_constant_override("outline_size", 2)
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.offset_left = 20
	label.offset_right = -20

	button.add_child(label)

	if not is_locked:
		button.pressed.connect(func(): _on_choice_selected(index))

	return button

## 检查选择条件
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
				if not _compare_values(actual, op, val):
					return false
			"relationship":
				var character = condition.get("character", "")
				var op = condition.get("operator", ">=")
				var val = condition.get("value", 0)
				var actual = GameStateManager.get_relationship(character)
				if not _compare_values(actual, op, val):
					return false
			"item":
				var item_id = condition.get("item_id", "")
				if not GameStateManager.has_item(item_id):
					return false
	return true

func _compare_values(actual: Variant, op: String, expected: Variant) -> bool:
	match op:
		"==": return actual == expected
		"!=": return actual != expected
		">": return actual > expected
		">=": return actual >= expected
		"<": return actual < expected
		"<=": return actual <= expected
		_: return false

## 选择被点击
func _on_choice_selected(index: int) -> void:
	if not _is_waiting_choice:
		return

	choice_timer.stop()
	choice_container.visible = false
	_is_waiting_choice = false

	# 通过StoryEngine处理选择
	StoryEngine.make_choice(index)

## 选择超时
func _on_choice_timeout(default_index: int) -> void:
	if _is_waiting_choice:
		_on_choice_selected(default_index)

#endregion

#region 字幕系统

func _on_subtitle_changed(text: String, speaker: String) -> void:
	if subtitle_label:
		if speaker.is_empty():
			subtitle_label.text = text
		else:
			subtitle_label.text = "[color=aqua]%s[/color]: %s" % [speaker, text]
		subtitle_panel.visible = true

func _on_subtitle_cleared() -> void:
	if subtitle_panel:
		subtitle_panel.visible = false

#endregion

#region 物品系统

func _process_item_acquisitions(node_data: Dictionary) -> void:
	var items = node_data.get("items", [])
	for item in items:
		var obtained_at = item.get("obtained_at", 0)
		# 这里可以根据视频时间延迟添加物品
		# 暂时直接添加
		_schedule_item_acquisition(item, obtained_at)

func _schedule_item_acquisition(item: Dictionary, delay: float) -> void:
	if delay <= 0:
		_add_item(item)
	else:
		await get_tree().create_timer(delay).timeout
		_add_item(item)

func _add_item(item: Dictionary) -> void:
	var item_id = item.get("id", "")
	if item_id.is_empty():
		return

	GameStateManager.add_item(item_id)
	# 物品通知由InventoryUI自动处理

#endregion

#region UI控制

func _toggle_pause() -> void:
	_is_paused = not _is_paused

	if _is_paused:
		GameManager.pause_game()
		if hybrid_player:
			hybrid_player.pause()
		if subtitle_manager:
			subtitle_manager.stop()
	else:
		GameManager.resume_game()
		if hybrid_player:
			hybrid_player.resume()
		if subtitle_manager:
			subtitle_manager.start()

func _toggle_inventory() -> void:
	if inventory_ui:
		inventory_ui.toggle_inventory()

func _update_progress_display() -> void:
	if progress_bar and hybrid_player:
		progress_bar.value = hybrid_player.get_progress() * 100

#endregion

#region 回调函数

func _on_story_node_changed(node_id: String, node_data: Dictionary) -> void:
	play_node(node_data)

func _on_story_choices_available(choices: Array) -> void:
	show_choices(choices)

func _on_story_choice_made(choice_id: String, choice_data: Dictionary) -> void:
	print("[GameController] 选择完成: %s" % choice_id)

func _on_story_ended(ending_id: String) -> void:
	show_ending(ending_id)

func _on_scene_completed() -> void:
	if subtitle_manager:
		subtitle_manager.stop()

	# 检查是否有选择
	var choices = _current_node_data.get("choices", [])
	if choices.size() > 0:
		show_choices(choices)
	else:
		# 检查自动跳转
		var auto_next = _current_node_data.get("auto_next", "")
		if not auto_next.is_empty():
			StoryEngine.jump_to_node(auto_next)

func _on_segment_changed(segment_index: int, segment_type: String) -> void:
	var segments = hybrid_player.get_segments()
	if segment_index >= 0 and segment_index < segments.size():
		print("[GameController] 片段 %d/%d: %s" % [
			segment_index + 1,
			segments.size(),
			segment_type
		])

#endregion

#region 辅助方法

func _get_current_play_time() -> float:
	# 获取当前播放时间（用于字幕同步）
	# 这里需要根据实际视频播放时间实现
	return 0.0

func show_ending(ending_id: String) -> void:
	print("[GameController] 达成结局: %s" % ending_id)

	if hybrid_player:
		hybrid_player.stop()

	choice_container.visible = false

	# 显示结局画面
	# TODO: 加载结局场景

	# 记录结局
	StatsManager.record("ending_unlock", ending_id)

#endregion

#region 输入处理

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()
	elif event.is_action_pressed("ui_inventory"):
		_toggle_inventory()

#endregion
