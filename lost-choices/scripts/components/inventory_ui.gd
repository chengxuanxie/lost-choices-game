## 物品UI管理器 - 负责物品获取通知和物品栏显示
## 与GameStateManager物品系统集成
class_name InventoryUI
extends Control

## 信号
signal item_clicked(item_id: String)
signal inventory_toggled(visible: bool)

## 配置
@export var notification_duration: float = 3.0  ## 通知显示时长
@export var max_notification_count: int = 3     ## 最大同时显示通知数

## 节点引用
@onready var notification_container: VBoxContainer = $NotificationContainer
@onready var inventory_panel: PanelContainer = $InventoryPanel
@onready var item_grid: GridContainer = $InventoryPanel/ScrollContainer/ItemGrid
@onready var toggle_button: TextureButton = $ToggleButton

## 状态
var _notification_queue: Array = []     ## 通知队列
var _active_notifications: Array = []   ## 活动通知
var _is_inventory_visible: bool = false

## UI纹理
var _tex_item_slot: Texture2D

#region 生命周期

func _ready() -> void:
	_setup_ui()
	_connect_signals()
	_load_textures()
	visible = true
	inventory_panel.visible = false
	print("[InventoryUI] 物品UI初始化完成")

#endregion

#region 公共方法

## 显示物品获取通知
func show_item_notification(item_id: String, item_name: String, description: String = "") -> void:
	var notification_data = {
		"item_id": item_id,
		"name": item_name,
		"description": description,
		"timestamp": Time.get_ticks_msec()
	}

	# 如果活动通知已满，加入队列
	if _active_notifications.size() >= max_notification_count:
		_notification_queue.append(notification_data)
	else:
		_display_notification(notification_data)

	print("[InventoryUI] 显示物品通知: %s" % item_name)

## 切换物品栏显示
func toggle_inventory() -> void:
	_is_inventory_visible = not _is_inventory_visible
	inventory_panel.visible = _is_inventory_visible

	if _is_inventory_visible:
		_refresh_inventory()

	inventory_toggled.emit(_is_inventory_visible)

## 显示物品栏
func show_inventory() -> void:
	_is_inventory_visible = true
	inventory_panel.visible = true
	_refresh_inventory()
	inventory_toggled.emit(true)

## 隐藏物品栏
func hide_inventory() -> void:
	_is_inventory_visible = false
	inventory_panel.visible = false
	inventory_toggled.emit(false)

## 刷新物品栏显示
func refresh() -> void:
	if _is_inventory_visible:
		_refresh_inventory()

## 检查物品栏是否可见
func is_visible_panel() -> bool:
	return _is_inventory_visible

#endregion

#region 私有方法

func _setup_ui() -> void:
	# 确保必要节点存在
	if not notification_container:
		notification_container = VBoxContainer.new()
		notification_container.name = "NotificationContainer"
		notification_container.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		notification_container.offset_left = -300
		notification_container.offset_top = 80
		add_child(notification_container)

func _connect_signals() -> void:
	# 连接GameStateManager信号
	if GameStateManager:
		GameStateManager.item_added.connect(_on_item_added)
		GameStateManager.item_removed.connect(_on_item_removed)

	if toggle_button:
		toggle_button.pressed.connect(toggle_inventory)

func _load_textures() -> void:
	var slot_path = "res://assets/ui/items/item_slot.png"
	if ResourceLoader.exists(slot_path):
		_tex_item_slot = load(slot_path)

func _display_notification(data: Dictionary) -> void:
	var notification = _create_notification_control(data)
	notification_container.add_child(notification)
	_active_notifications.append(notification)

	# 设置自动消失
	var tween = create_tween()
	tween.tween_interval(notification_duration)
	tween.tween_callback(_remove_notification.bind(notification))

func _create_notification_control(data: Dictionary) -> Control:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(280, 60)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 10)

	# 图标占位
	var icon = TextureRect.new()
	icon.custom_minimum_size = Vector2(48, 48)
	icon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	if _tex_item_slot:
		icon.texture = _tex_item_slot

	# 文本信息
	var vbox = VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var name_label = Label.new()
	name_label.text = "获得物品: %s" % data.get("name", "未知")
	name_label.add_theme_font_size_override("font_size", 16)

	var desc_label = Label.new()
	desc_label.text = data.get("description", "")
	desc_label.add_theme_font_size_override("font_size", 12)
	desc_label.add_theme_color_override("font_color", Color.GRAY)

	vbox.add_child(name_label)
	if not data.get("description", "").is_empty():
		vbox.add_child(desc_label)

	hbox.add_child(icon)
	hbox.add_child(vbox)
	panel.add_child(hbox)

	# 淡入动画
	panel.modulate.a = 0
	var tween = create_tween()
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

	return panel

func _remove_notification(notification: Control) -> void:
	var tween = create_tween()
	tween.tween_property(notification, "modulate:a", 0.0, 0.3)
	tween.tween_callback(func():
		if notification in _active_notifications:
			_active_notifications.erase(notification)
		notification.queue_free()
		_process_notification_queue()
	)

func _process_notification_queue() -> void:
	if _notification_queue.is_empty():
		return

	if _active_notifications.size() < max_notification_count:
		var data = _notification_queue.pop_front()
		_display_notification(data)

func _refresh_inventory() -> void:
	if not item_grid:
		return

	# 清除旧物品
	for child in item_grid.get_children():
		child.queue_free()

	# 获取当前物品
	var items = GameStateManager.get_all_items()
	var item_counts = {}

	# 统计物品数量
	for item_id in items:
		if item_counts.has(item_id):
			item_counts[item_id] += 1
		else:
			item_counts[item_id] = 1

	# 创建物品格子
	for item_id in item_counts:
		var slot = _create_item_slot(item_id, item_counts[item_id])
		item_grid.add_child(slot)

func _create_item_slot(item_id: String, count: int) -> Control:
	var button = TextureButton.new()
	button.custom_minimum_size = Vector2(64, 64)
	if _tex_item_slot:
		button.texture_normal = _tex_item_slot

	# 物品数量标签
	var count_label = Label.new()
	count_label.text = "x%d" % count if count > 1 else ""
	count_label.position = Vector2(45, 45)
	count_label.add_theme_font_size_override("font_size", 12)
	button.add_child(count_label)

	button.pressed.connect(func(): item_clicked.emit(item_id))

	return button

#endregion

#region 回调函数

func _on_item_added(item_id: String) -> void:
	# 获取物品信息
	var item_info = _get_item_info(item_id)
	show_item_notification(item_id, item_info.get("name", item_id), item_info.get("description", ""))

	# 如果物品栏可见，刷新显示
	if _is_inventory_visible:
		_refresh_inventory()

func _on_item_removed(item_id: String) -> void:
	if _is_inventory_visible:
		_refresh_inventory()

#endregion

#region 辅助方法

## 获取物品信息 (从配置或数据中)
func _get_item_info(item_id: String) -> Dictionary:
	# 这里可以从物品配置文件中获取详细信息
	# 暂时返回基本信息
	return {
		"id": item_id,
		"name": item_id.replace("_", " ").capitalize(),
		"description": ""
	}

#endregion
