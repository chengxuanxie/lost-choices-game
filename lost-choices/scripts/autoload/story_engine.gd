## 剧情引擎 - 负责剧情流程控制
## 管理剧情节点、分支选择、条件判断和状态影响
class_name StoryEngine extends Node

## 信号定义
signal story_started(chapter_id: String)
signal story_ended(ending_id: String)
signal node_changed(node_id: String, node_data: Dictionary)
signal choices_available(choices: Array)
signal choice_made(choice_id: String, choice_data: Dictionary)
signal condition_failed(condition: Dictionary)
signal effect_applied(effect: Dictionary)

## 配置
const STORY_DATA_PATH: String = "res://data/stories/"
const CHAPTER_INDEX_FILE: String = "chapters_index.json"

## 状态变量
var _current_chapter: String = ""
var _current_node: String = ""
var _story_data: Dictionary = {}
var _chapters_index: Dictionary = {}
var _visited_nodes: Array = []
var _is_story_active: bool = false

#region 初始化

func _ready() -> void:
	_load_chapters_index()
	print("[StoryEngine] 剧情引擎初始化完成")

## 加载章节索引
func _load_chapters_index() -> void:
	var path = STORY_DATA_PATH + CHAPTER_INDEX_FILE
	if ResourceLoader.exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			if json.parse(json_string) == OK:
				_chapters_index = json.data
				print("[StoryEngine] 章节索引加载成功，共 %d 章" % _chapters_index.get("chapters", []).size())

#endregion

#region 章节管理

## 开始章节
func start_chapter(chapter_id: String) -> void:
	if _is_story_active:
		end_current_story()

	_current_chapter = chapter_id
	_load_chapter_data(chapter_id)

	var start_node = _story_data.get("start_node", "")
	if start_node.is_empty():
		push_error("[StoryEngine] 章节缺少起始节点: %s" % chapter_id)
		return

	_is_story_active = true
	_visited_nodes.clear()

	jump_to_node(start_node)
	story_started.emit(chapter_id)

	print("[StoryEngine] 开始章节: %s, 起始节点: %s" % [chapter_id, start_node])

## 加载章节数据
func _load_chapter_data(chapter_id: String) -> void:
	var path = STORY_DATA_PATH + chapter_id + ".json"
	if not ResourceLoader.exists(path):
		push_error("[StoryEngine] 章节数据不存在: %s" % path)
		return

	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		var json = JSON.new()
		if json.parse(json_string) == OK:
			_story_data = json.data
			print("[StoryEngine] 章节数据加载成功: %s" % chapter_id)

## 结束当前故事
func end_current_story() -> void:
	_is_story_active = false
	_current_chapter = ""
	_current_node = ""
	_story_data.clear()
	_visited_nodes.clear()

	print("[StoryEngine] 当前故事结束")

#endregion

#region 节点管理

## 跳转到节点
func jump_to_node(node_id: String) -> void:
	var node_data = get_node_data(node_id)
	if node_data.is_empty():
		push_error("[StoryEngine] 节点不存在: %s" % node_id)
		return

	_current_node = node_id
	_visited_nodes.append(node_id)

	# 触发节点事件
	_trigger_node_events(node_data)

	# 发送节点变更信号
	node_changed.emit(node_id, node_data)

	# 处理节点类型
	var node_type = node_data.get("node_type", "video")
	match node_type:
		"video":
			_handle_video_node(node_data)
		"choice":
			_handle_choice_node(node_data)
		"ending":
			_handle_ending_node(node_data)
		"auto":
			_handle_auto_node(node_data)

	print("[StoryEngine] 跳转到节点: %s (类型: %s)" % [node_id, node_type])

## 获取节点数据
func get_node_data(node_id: String) -> Dictionary:
	var nodes = _story_data.get("nodes", {})
	return nodes.get(node_id, {})

## 获取当前节点ID
func get_current_node() -> String:
	return _current_node

## 获取当前章ID
func get_current_chapter() -> String:
	return _current_chapter

## 获取可能的下一节点
func get_possible_next_nodes(node_id: String = "") -> Array:
	var target_node = node_id if node_id else _current_node
	var node_data = get_node_data(target_node)
	var possible_nodes = []

	# 从选择中获取
	var choices = node_data.get("choices", [])
	for choice in choices:
		var next_node = choice.get("next_node", "")
		if not next_node.is_empty() and next_node not in possible_nodes:
			possible_nodes.append(next_node)

	# 从自动跳转获取
	var auto_next = node_data.get("auto_next", "")
	if not auto_next.is_empty() and auto_next not in possible_nodes:
		possible_nodes.append(auto_next)

	return possible_nodes

## 获取视频ID
func get_video_id(node_id: String) -> String:
	var node_data = get_node_data(node_id)
	var video_data = node_data.get("video", {})
	return video_data.get("id", "")

#endregion

#region 节点处理

## 处理视频节点
func _handle_video_node(node_data: Dictionary) -> void:
	var video_data = node_data.get("video", {})
	var video_id = video_data.get("id", "")

	if video_id.is_empty():
		push_error("[StoryEngine] 视频节点缺少视频ID")
		return

	# 请求播放视频
	VideoManager.play_video(video_id)

	# 预加载下一个视频
	VideoManager.preload_next_videos(_current_node)

## 处理选择节点
func _handle_choice_node(node_data: Dictionary) -> void:
	var video_data = node_data.get("video", {})
	var video_id = video_data.get("id", "")

	# 先播放视频
	if not video_id.is_empty():
		VideoManager.play_video(video_id)

	# 获取可用选择
	var available_choices = _get_available_choices(node_data)
	choices_available.emit(available_choices)

## 处理结局节点
func _handle_ending_node(node_data: Dictionary) -> void:
	var ending_id = node_data.get("ending_id", "unknown")
	var ending_name = node_data.get("ending_name", "未知结局")

	print("[StoryEngine] 达成结局: %s (%s)" % [ending_name, ending_id])

	# 记录结局
	StatsManager.record("ending_unlock", ending_id)

	# 发送结局信号
	story_ended.emit(ending_id)

## 处理自动节点
func _handle_auto_node(node_data: Dictionary) -> void:
	var auto_next = node_data.get("auto_next", "")
	if not auto_next.is_empty():
		# 等待视频完成后自动跳转
		await VideoManager.video_completed
		jump_to_node(auto_next)

#endregion

#region 选择系统

## 获取可用选择
func _get_available_choices(node_data: Dictionary) -> Array:
	var all_choices = node_data.get("choices", [])
	var available = []

	for choice in all_choices:
		if _check_conditions(choice.get("conditions", [])):
			available.append(choice)

	return available

## 做出选择
func make_choice(choice_index: int) -> void:
	var node_data = get_node_data(_current_node)
	var available_choices = _get_available_choices(node_data)

	if choice_index < 0 or choice_index >= available_choices.size():
		push_error("[StoryEngine] 无效的选择索引: %d" % choice_index)
		return

	var choice = available_choices[choice_index]
	var choice_id = choice.get("id", "unknown")

	# 应用效果
	_apply_effects(choice.get("effects", []))

	# 记录选择
	GameStateManager.record_choice(choice_id)

	# 发送选择信号
	choice_made.emit(choice_id, choice)

	print("[StoryEngine] 做出选择: %s" % choice_id)

	# 跳转到下一节点
	var next_node = choice.get("next_node", "")
	if not next_node.is_empty():
		jump_to_node(next_node)

## 做出选择（通过ID）
func make_choice_by_id(choice_id: String) -> void:
	var node_data = get_node_data(_current_node)
	var all_choices = node_data.get("choices", [])

	for i in range(all_choices.size()):
		if all_choices[i].get("id", "") == choice_id:
			make_choice(i)
			return

	push_error("[StoryEngine] 选择不存在: %s" % choice_id)

#endregion

#region 条件系统

## 检查条件
func _check_conditions(conditions: Array) -> bool:
	for condition in conditions:
		if not _check_single_condition(condition):
			condition_failed.emit(condition)
			return false
	return true

## 检查单个条件
func _check_single_condition(condition: Dictionary) -> bool:
	var condition_type = condition.get("type", "")

	match condition_type:
		"flag":
			var required_value = condition.get("value", true)
			var actual_value = GameStateManager.get_flag(condition.get("key", ""), false)
			return actual_value == required_value

		"variable":
			var actual_value = GameStateManager.get_variable(condition.get("key", ""), 0)
			var compare_value = condition.get("value", 0)
			var operator = condition.get("operator", "==")
			return _compare_values(actual_value, operator, compare_value)

		"relationship":
			var character = condition.get("character", "")
			var required_value = condition.get("value", 0)
			var operator = condition.get("operator", ">=")
			var actual_value = GameStateManager.get_relationship(character)
			return _compare_values(actual_value, operator, required_value)

		"item":
			return GameStateManager.has_item(condition.get("item_id", ""))

		"visited":
			return condition.get("node_id", "") in _visited_nodes

		_:
			push_warning("[StoryEngine] 未知条件类型: %s" % condition_type)
			return true

## 比较值
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

#region 效果系统

## 应用效果
func _apply_effects(effects: Array) -> void:
	for effect in effects:
		_apply_single_effect(effect)

## 应用单个效果
func _apply_single_effect(effect: Dictionary) -> void:
	var effect_type = effect.get("type", "")

	match effect_type:
		"set_flag":
			GameStateManager.set_flag(effect.get("key", ""), effect.get("value", true))

		"set_variable":
			GameStateManager.set_variable(effect.get("key", ""), effect.get("value", 0))

		"modify_variable":
			GameStateManager.modify_variable(effect.get("key", ""), effect.get("value", 0))

		"modify_relationship":
			GameStateManager.modify_relationship(
				effect.get("character", ""),
				effect.get("value", 0)
			)

		"add_item":
			GameStateManager.add_item(effect.get("item_id", ""))

		"remove_item":
			GameStateManager.remove_item(effect.get("item_id", ""))

		"trigger_event":
			EventManager.trigger(effect.get("event_id", ""), effect.get("data", {}))

		_:
			push_warning("[StoryEngine] 未知效果类型: %s" % effect_type)

	effect_applied.emit(effect)

#endregion

#region 事件系统

## 触发节点事件
func _trigger_node_events(node_data: Dictionary) -> void:
	var events = node_data.get("events", [])
	for event in events:
		_schedule_event(event)

## 安排事件
func _schedule_event(event: Dictionary) -> void:
	var trigger_time = event.get("time", 0.0)
	var event_type = event.get("type", "")
	var event_data = event.get("data", {})

	# 等待视频播放到指定时间
	await get_tree().create_timer(trigger_time).timeout

	# 触发事件
	EventManager.trigger(event_type, event_data)

#endregion

#region 工具方法

## 是否故事活跃
func is_story_active() -> bool:
	return _is_story_active

## 获取已访问节点
func get_visited_nodes() -> Array:
	return _visited_nodes.duplicate()

## 检查节点是否已访问
func is_node_visited(node_id: String) -> bool:
	return node_id in _visited_nodes

## 获取章节进度
func get_chapter_progress() -> Dictionary:
	var total_nodes = _story_data.get("stats", {}).get("total_nodes", 0)
	return {
		"visited": _visited_nodes.size(),
		"total": total_nodes,
		"percentage": float(_visited_nodes.size()) / float(max(total_nodes, 1)) * 100.0
	}

#endregion
