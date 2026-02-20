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
	# TODO: 显示设置界面

func _on_quit_pressed() -> void:
	print("[MainMenu] 退出游戏")
	GameManager.quit_game()

func _has_any_save() -> bool:
	for i in range(SaveManager.MAX_SLOTS):
		if SaveManager.save_exists(i):
			return true
	return false
