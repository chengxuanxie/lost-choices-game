## 本地统计管理器 - 负责游戏统计数据
@warning_ignore("static_called_on_instance")
extends Node

## 统计数据
var _stats: Dictionary = {
	"total_play_time": 0.0,
	"chapters_completed": [],
	"endings_unlocked": [],
	"choices_made": 0,
	"videos_watched": 0,
	"first_play_date": "",
	"last_play_date": ""
}

func _ready() -> void:
	_load_stats()

	if _stats["first_play_date"].is_empty():
		_stats["first_play_date"] = Time.get_datetime_string_from_system()

	_stats["last_play_date"] = Time.get_datetime_string_from_system()
	_save_stats()

	print("[StatsManager] 统计管理器初始化完成")

#region 统计记录

## 记录统计事件
func record(event_name: String, value: Variant = null) -> void:
	match event_name:
		"play_time":
			_stats["total_play_time"] += float(value) if value else 0
		"chapter_complete":
			if value not in _stats["chapters_completed"]:
				_stats["chapters_completed"].append(value)
		"ending_unlock":
			if value not in _stats["endings_unlocked"]:
				_stats["endings_unlocked"].append(value)
		"choice_made":
			_stats["choices_made"] += 1
		"video_watched":
			_stats["videos_watched"] += 1
		"test_action":
			_stats["test_action"] = value

	_save_stats()

## 添加游戏时间
func add_play_time(seconds: float) -> void:
	_stats["total_play_time"] += seconds
	_save_stats()

## 获取游戏时间
func get_play_time() -> float:
	return _stats.get("total_play_time", 0.0)

#endregion

#region 统计查询

## 获取统计数据
func get_stats() -> Dictionary:
	return _stats.duplicate()

## 获取所有统计数据（别名）
func get_all_stats() -> Dictionary:
	return get_stats()

## 获取成就进度
func get_achievement_progress() -> Dictionary:
	return {
		"chapters_completed": _stats["chapters_completed"].size(),
		"endings_unlocked": _stats["endings_unlocked"].size(),
		"total_play_time_hours": _stats["total_play_time"] / 3600.0
	}

#endregion

#region 持久化

## 保存统计
func _save_stats() -> void:
	var save_path = _get_stats_path()
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_stats))
		file.close()

## 加载统计
func _load_stats() -> void:
	var save_path = _get_stats_path()
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		if file:
			var data = JSON.parse_string(file.get_as_text())
			if data != null:
				_stats = data
			file.close()

## 获取统计文件路径
func _get_stats_path() -> String:
	return "user://stats.json"

#endregion
