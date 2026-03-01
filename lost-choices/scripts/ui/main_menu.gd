## 主菜单脚本
extends Control

# 节点引用
@onready var new_game_button: Button = $CenterContainer/VBoxContainer/NewGameButton
@onready var demo_button: Button = $CenterContainer/VBoxContainer/DemoButton
@onready var test_button: Button = $CenterContainer/VBoxContainer/TestButton
@onready var continue_button: Button = $CenterContainer/VBoxContainer/ContinueButton
@onready var settings_button: Button = $CenterContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $CenterContainer/VBoxContainer/QuitButton
@onready var version_label: Label = $Version

# 设置界面
var _settings_ui: Control = null

func _ready() -> void:
	# 连接按钮信号
	new_game_button.pressed.connect(_on_new_game_pressed)
	demo_button.pressed.connect(_on_demo_pressed)
	test_button.pressed.connect(_on_test_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	settings_button.pressed.connect(_on_settings_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

	# 检查是否有存档
	continue_button.disabled = not _has_any_save()

	# 更新版本号
	version_label.text = "v%s" % GameManager.VERSION

	# 播放主菜单BGM
	# AudioManager.play_bgm("res://assets/audio/bgm/main_menu.ogg")

func _on_new_game_pressed() -> void:
	print("[MainMenu] 开始新游戏")
	GameManager.start_new_game()

func _on_demo_pressed() -> void:
	print("[MainMenu] 进入演示模式")
	GameManager._change_scene("demo")

func _on_test_pressed() -> void:
	print("[MainMenu] 运行测试")
	GameManager._change_scene("test_runner")

func _on_continue_pressed() -> void:
	print("[MainMenu] 继续游戏")
	# TODO: 显示存档选择界面
	# 暂时直接加载槽位1
	if SaveManager.save_exists(1):
		GameManager.continue_game(1)

func _on_settings_pressed() -> void:
	print("[MainMenu] 打开设置")
	# 创建并显示设置界面
	if _settings_ui == null:
		_settings_ui = _create_settings_panel()
		_settings_ui.name = "SettingsPanel"
		add_child(_settings_ui)
	_settings_ui.visible = true
	# 禁用菜单按钮
	_set_menu_buttons_enabled(false)

func _create_settings_panel() -> Control:
	"""创建设置面板"""
	var panel = PanelContainer.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(400, 300)

	var vbox = VBoxContainer.new()
	panel.add_child(vbox)

	# 标题
	var title = Label.new()
	title.text = "设置"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	# 音量控制
	var volume_label = Label.new()
	volume_label.text = "音量"
	vbox.add_child(volume_label)

	var volume_slider = HSlider.new()
	volume_slider.min_value = 0
	volume_slider.max_value = 1
	volume_slider.step = 0.1
	volume_slider.value = SettingsManager.get_setting("audio", "master_volume", 1.0)
	volume_slider.value_changed.connect(func(v): SettingsManager.set_setting("audio", "master_volume", v))
	vbox.add_child(volume_slider)

	# 文字速度
	var text_label = Label.new()
	text_label.text = "文字速度"
	vbox.add_child(text_label)

	var text_slider = HSlider.new()
	text_slider.min_value = 0.5
	text_slider.max_value = 2.0
	text_slider.step = 0.1
	text_slider.value = SettingsManager.get_setting("gameplay", "text_speed", 1.0)
	text_slider.value_changed.connect(func(v): SettingsManager.set_setting("gameplay", "text_speed", v))
	vbox.add_child(text_slider)

	# 关闭按钮
	var close_btn = Button.new()
	close_btn.text = "关闭"
	close_btn.pressed.connect(_on_settings_closed)
	vbox.add_child(close_btn)

	return panel

func _on_settings_closed() -> void:
	"""设置界面关闭"""
	print("[MainMenu] 设置已关闭")
	if _settings_ui:
		_settings_ui.visible = false
	_set_menu_buttons_enabled(true)

func _set_menu_buttons_enabled(enabled: bool) -> void:
	"""启用/禁用菜单按钮"""
	new_game_button.disabled = not enabled
	demo_button.disabled = not enabled
	test_button.disabled = not enabled
	continue_button.disabled = not enabled or not _has_any_save()
	settings_button.disabled = not enabled
	quit_button.disabled = not enabled

func _on_quit_pressed() -> void:
	print("[MainMenu] 退出游戏")
	GameManager.quit_game()

func _has_any_save() -> bool:
	for i in range(SaveManager.MAX_SLOTS):
		if SaveManager.save_exists(i):
			return true
	return false
