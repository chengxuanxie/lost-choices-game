## 本地统计管理器 - 负责游戏统计数据
class_name StatsManager extends Node

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

## 记录统计事件
static func record(event_name: String, value: Variant = null) -> void:
	var stats = _get_instance()
	if stats == null:
		return

	match event_name:
		"play_time":
			stats._stats["total_play_time"] += float(value) if value else 0
		"chapter_complete":
			if value not in stats._stats["chapters_completed"]:
				stats._stats["chapters_completed"].append(value)
		"ending_unlock":
			if value not in stats._stats["endings_unlocked"]:
				stats._stats["endings_unlocked"].append(value)
		"choice_made":
			stats._stats["choices_made"] += 1
		"video_watched":
			stats._stats["videos_watched"] += 1

	stats._save_stats()

## 获取统计数据
static func get_stats() -> Dictionary:
	var stats = _get_instance()
	if stats:
		return stats._stats.duplicate()
	return {}

## 获取成就进度
static func get_achievement_progress() -> Dictionary:
	var stats = _get_instance()
	if stats == null:
		return {}

	return {
		"chapters_completed": stats._stats["chapters_completed"].size(),
		"endings_unlocked": stats._stats["endings_unlocked"].size(),
		"total_play_time_hours": stats._stats["total_play_time"] / 3600.0
	}

## 获取单例实例
static func _get_instance() -> Node:
	return Engine.get_singleton("StatsManager")

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

func _ready() -> void:
	_load_stats()

	if _stats["first_play_date"].is_empty():
		_stats["first_play_date"] = Time.get_datetime_string_from_system()

	_stats["last_play_date"] = Time.get_datetime_string_from_system()
	_save_stats()

	print("[StatsManager] 统计管理器初始化完成")
