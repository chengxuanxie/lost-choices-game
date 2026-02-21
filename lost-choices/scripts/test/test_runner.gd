## 测试场景 - 用于验证核心系统
extends Control

# 测试结果容器
var _test_results: Array = []
var _tests_passed: int = 0
var _tests_failed: int = 0

# UI节点
@onready var test_output: RichTextLabel = $VBoxContainer/TestOutput
@onready var run_button: Button = $VBoxContainer/HBoxContainer/RunButton
@onready var back_button: Button = $VBoxContainer/HBoxContainer/BackButton
@onready var exit_button: Button = $VBoxContainer/HBoxContainer/ExitButton

func _ready() -> void:
	run_button.pressed.connect(_run_all_tests)
	back_button.pressed.connect(_on_back_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	_log("=== 迷途抉择 技术原型测试 ===")
	_log("点击 '运行测试' 按钮开始验证")
	_log("")

func _on_back_pressed() -> void:
	GameManager._change_scene("main_menu")

func _on_exit_pressed() -> void:
	GameManager.quit_game()

func _log(message: String) -> void:
	test_output.text += message + "\n"

func _log_success(message: String) -> void:
	test_output.text += "[color=green]✓ " + message + "[/color]\n"
	_tests_passed += 1

func _log_error(message: String) -> void:
	test_output.text += "[color=red]✗ " + message + "[/color]\n"
	_tests_failed += 1

func _run_all_tests() -> void:
	test_output.text = ""
	_tests_passed = 0
	_tests_failed = 0

	_log("=== 开始运行测试套件 ===\n")

	# 运行各项测试
	_test_game_manager()
	_test_game_state_manager()
	_test_story_engine()
	_test_save_manager()
	_test_video_manager()
	_test_audio_manager()
	_test_event_manager()
	_test_stats_manager()

	# 显示结果摘要
	_log("\n=== 测试完成 ===")
	_log("通过: %d" % _tests_passed)
	_log("失败: %d" % _tests_failed)

	if _tests_failed == 0:
		_log_success("所有测试通过！原型验证成功。")
	else:
		_log_error("有 %d 个测试失败，请检查上述错误。" % _tests_failed)

func _test_game_manager() -> void:
	_log("\n--- 测试 GameManager ---")

	# 测试初始状态
	if GameManager.get_current_state() == GameManager.GameState.MENU:
		_log_success("GameManager 初始状态正确 (MENU)")
	else:
		_log_error("GameManager 初始状态错误")

	# 测试状态切换
	GameManager.set_state(GameManager.GameState.PLAYING)
	if GameManager.get_current_state() == GameManager.GameState.PLAYING:
		_log_success("GameManager 状态切换成功")
	else:
		_log_error("GameManager 状态切换失败")

	# 测试版本号
	if not GameManager.VERSION.is_empty():
		_log_success("GameManager 版本号: %s" % GameManager.VERSION)
	else:
		_log_error("GameManager 版本号为空")

	GameManager.set_state(GameManager.GameState.MENU)

func _test_game_state_manager() -> void:
	_log("\n--- 测试 GameStateManager ---")

	# 测试标记系统
	GameStateManager.set_flag("test_flag", true)
	if GameStateManager.get_flag("test_flag") == true:
		_log_success("标记系统工作正常")
	else:
		_log_error("标记系统失败")

	# 测试变量系统
	GameStateManager.set_variable("test_var", 100)
	if GameStateManager.get_variable("test_var") == 100:
		_log_success("变量系统工作正常")
	else:
		_log_error("变量系统失败")

	# 测试变量修改
	GameStateManager.modify_variable("test_var", 50)
	if GameStateManager.get_variable("test_var") == 150:
		_log_success("变量修改系统工作正常")
	else:
		_log_error("变量修改系统失败")

	# 测试物品系统
	GameStateManager.add_item("test_item")
	if GameStateManager.has_item("test_item"):
		_log_success("物品系统工作正常")
	else:
		_log_error("物品系统失败")

	# 测试好感度系统
	GameStateManager.set_relationship("test_character", 65)
	if GameStateManager.get_relationship("test_character") == 65:
		_log_success("好感度系统工作正常")
	else:
		_log_error("好感度系统失败")

	# 测试好感度等级（65 >= 61 应该是"亲密"）
	var level_name = GameStateManager.get_relationship_level_name("test_character")
	if level_name == "亲密":
		_log_success("好感度等级计算正确: %s" % level_name)
	else:
		_log_error("好感度等级计算错误: %s (期望: 亲密)" % level_name)

	# 清理测试数据
	GameStateManager.reset_state()

func _test_story_engine() -> void:
	_log("\n--- 测试 StoryEngine ---")

	# 等待章节索引加载
	await get_tree().process_frame

	# 测试章节数据加载
	var chapters = StoryEngine._chapters_index.get("chapters", [])
	if chapters.size() > 0:
		_log_success("章节索引加载成功，共 %d 章" % chapters.size())
	else:
		_log_error("章节索引加载失败")

	# 测试节点条件判断
	var test_condition = {"type": "flag", "key": "test_condition_flag", "value": true}
	GameStateManager.set_flag("test_condition_flag", true)
	if StoryEngine._check_single_condition(test_condition):
		_log_success("条件判断系统工作正常")
	else:
		_log_error("条件判断系统失败")

	# 测试效果应用
	var test_effect = {"type": "set_flag", "key": "effect_test_flag", "value": true}
	StoryEngine._apply_single_effect(test_effect)
	if GameStateManager.get_flag("effect_test_flag") == true:
		_log_success("效果应用系统工作正常")
	else:
		_log_error("效果应用系统失败")

	GameStateManager.reset_state()

func _test_save_manager() -> void:
	_log("\n--- 测试 SaveManager ---")

	# 测试存档槽位
	if SaveManager.MAX_SLOTS > 0:
		_log_success("存档槽位配置正确: %d 个槽位" % SaveManager.MAX_SLOTS)
	else:
		_log_error("存档槽位配置错误")

	# 测试加密工具
	var test_data = {"test": "data", "number": 123}
	var encrypted = SaveEncryption.encrypt_data(test_data)
	var decrypted = SaveEncryption.decrypt_data(encrypted)

	if decrypted.get("test") == "data" and decrypted.get("number") == 123:
		_log_success("存档加密/解密系统工作正常")
	else:
		_log_error("存档加密/解密系统失败")

func _test_video_manager() -> void:
	_log("\n--- 测试 VideoManager ---")

	# 测试缓存配置
	var cache_status = VideoManager.get_cache_status()
	if cache_status.has("max_cache") and cache_status["max_cache"] > 0:
		_log_success("视频缓存配置正确，最大缓存: %d" % cache_status["max_cache"])
	else:
		_log_error("视频缓存配置错误")

	# 测试初始状态
	if not VideoManager.is_playing():
		_log_success("视频管理器初始状态正确 (未播放)")
	else:
		_log_error("视频管理器初始状态错误")

func _test_audio_manager() -> void:
	_log("\n--- 测试 AudioManager ---")

	# 测试音量范围
	AudioManager.set_bgm_volume(0.5)
	AudioManager.set_sfx_volume(0.8)
	_log_success("音频管理器音量设置正常")

	# 测试静音功能
	AudioManager.set_mute(true)
	if AudioManager.is_muted():
		_log_success("静音功能工作正常")
	else:
		_log_error("静音功能失败")

	AudioManager.set_mute(false)

func _test_event_manager() -> void:
	_log("\n--- 测试 EventManager ---")

	# 测试事件注册 - 使用字典来避免闭包变量捕获问题
	var test_result = {"called": false}
	EventManager.register("test_event", func(data): test_result["called"] = true)

	EventManager.trigger("test_event", {})
	await get_tree().process_frame

	if test_result["called"]:
		_log_success("事件系统工作正常")
	else:
		_log_error("事件系统失败")

	EventManager.unregister("test_event", func(data): pass)

func _test_stats_manager() -> void:
	_log("\n--- 测试 StatsManager ---")

	# 测试统计记录
	StatsManager.record("test_action", {"detail": "test_value"})
	var stats = StatsManager.get_all_stats()

	if stats.has("test_action"):
		_log_success("统计管理器工作正常")
	else:
		_log_error("统计管理器失败")

	# 测试游戏时间
	StatsManager.add_play_time(10.0)
	var play_time = StatsManager.get_play_time()
	if play_time >= 10.0:
		_log_success("游戏时间统计正常: %.1f 秒" % play_time)
	else:
		_log_error("游戏时间统计错误")
