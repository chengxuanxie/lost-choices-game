## 游戏状态管理器 - 负责游戏全局状态
## 管理标记、变量、物品、好感度、选择历史等
@warning_ignore("static_called_on_instance")
extends Node

## 信号定义
signal state_changed(key: String, value: Variant)
signal flag_changed(key: String, value: bool)
signal variable_changed(key: String, value: float)
signal relationship_changed(character: String, value: int)
signal item_added(item_id: String)
signal item_removed(item_id: String)

## 常量
const INITIAL_RELATIONSHIP: int = 50  ## 初始好感度

## 状态数据
var _flags: Dictionary = {}          ## 布尔标记
var _variables: Dictionary = {}      ## 数值变量
var _items: Array = []               ## 物品列表
var _relationships: Dictionary = {}  ## NPC好感度
var _choice_history: Array = []      ## 选择历史

#region 标记管理

## 设置标记
func set_flag(key: String, value: Variant) -> void:
	var old_value = _flags.get(key)
	_flags[key] = value

	if old_value != value:
		state_changed.emit(key, value)
		flag_changed.emit(key, bool(value))
		print("[GameStateManager] 标记变更: %s = %s" % [key, value])

## 获取标记
func get_flag(key: String, default: Variant = false) -> Variant:
	return _flags.get(key, default)

## 检查标记
func has_flag(key: String) -> bool:
	return _flags.has(key)

## 清除标记
func clear_flag(key: String) -> void:
	_flags.erase(key)

#endregion

#region 变量管理

## 设置变量
func set_variable(key: String, value: Variant) -> void:
	var old_value = _variables.get(key)
	_variables[key] = value

	if old_value != value:
		state_changed.emit(key, value)
		variable_changed.emit(key, float(value))
		print("[GameStateManager] 变量变更: %s = %s" % [key, value])

## 获取变量
func get_variable(key: String, default: Variant = 0) -> Variant:
	return _variables.get(key, default)

## 修改变量
func modify_variable(key: String, delta: float) -> void:
	var current = get_variable(key, 0)
	set_variable(key, current + delta)

## 删除变量
func delete_variable(key: String) -> void:
	_variables.erase(key)

#endregion

#region 物品管理

## 添加物品
func add_item(item_id: String, count: int = 1) -> void:
	for i in count:
		_items.append(item_id)

	item_added.emit(item_id)
	print("[GameStateManager] 添加物品: %s x%d" % [item_id, count])

## 移除物品
func remove_item(item_id: String, count: int = 1) -> bool:
	var removed = 0
	for i in range(_items.size() - 1, -1, -1):
		if _items[i] == item_id and removed < count:
			_items.remove_at(i)
			removed += 1

	if removed > 0:
		item_removed.emit(item_id)
		print("[GameStateManager] 移除物品: %s x%d" % [item_id, removed])
		return true

	return false

## 检查物品
func has_item(item_id: String) -> bool:
	return item_id in _items

## 获取物品数量
func get_item_count(item_id: String) -> int:
	var count = 0
	for item in _items:
		if item == item_id:
			count += 1
	return count

## 获取所有物品
func get_all_items() -> Array:
	return _items.duplicate()

#endregion

#region 好感度管理

## 获取好感度
func get_relationship(character: String) -> int:
	return _relationships.get(character, INITIAL_RELATIONSHIP)

## 设置好感度
func set_relationship(character: String, value: int) -> void:
	var clamped_value = clamp(value, 0, 100)
	_relationships[character] = clamped_value
	relationship_changed.emit(character, clamped_value)
	print("[GameStateManager] 好感度变更: %s = %d" % [character, clamped_value])

## 修改好感度
func modify_relationship(character: String, delta: int) -> void:
	var current = get_relationship(character)
	set_relationship(character, current + delta)

## 获取好感度等级
func get_relationship_level(character: String) -> int:
	var value = get_relationship(character)
	if value >= 81: return 4  ## 深情/忠诚
	if value >= 61: return 3  ## 亲密/深信
	if value >= 41: return 2  ## 信任/友好
	if value >= 21: return 1  ## 初步信任
	return 0  ## 警惕/疏离

## 获取好感度等级名称
func get_relationship_level_name(character: String) -> String:
	var level = get_relationship_level(character)
	match level:
		4: return "深情"
		3: return "亲密"
		2: return "信任"
		1: return "初步信任"
		_: return "警惕"

## 获取所有好感度
func get_all_relationships() -> Dictionary:
	return _relationships.duplicate()

#endregion

#region 选择历史

## 记录选择
func record_choice(choice_id: String) -> void:
	var record = {
		"choice_id": choice_id,
		"timestamp": Time.get_unix_time_from_system(),
		"chapter": StoryEngine.get_current_chapter(),
		"node": StoryEngine.get_current_node()
	}
	_choice_history.append(record)
	print("[GameStateManager] 记录选择: %s" % choice_id)

## 获取选择历史
func get_choice_history() -> Array:
	return _choice_history.duplicate()

## 检查是否做过某选择
func has_made_choice(choice_id: String) -> bool:
	for record in _choice_history:
		if record.choice_id == choice_id:
			return true
	return false

## 获取选择次数
func get_choice_count() -> int:
	return _choice_history.size()

#endregion

#region 存档支持

## 获取完整状态
func get_full_state() -> Dictionary:
	return {
		"flags": _flags.duplicate(),
		"variables": _variables.duplicate(),
		"items": _items.duplicate(),
		"relationships": _relationships.duplicate(),
		"choice_history": _choice_history.duplicate()
	}

## 加载状态
func load_state(state: Dictionary) -> void:
	_flags = state.get("flags", {}).duplicate()
	_variables = state.get("variables", {}).duplicate()
	_items = state.get("items", []).duplicate()
	_relationships = state.get("relationships", {}).duplicate()
	_choice_history = state.get("choice_history", []).duplicate()

	print("[GameStateManager] 状态加载完成")

## 重置状态
func reset_state() -> void:
	_flags.clear()
	_variables.clear()
	_items.clear()
	_relationships.clear()
	_choice_history.clear()

	print("[GameStateManager] 状态已重置")

#endregion

#region 导出方法（供存档管理器使用）

func get_all_flags() -> Dictionary:
	return _flags.duplicate()

func get_all_variables() -> Dictionary:
	return _variables.duplicate()

#endregion
