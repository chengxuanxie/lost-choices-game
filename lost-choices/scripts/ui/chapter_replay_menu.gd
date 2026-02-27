## 章节重玩菜单 - 允许玩家回溯到历史节点
## 提供选择历史查看和快速回溯功能
class_name ChapterReplayMenu
extends Control

## 信号
signal replay_selected(node_id: String)
signal menu_closed()

## 节点引用
@onready var title_label: Label
@onready var history_container: ScrollContainer
@onready var history_list: VBoxContainer
@onready var rollback_button: Button
@onready var close_button: Button

## 主题颜色
const COLOR_LOCKED := Color(0.4, 0.4, 0.4, 0.8)
const COLOR_AVAILABLE := Color(0.2, 0.6, 0.8, 0.9)
const COLOR_SELECTED := Color(0.3, 0.7, 0.4, 1.0)

var _selected_node_id: String = ""

func _ready() -> void:
	_setup_ui()
	_setup_signals()
	refresh_history()

func _setup_ui() -> void:
	"""初始化UI"""
	if title_label:
		title_label.text = "选择历史"

	# 设置滚动容器
	if history_container:
		history_container.clip_contents = true

func _setup_signals() -> void:
	"""连接信号"""
	if rollback_button:
		rollback_button.pressed.connect(_on_rollback_pressed)
		rollback_button.disabled = true

	if close_button:
		close_button.pressed.connect(_on_close_pressed)

## 刷新历史记录显示

func refresh_history() -> void:
	"""刷新选择历史显示"""
	if not history_list:
		return

	# 清除旧项目
	for child in history_list.get_children():
		child.queue_free()

	# 获取回溯选项
	var options = StoryEngine.get_rollback_options()

	if options.is_empty():
		_show_empty_state()
		return

	# 创建历史项目
	for option in options:
		var item = _create_history_item(option)
		history_list.add_child(item)

	# 滚动到底部（最新）
	history_container.scroll_vertical = history_container.get_v_scroll_bar().max_value

func _show_empty_state() -> void:
	"""显示空状态"""
	var empty_label = Label.new()
	empty_label.text = "暂无选择历史"
	empty_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	history_list.add_child(empty_label)

func _create_history_item(option: Dictionary) -> Control:
	"""创建历史项目"""
	var item = Control.new()
	item.custom_minimum_size = Vector2(400, 50)
	item.set_meta("node_id", option.get("node_id", ""))

	# 背景面板
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.name = "Background"

	# 样式
	var style = StyleBoxFlat.new()
	style.bg_color = COLOR_AVAILABLE
	style.set_corner_radius_all(4)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	panel.add_theme_stylebox_override("panel", style)
	item.add_child(panel)

	# 节点信息
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 2)
	panel.add_child(vbox)

	# 节点ID
	var node_label = Label.new()
	node_label.text = _get_node_display_name(option.get("node_id", ""))
	node_label.add_theme_font_size_override("font_size", 14)
	node_label.add_theme_color_override("font_color", Color(1, 1, 1))
	vbox.add_child(node_label)

	# 选择信息
	var choice_label = Label.new()
	choice_label.text = "选择: %s" % option.get("choice_id", "")
	choice_label.add_theme_font_size_override("font_size", 12)
	choice_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
	vbox.add_child(choice_label)

	# 周目信息
	var playthrough = option.get("playthrough", 1)
	var pt_label = Label.new()
	pt_label.text = "第 %d 周目" % playthrough
	pt_label.add_theme_font_size_override("font_size", 10)
	pt_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))
	vbox.add_child(pt_label)

	# 点击事件
	item.gui_input.connect(func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_select_item(item, option.get("node_id", ""))
	)

	# 悬停效果
	item.mouse_entered.connect(func():
		if item.get_meta("node_id") != _selected_node_id:
			var p = panel.get_theme_stylebox("panel") as StyleBoxFlat
			if p:
				p.bg_color = COLOR_AVAILABLE.lightened(0.2)
	)

	item.mouse_exited.connect(func():
		if item.get_meta("node_id") != _selected_node_id:
			var p = panel.get_theme_stylebox("panel") as StyleBoxFlat
			if p:
				p.bg_color = COLOR_AVAILABLE
	)

	return item

func _get_node_display_name(node_id: String) -> String:
	"""获取节点显示名称"""
	var node_data = StoryEngine.get_node_data(node_id)
	return node_data.get("scene", node_id)

## 选择处理

func _select_item(item: Control, node_id: String) -> void:
	"""选择历史项目"""
	# 取消之前的选择
	for child in history_list.get_children():
		var panel = child.get_node_or_null("Background")
		if panel:
			var style = panel.get_theme_stylebox("panel") as StyleBoxFlat
			if child.get_meta("node_id") == _selected_node_id:
				style.bg_color = COLOR_AVAILABLE

	# 设置新选择
	_selected_node_id = node_id
	item.get_node("Background").add_theme_stylebox_override("panel", _create_selected_style())

	# 启用回溯按钮
	if rollback_button:
		rollback_button.disabled = false

func _create_selected_style() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = COLOR_SELECTED
	style.set_corner_radius_all(4)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 5
	style.content_margin_bottom = 5
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color.WHITE
	return style

## 信号回调

func _on_rollback_pressed() -> void:
	"""回溯到选中的节点"""
	if _selected_node_id.is_empty():
		return

	# 确认对话框
	var confirm = _show_confirm_dialog("确认回溯？", "将回到: %s" % _get_node_display_name(_selected_node_id))
	if confirm:
		replay_selected.emit(_selected_node_id)
		hide()
		menu_closed.emit()

func _on_close_pressed() -> void:
	"""关闭菜单"""
	hide()
	menu_closed.emit()

func _show_confirm_dialog(title: String, message: String) -> bool:
	"""显示确认对话框（简化版）"""
	# 在实际项目中，这里应该显示一个确认对话框
	# 这里直接返回true表示确认
	print("[ChapterReplayMenu] %s: %s" % [title, message])
	return true

## 公开方法

func open_menu() -> void:
	"""打开菜单"""
	visible = true
	_selected_node_id = ""
	if rollback_button:
		rollback_button.disabled = true
	refresh_history()

	# 淡入动画
	if has_node("Panel"):
		var panel = get_node("Panel")
		panel.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, 0.2)

func close_menu() -> void:
	"""关闭菜单"""
	hide()
	menu_closed.emit()
