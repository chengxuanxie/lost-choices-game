## 选择历史管理器 - 记录玩家选择并支持回溯
## 管理选择历史、分支导航、快速重玩功能
## 注意: 作为Autoload单例使用，不要使用class_name
extends Node

## 信号
signal history_updated(history: Array)
signal checkpoint_created(node_id: String)
signal checkpoint_restored(node_id: String)
signal replay_started(from_node_id: String)

## 选择历史记录
var _choice_history: Array = []
var _checkpoints: Dictionary = {}  # 节点ID -> 游戏状态快照
var _current_playthrough: int = 1

## 最大历史记录数
const MAX_HISTORY_SIZE := 100
const MAX_PLAYTHROUGHS := 10

func _ready() -> void:
	print("[ChoiceHistoryManager] 选择历史管理器初始化完成")

#region 历史记录

## 记录选择
func record_choice(node_id: String, choice_id: String, choice_index: int, next_node: String, effects: Array) -> void:
	var record = {
		"node_id": node_id,
		"choice_id": choice_id,
		"choice_index": choice_index,
		"next_node": next_node,
		"effects": effects,
		"playthrough": _current_playthrough,
		"timestamp": Time.get_unix_time_from_system()
	}

	_choice_history.append(record)

	# 限制历史大小
	if _choice_history.size() > MAX_HISTORY_SIZE:
		_choice_history.pop_front()

	history_updated.emit(_choice_history)
	print("[ChoiceHistoryManager] 记录选择: %s -> %s" % [node_id, next_node])

## 获取选择历史
func get_history() -> Array:
	return _choice_history.duplicate()

## 获取当前周目
func get_current_playthrough() -> int:
	return _current_playthrough

## 开始新的周目
func start_new_playthrough() -> void:
	_current_playthrough += 1
	if _current_playthrough > MAX_PLAYTHROUGHS:
		_current_playthrough = 1
	print("[ChoiceHistoryManager] 开始第 %d 周目" % _current_playthrough)

## 获取所有周目
func get_all_playthroughs() -> Array:
	var playthroughs: Array = []
	for record in _choice_history:
		var pt = record.get("playthrough", 1)
		if pt not in playthroughs:
			playthroughs.append(pt)
	playthroughs.sort()
	return playthroughs

## 获取指定周目的选择
func get_playthrough_choices(playthrough: int) -> Array:
	var result: Array = []
	for record in _choice_history:
		if record.get("playthrough", 1) == playthrough:
			result.append(record)
	return result

#endregion

#region 检查点系统

## 创建检查点（保存当前游戏状态）
func create_checkpoint(node_id: String) -> void:
	var checkpoint = {
		"node_id": node_id,
		"timestamp": Time.get_unix_time_from_system(),
		"playthrough": _current_playthrough,
		"history_index": _choice_history.size() - 1,
		"game_state": _capture_game_state()
	}

	_checkpoints[node_id] = checkpoint
	checkpoint_created.emit(node_id)
	print("[ChoiceHistoryManager] 创建检查点: %s" % node_id)

## 捕获当前游戏状态
func _capture_game_state() -> Dictionary:
	return {
		"flags": GameStateManager.get_all_flags().duplicate(),
		"variables": GameStateManager.get_all_variables().duplicate(),
		"relationships": GameStateManager.get_all_relationships().duplicate(),
		"items": GameStateManager.get_inventory().duplicate()
	}

## 恢复检查点
func restore_checkpoint(node_id: String) -> bool:
	if not _checkpoints.has(node_id):
		push_warning("[ChoiceHistoryManager] 检查点不存在: %s" % node_id)
		return false

	var checkpoint = _checkpoints[node_id]

	# 恢复游戏状态
	_restore_game_state(checkpoint.get("game_state", {}))

	# 设置当前周目
	_current_playthrough = checkpoint.get("playthrough", 1)

	# 截断历史到检查点
	var history_index = checkpoint.get("history_index", 0)
	if history_index < _choice_history.size():
		_choice_history.resize(history_index + 1)

	checkpoint_restored.emit(node_id)
	print("[ChoiceHistoryManager] 恢复检查点: %s" % node_id)
	return true

## 恢复游戏状态
func _restore_game_state(state: Dictionary) -> void:
	if state.has("flags"):
		for key in state["flags"]:
			GameStateManager.set_flag(key, state["flags"][key])

	if state.has("variables"):
		for key in state["variables"]:
			GameStateManager.set_variable(key, state["variables"][key])

	if state.has("relationships"):
		for key in state["relationships"]:
			GameStateManager.set_relationship(key, state["relationships"][key])

	if state.has("items"):
		GameStateManager.clear_inventory()
		for item in state["items"]:
			GameStateManager.add_item(item)

## 获取所有检查点
func get_checkpoints() -> Dictionary:
	return _checkpoints.duplicate()

## 检查点是否存在
func has_checkpoint(node_id: String) -> bool:
	return _checkpoints.has(node_id)

## 删除检查点
func remove_checkpoint(node_id: String) -> void:
	_checkpoints.erase(node_id)

## 清除所有检查点
func clear_checkpoints() -> void:
	_checkpoints.clear()

#endregion

#region 回溯功能

## 回溯到上一个选择节点
func go_back_to_last_choice() -> String:
	# 倒序查找最后一个有分支的节点
	for i in range(_choice_history.size() - 1, -1, -1):
		var record = _choice_history[i]
		var node_id = record.get("node_id", "")

		# 检查是否有检查点
		if _checkpoints.has(node_id):
			restore_checkpoint(node_id)
			return node_id

	return ""

## 获取回溯选项
func get_rollback_options() -> Array:
	var options: Array = []

	for i in range(_choice_history.size() - 1, -1, -1):
		var record = _choice_history[i]
		var node_id = record.get("node_id", "")
		var choice_text = record.get("choice_id", "")

		if _checkpoints.has(node_id):
			options.append({
				"node_id": node_id,
				"choice_id": choice_text,
				"history_index": i,
				"playthrough": record.get("playthrough", 1)
			})

	return options

#endregion

#region 重玩功能

## 从指定节点开始重玩
func replay_from_node(node_id: String) -> void:
	# 查找该节点对应的检查点
	if _checkpoints.has(node_id):
		restore_checkpoint(node_id)
	else:
		# 没有检查点，从头开始新周目
		start_new_playthrough()
		GameStateManager.reset_state()

	replay_started.emit(node_id)

## 获取可重玩的节点列表
func get_replayable_nodes() -> Array:
	var nodes: Array = []

	for checkpoint_key in _checkpoints:
		var checkpoint = _checkpoints[checkpoint_key]
		nodes.append({
			"node_id": checkpoint_key,
			"playthrough": checkpoint.get("playthrough", 1),
			"timestamp": checkpoint.get("timestamp", 0)
		})

	# 按时间排序
	nodes.sort_custom(func(a, b): return a["timestamp"] > b["timestamp"])

	return nodes

## 获取历史摘要（用于显示）
func get_history_summary() -> String:
	var summary = "第 %d 周目 | %d 个选择" % [_current_playthrough, _choice_history.size()]
	return summary

#endregion

#region 持久化

## 保存历史记录
func save_history() -> void:
	var save_data = {
		"choice_history": _choice_history,
		"checkpoints": _checkpoints,
		"current_playthrough": _current_playthrough
	}

	var path = _get_save_path()
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("[ChoiceHistoryManager] 历史记录已保存")

## 加载历史记录
func load_history() -> void:
	var path = _get_save_path()
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			if data != null:
				_choice_history = data.get("choice_history", [])
				_checkpoints = data.get("checkpoints", {})
				_current_playthrough = data.get("current_playthrough", 1)
				print("[ChoiceHistoryManager] 历史记录已加载: %d 条" % _choice_history.size())

## 获取保存路径
func _get_save_path() -> String:
	return "user://choice_history.json"

## 清除历史
func clear_history() -> void:
	_choice_history.clear()
	_checkpoints.clear()
	_current_playthrough = 1
	history_updated.emit(_choice_history)
	print("[ChoiceHistoryManager] 历史记录已清除")

#endregion
