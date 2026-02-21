## 存档管理器 - 负责存档读写（单机版）
## 支持Web端IndexedDB和桌面端文件系统
@warning_ignore("static_called_on_instance")
extends Node

## 信号定义
signal save_completed(slot: int, success: bool)
signal load_completed(slot: int, success: bool)
signal save_deleted(slot: int)
signal auto_save_triggered()

## 配置
const SAVE_KEY_PREFIX: String = "lost_choices_save_"
const MAX_SLOTS: int = 5
const AUTO_SAVE_INTERVAL: float = 60.0  ## 自动存档间隔（秒）
const SAVE_VERSION: int = 1              ## 存档版本号

## 状态
var _auto_save_timer: float = 0.0
var _pending_save_data: Dictionary = {}

#region 初始化

func _ready() -> void:
	_auto_save_timer = AUTO_SAVE_INTERVAL
	print("[SaveManager] 存档管理器初始化完成")

func _process(delta: float) -> void:
	# 自动存档计时
	if GameManager.get_current_state() == GameManager.GameState.PLAYING:
		_auto_save_timer -= delta
		if _auto_save_timer <= 0:
			auto_save()
			_auto_save_timer = AUTO_SAVE_INTERVAL

#endregion

#region 存档操作

## 保存游戏
func save_game(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SLOTS:
		push_error("[SaveManager] 无效的存档槽位: %d" % slot)
		return false

	var save_data = _build_save_data()
	var json_string = JSON.stringify(save_data)
	var encrypted_data = SaveEncryption.encrypt(json_string)

	# 根据平台选择存储方式
	if OS.has_feature("web"):
		_save_to_indexed_db(slot, encrypted_data, save_data)
	else:
		_save_to_file(slot, encrypted_data)

	print("[SaveManager] 存档成功: 槽位 %d" % slot)
	save_completed.emit(slot, true)
	return true

## 构建存档数据
func _build_save_data() -> Dictionary:
	return {
		"version": SAVE_VERSION,
		"timestamp": Time.get_unix_time_from_system(),
		"chapter": StoryEngine.get_current_chapter(),
		"node": StoryEngine.get_current_node(),
		"flags": GameStateManager.get_all_flags(),
		"variables": GameStateManager.get_all_variables(),
		"items": GameStateManager.get_all_items(),
		"relationships": GameStateManager.get_all_relationships(),
		"history": GameStateManager.get_choice_history(),
		"achievements": [],  # TODO: 成就系统
		"play_time": GameManager.get_play_time(),
		"hash": ""  # 将在加密后计算
	}

## 加载游戏
func load_game(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SLOTS:
		push_error("[SaveManager] 无效的存档槽位: %d" % slot)
		return false

	var encrypted_data: String

	# 根据平台选择读取方式
	if OS.has_feature("web"):
		encrypted_data = await _load_from_indexed_db(slot)
	else:
		encrypted_data = _load_from_file(slot)

	if encrypted_data.is_empty():
		push_error("[SaveManager] 存档读取失败或存档为空")
		load_completed.emit(slot, false)
		return false

	# 解密并解析数据
	var json_string = SaveEncryption.decrypt(encrypted_data)
	var json = JSON.new()
	if json.parse(json_string) != OK:
		push_error("[SaveManager] 存档数据解析失败")
		load_completed.emit(slot, false)
		return false

	var save_data = json.data
	_apply_save_data(save_data)

	print("[SaveManager] 读档成功: 槽位 %d" % slot)
	load_completed.emit(slot, true)
	return true

## 应用存档数据
func _apply_save_data(save_data: Dictionary) -> void:
	# 加载游戏状态
	GameStateManager.load_state({
		"flags": save_data.get("flags", {}),
		"variables": save_data.get("variables", {}),
		"items": save_data.get("items", []),
		"relationships": save_data.get("relationships", {}),
		"choice_history": save_data.get("history", [])
	})

	# 恢复游戏时间
	GameManager._play_time = save_data.get("play_time", 0)

	# 跳转到存档节点
	var node = save_data.get("node", "")
	if not node.is_empty():
		StoryEngine.jump_to_node(node)

## 删除存档
func delete_save(slot: int) -> bool:
	if slot < 0 or slot >= MAX_SLOTS:
		return false

	if OS.has_feature("web"):
		_delete_from_indexed_db(slot)
	else:
		_delete_file(slot)

	print("[SaveManager] 存档已删除: 槽位 %d" % slot)
	save_deleted.emit(slot)
	return true

## 自动存档
func auto_save() -> void:
	save_game(0)  # 槽位0用于自动存档
	auto_save_triggered.emit()
	print("[SaveManager] 自动存档完成")

#endregion

#region 存档信息

## 获取存档信息
func get_save_info(slot: int) -> Dictionary:
	if OS.has_feature("web"):
		return _get_indexed_db_save_info(slot)
	else:
		return _get_file_save_info(slot)

## 检查存档是否存在
func save_exists(slot: int) -> bool:
	var info = get_save_info(slot)
	return not info.is_empty()

## 获取所有存档信息
func get_all_save_infos() -> Array:
	var infos = []
	for i in range(MAX_SLOTS):
		infos.append(get_save_info(i))
	return infos

#endregion

#region IndexedDB操作（Web端）

func _save_to_indexed_db(slot: int, data: String, save_data: Dictionary) -> void:
	var timestamp = Time.get_unix_time_from_system()
	JavaScriptBridge.eval("""
		(function() {
			var request = indexedDB.open('LostChoicesSaves', 1);
			request.onupgradeneeded = function(e) {
				var db = e.target.result;
				if (!db.objectStoreNames.contains('saves')) {
					db.createObjectStore('saves', {keyPath: 'slot'});
				}
			};
			request.onsuccess = function(e) {
				var db = e.target.result;
				var tx = db.transaction('saves', 'readwrite');
				var store = tx.objectStore('saves');
				store.put({
					slot: %d,
					data: '%s',
					timestamp: %d,
					chapter: '%s',
					play_time: %f
				});
			};
			request.onerror = function(e) {
				console.error('IndexedDB save error:', e);
			};
		})();
	""" % [slot, data.replace("'", "\\'"), timestamp, save_data.get("chapter", ""), save_data.get("play_time", 0)])

func _load_from_indexed_db(slot: int) -> String:
	var result = JavaScriptBridge.eval("""
		(function() {
			return new Promise(function(resolve) {
				var request = indexedDB.open('LostChoicesSaves', 1);
				request.onsuccess = function(e) {
					var db = e.target.result;
					var tx = db.transaction('saves', 'readonly');
					var store = tx.objectStore('saves');
					var getRequest = store.get(%d);
					getRequest.onsuccess = function(e) {
						resolve(e.target.result ? e.target.result.data : '');
					};
					getRequest.onerror = function() {
						resolve('');
					};
				};
				request.onerror = function() {
					resolve('');
				};
			});
		})();
	""" % [slot])

	# JavaScriptBridge.eval 返回的是 Promise，需要等待
	# 这里简化处理，实际项目中需要更完善的异步处理
	return result if result else ""

func _delete_from_indexed_db(slot: int) -> void:
	JavaScriptBridge.eval("""
		(function() {
			var request = indexedDB.open('LostChoicesSaves', 1);
			request.onsuccess = function(e) {
				var db = e.target.result;
				var tx = db.transaction('saves', 'readwrite');
				var store = tx.objectStore('saves');
				store.delete(%d);
			};
		})();
	""" % [slot])

func _get_indexed_db_save_info(slot: int) -> Dictionary:
	var result = JavaScriptBridge.eval("""
		(function() {
			return new Promise(function(resolve) {
				var request = indexedDB.open('LostChoicesSaves', 1);
				request.onsuccess = function(e) {
					var db = e.target.result;
					var tx = db.transaction('saves', 'readonly');
					var store = tx.objectStore('saves');
					var getRequest = store.get(%d);
					getRequest.onsuccess = function(e) {
						var result = e.target.result;
						if (result) {
							resolve(JSON.stringify({
								slot: result.slot,
								timestamp: result.timestamp,
								chapter: result.chapter,
								play_time: result.play_time
							}));
						} else {
							resolve('');
						}
					};
				};
			});
		})();
	""" % [slot])

	if result.is_empty():
		return {}

	var json = JSON.new()
	if json.parse(result) == OK:
		return json.data
	return {}

#endregion

#region 文件操作（桌面端）

func _save_to_file(slot: int, data: String) -> void:
	var save_dir = OS.get_user_data_dir() + "/saves"
	DirAccess.make_dir_recursive_absolute(save_dir)

	var file = FileAccess.open(save_dir + "/slot_%d.save" % slot, FileAccess.WRITE)
	if file:
		file.store_string(data)
		file.close()

func _load_from_file(slot: int) -> String:
	var save_path = OS.get_user_data_dir() + "/saves/slot_%d.save" % slot
	if not FileAccess.file_exists(save_path):
		return ""

	var file = FileAccess.open(save_path, FileAccess.READ)
	if file:
		var data = file.get_as_text()
		file.close()
		return data
	return ""

func _delete_file(slot: int) -> void:
	var save_path = OS.get_user_data_dir() + "/saves/slot_%d.save" % slot
	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)

func _get_file_save_info(slot: int) -> Dictionary:
	var save_path = OS.get_user_data_dir() + "/saves/slot_%d.save" % slot
	if not FileAccess.file_exists(save_path):
		return {}

	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		return {}

	var encrypted_data = file.get_as_text()
	file.close()

	if encrypted_data.is_empty():
		return {}

	var json_string = SaveEncryption.decrypt(encrypted_data)
	var json = JSON.new()
	if json.parse(json_string) != OK:
		return {}

	var save_data = json.data
	return {
		"slot": slot,
		"timestamp": save_data.get("timestamp", 0),
		"chapter": save_data.get("chapter", ""),
		"play_time": save_data.get("play_time", 0)
	}

#endregion
