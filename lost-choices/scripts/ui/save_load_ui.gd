## 存档/读档界面
## 支持保存游戏、加载游戏、显示存档信息
class_name SaveLoadUI
extends Control

## 信号
signal save_completed(slot: int)
signal load_completed(slot: int)
signal ui_closed()

## 存档槽位数量
const MAX_SAVE_SLOTS := 10

## 模式
enum Mode { SAVE, LOAD }
var _current_mode: Mode = Mode.LOAD

## 节点引用
@onready var slots_container: GridContainer
@onready var save_slots: Array[Control] = []
@onready var close_button: Button
@onready var title_label: Label
@onready var mode_toggle: CheckButton

## 存档数据缓存
var _save_data_cache: Array = []

## UI纹理
var _slot_texture_normal: Texture2D
var _slot_texture_empty: Texture2D

func _ready() -> void:
	_load_ui_resources()
	_setup_ui()
	_setup_signals()

func _load_ui_resources() -> void:
	"""加载UI资源"""
	_slot_texture_normal = _load_texture("res://assets/ui/panels/save_slot.png")
	_slot_texture_empty = _load_texture("res://assets/ui/panels/save_slot.png")

func _load_texture(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		return load(path)
	return null

func _setup_ui() -> void:
	"""初始化UI"""
	# 创建存档槽位
	_create_save_slots()
	# 刷新存档数据
	refresh_slots()

func _setup_signals() -> void:
	"""连接信号"""
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

	if mode_toggle:
		mode_toggle.toggled.connect(_on_mode_toggled)

## 创建存档槽位

func _create_save_slots() -> void:
	if not slots_container:
		return

	# 清除旧槽位
	for child in slots_container.get_children():
		child.queue_free()
	save_slots.clear()

	# 创建新槽位
	for i in range(MAX_SAVE_SLOTS):
		var slot = _create_slot(i)
		slots_container.add_child(slot)
		save_slots.append(slot)

func _create_slot(index: int) -> Control:
	"""创建单个存档槽位"""
	var slot = Control.new()
	slot.custom_minimum_size = Vector2(300, 120)
	slot.set_meta("slot_index", index)

	# 背景面板
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.name = "Background"
	slot.add_child(panel)

	# 槽位编号
	var slot_label = Label.new()
	slot_label.name = "SlotLabel"
	slot_label.text = "存档 %02d" % (index + 1)
	slot_label.position = Vector2(15, 10)
	slot_label.add_theme_font_size_override("font_size", 16)
	slot_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	panel.add_child(slot_label)

	# 章节标签
	var chapter = Label.new()
	chapter.name = "ChapterLabel"
	chapter.text = "无数据"
	chapter.position = Vector2(15, 35)
	chapter.add_theme_font_size_override("font_size", 14)
	chapter.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	panel.add_child(chapter)

	# 时间标签
	var time_label = Label.new()
	time_label.name = "TimeLabel"
	time_label.text = ""
	time_label.position = Vector2(15, 55)
	time_label.add_theme_font_size_override("font_size", 12)
	time_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	panel.add_child(time_label)

	# 进度标签
	var progress_label = Label.new()
	progress_label.name = "ProgressLabel"
	progress_label.text = ""
	progress_label.position = Vector2(15, 75)
	progress_label.add_theme_font_size_override("font_size", 12)
	progress_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
	panel.add_child(progress_label)

	# 操作按钮
	var action_button = Button.new()
	action_button.name = "ActionButton"
	action_button.text = "载入"
	action_button.position = Vector2(200, 40)
	action_button.size = Vector2(80, 30)
	action_button.pressed.connect(func(): _on_slot_clicked(index))
	panel.add_child(action_button)

	# 应用纹理
	if _slot_texture_normal:
		panel.add_theme_stylebox_override("panel", _create_slot_style(_slot_texture_normal))

	# 鼠标悬停效果
	slot.mouse_entered.connect(func(): _on_slot_hovered(slot, true))
	slot.mouse_exited.connect(func(): _on_slot_hovered(slot, false))

	return slot

func _create_slot_style(texture: Texture2D) -> StyleBoxFlat:
	"""创建槽位样式"""
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.8)
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.3, 0.3, 0.4, 0.5)
	style.set_corner_radius_all(8)
	return style

## 刷新存档槽位

func refresh_slots() -> void:
	"""刷新所有存档槽位"""
	for i in range(MAX_SAVE_SLOTS):
		_update_slot(i)

func _update_slot(index: int) -> void:
	"""更新单个存档槽位"""
	if index >= save_slots.size():
		return

	var slot = save_slots[index]
	var panel = slot.get_node_or_null("Background")
	if not panel:
		return

	var chapter_label = panel.get_node_or_null("ChapterLabel")
	var time_label = panel.get_node_or_null("TimeLabel")
	var progress_label = panel.get_node_or_null("ProgressLabel")
	var action_button = panel.get_node_or_null("ActionButton") as Button

	# 获取存档数据
	var save_data = _get_save_data(index)

	if save_data.is_empty():
		# 空存档
		if chapter_label:
			chapter_label.text = "空存档"
		if time_label:
			time_label.text = ""
		if progress_label:
			progress_label.text = ""
		if action_button:
			action_button.text = "保存"
			action_button.disabled = (_current_mode == Mode.LOAD)
	else:
		# 有数据的存档
		var chapter_name = save_data.get("chapter_name", "未知章节")
		var node_name = save_data.get("node_name", "")
		var timestamp = save_data.get("timestamp", 0)
		var play_time = save_data.get("play_time", 0.0)
		var progress = save_data.get("progress", 0.0)

		if chapter_label:
			chapter_label.text = chapter_name
		if time_label:
			var date_str = _format_timestamp(timestamp)
			var play_time_str = _format_play_time(play_time)
			time_label.text = "%s | %s" % [date_str, play_time_str]
		if progress_label:
			progress_label.text = "进度: %.1f%%" % progress
		if action_button:
			action_button.text = "载入" if _current_mode == Mode.LOAD else "覆盖"

func _get_save_data(slot: int) -> Dictionary:
	"""获取指定槽位的存档数据"""
	return SaveManager.get_save_info(slot)

## 存档/读档操作

func _on_slot_clicked(slot: int) -> void:
	"""槽位被点击"""
	var save_data = _get_save_data(slot)

	if _current_mode == Mode.SAVE:
		# 保存游戏
		_save_game(slot)
	else:
		# 加载游戏
		if save_data.is_empty():
			# 空存档，显示提示
			_show_message("请先保存游戏")
		else:
			_load_game(slot)

func _save_game(slot: int) -> void:
	"""保存游戏到指定槽位"""
	var success = SaveManager.save_game(slot)

	if success:
		_show_message("保存成功！")
		save_completed.emit(slot)
		refresh_slots()
	else:
		_show_message("保存失败！")

func _load_game(slot: int) -> void:
	"""从指定槽位加载游戏"""
	var success = await SaveManager.load_game(slot)

	if success:
		_show_message("载入成功！")
		load_completed.emit(slot)
		ui_closed.emit()
	else:
		_show_message("载入失败！")

## 信号回调

func _on_close_pressed() -> void:
	"""关闭界面"""
	hide()
	ui_closed.emit()

func _on_mode_toggled(toggled: bool) -> void:
	"""切换存档/读档模式"""
	_current_mode = Mode.SAVE if toggled else Mode.LOAD
	_update_title()
	refresh_slots()

func _on_slot_hovered(slot: Control, hovered: bool) -> void:
	"""槽位鼠标悬停效果"""
	var panel = slot.get_node_or_null("Background")
	if not panel:
		return

	var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
	if style:
		if hovered:
			style.border_color = Color(0.5, 0.5, 0.7, 0.8)
			style.bg_color = Color(0.15, 0.15, 0.2, 0.9)
		else:
			style.border_color = Color(0.3, 0.3, 0.4, 0.5)
			style.bg_color = Color(0.1, 0.1, 0.15, 0.8)

## 工具方法

func _update_title() -> void:
	"""更新标题"""
	if title_label:
		title_label.text = "保存游戏" if _current_mode == Mode.SAVE else "载入游戏"

func _format_timestamp(timestamp: int) -> String:
	"""格式化时间戳"""
	if timestamp == 0:
		return ""
	var date = Time.get_datetime_dict_from_unix_time(timestamp)
	return "%04d-%02d-%02d %02d:%02d" % [
		date.year, date.month, date.day,
		date.hour, date.minute
	]

func _format_play_time(seconds: float) -> String:
	"""格式化游玩时间"""
	var hours = int(seconds) / 3600
	var minutes = (int(seconds) % 3600) / 60
	var secs = int(seconds) % 60

	if hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, secs]
	else:
		return "%02d:%02d" % [minutes, secs]

func _show_message(msg: String) -> void:
	"""显示临时消息"""
	print("[SaveLoadUI] %s" % msg)
	# 可以添加一个临时的消息标签显示

## 公开方法

func open_as_save() -> void:
	"""以存档模式打开"""
	_current_mode = Mode.SAVE
	_update_title()
	visible = true
	refresh_slots()

func open_as_load() -> void:
	"""以读档模式打开"""
	_current_mode = Mode.LOAD
	_update_title()
	visible = true
	refresh_slots()
