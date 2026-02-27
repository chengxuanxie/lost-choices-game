## 本地统计管理器 - 负责游戏统计数据和成就系统
@warning_ignore("static_called_on_instance")
extends Node

## 信号
signal achievement_unlocked(achievement_id: String)
signal achievement_progress_updated(achievement_id: String, progress: float)

## 成就定义
const ACHIEVEMENTS: Array = [
	{
		"id": "first_step",
		"name": "第一步",
		"description": "完成第一章",
		"icon": "res://assets/ui/icons/achievement_first_step.png",
		"type": "chapter_complete",
		"target": "chapter_01"
	},
	{
		"id": "trusting_heart",
		"name": "信任的心",
		"description": "选择相信林晓薇",
		"icon": "res://assets/ui/icons/achievement_trusting.png",
		"type": "flag",
		"target": "trust_lin_xiaowei"
	},
	{
		"id": "independent_spirit",
		"name": "独立精神",
		"description": "选择独自探索3次",
		"icon": "res://assets/ui/icons/achievement_independent.png",
		"type": "variable",
		"target": "independent_count",
		"threshold": 3
	},
	{
		"id": "memory_seeker",
		"name": "记忆追寻者",
		"description": "收集3个记忆碎片",
		"icon": "res://assets/ui/icons/achievement_memory.png",
		"type": "variable",
		"target": "memory_fragments",
		"threshold": 3
	},
	{
		"id": "ending_lover",
		"name": "结局爱好者",
		"description": "解锁所有结局",
		"icon": "res://assets/ui/icons/achievement_ending.png",
		"type": "endings_all",
		"target": 5
	},
	{
		"id": "choice_master",
		"description": "做出50个选择",
		"icon": "res://assets/ui/icons/achievement_choice.png",
		"type": "counter",
		"target": "choices_made",
		"threshold": 50
	},
	{
		"id": "video_enthusiast",
		"name": "视频爱好者",
		"description": "观看10个视频",
		"icon": "res://assets/ui/icons/achievement_video.png",
		"type": "counter",
		"target": "videos_watched",
		"threshold": 10
	},
	{
		"id": "art_resonance",
		"name": "艺术共鸣",
		"description": "与沈墨染建立深厚友谊",
		"icon": "res://assets/ui/icons/achievement_art.png",
		"type": "relationship",
		"target": "shen_moran",
		"threshold": 50
	},
	{
		"id": "healing_heart",
		"name": "治愈之心",
		"description": "接受白芷瑶的帮助",
		"icon": "res://assets/ui/icons/achievement_healing.png",
		"type": "flag",
		"target": "accept_bai_help"
	},
	{
		"id": "dangerous_alliance",
		"name": "危险联盟",
		"description": "与叶清寒结盟",
		"icon": "res://assets/ui/icons/achievement_danger.png",
		"type": "flag",
		"target": "ye_qinghan_ally"
	}
]

## 统计数据
var _stats: Dictionary = {
	"total_play_time": 0.0,
	"chapters_completed": [],
	"endings_unlocked": [],
	"choices_made": 0,
	"videos_watched": 0,
	"achievements_unlocked": [],
	"first_play_date": "",
	"last_play_date": ""
}

func _ready() -> void:
	_load_stats()

	if _stats["first_play_date"].is_empty():
		_stats["first_play_date"] = Time.get_datetime_string_from_system()

	_stats["last_play_date"] = Time.get_datetime_string_from_system()
	_save_stats()

	# 连接GameStateManager信号用于成就检测
	if GameStateManager:
		GameStateManager.flag_changed.connect(_on_flag_changed)
		GameStateManager.variable_changed.connect(_on_variable_changed)
		GameStateManager.relationship_changed.connect(_on_relationship_changed)

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

#region 成就系统

## 获取所有成就定义
func get_all_achievements() -> Array:
	return ACHIEVEMENTS

## 获取成就数据
func get_achievement(achievement_id: String) -> Dictionary:
	for achievement in ACHIEVEMENTS:
		if achievement.get("id") == achievement_id:
			return achievement
	return {}

## 检查成就是否已解锁
func is_achievement_unlocked(achievement_id: String) -> bool:
	return achievement_id in _stats.get("achievements_unlocked", [])

## 解锁成就
func unlock_achievement(achievement_id: String) -> bool:
	if is_achievement_unlocked(achievement_id):
		return false

	_stats["achievements_unlocked"].append(achievement_id)
	_save_stats()

	achievement_unlocked.emit(achievement_id)
	print("[StatsManager] 成就解锁: %s" % achievement_id)
	return true

## 获取已解锁成就列表
func get_unlocked_achievements() -> Array:
	return _stats.get("achievements_unlocked", [])

## 获取成就进度百分比
func get_achievement_progress_percentage() -> float:
	if ACHIEVEMENTS.is_empty():
		return 0.0
	return float(_stats.get("achievements_unlocked", []).size()) / float(ACHIEVEMENTS.size()) * 100.0

## 检查并更新成就
func check_achievements() -> void:
	for achievement in ACHIEVEMENTS:
		var achievement_id = achievement.get("id")
		if is_achievement_unlocked(achievement_id):
			continue

		var achievement_type = achievement.get("type")
		var target = achievement.get("target")

		match achievement_type:
			"flag":
				if GameStateManager.get_flag(target, false):
					unlock_achievement(achievement_id)
			"variable":
				var threshold = achievement.get("threshold", 1)
				var value = GameStateManager.get_variable(target, 0)
				if value >= threshold:
					unlock_achievement(achievement_id)
				else:
					achievement_progress_updated.emit(achievement_id, float(value) / float(threshold))
			"relationship":
				var threshold = achievement.get("threshold", 1)
				var value = GameStateManager.get_relationship(target, 0)
				if value >= threshold:
					unlock_achievement(achievement_id)
				else:
					achievement_progress_updated.emit(achievement_id, float(value) / float(threshold))
			"counter":
				var threshold = achievement.get("threshold", 1)
				var value = _stats.get(target, 0)
				if value >= threshold:
					unlock_achievement(achievement_id)
				else:
					achievement_progress_updated.emit(achievement_id, float(value) / float(threshold))
			"chapter_complete":
				if target in _stats.get("chapters_completed", []):
					unlock_achievement(achievement_id)
			"endings_all":
				var required = achievement.get("target", 5)
				if _stats.get("endings_unlocked", []).size() >= required:
					unlock_achievement(achievement_id)

## 信号回调
func _on_flag_changed(flag_name: String, value: bool) -> void:
	check_achievements()

func _on_variable_changed(var_name: String, value: int) -> void:
	check_achievements()

func _on_relationship_changed(character: String, value: int) -> void:
	check_achievements()

#endregion
