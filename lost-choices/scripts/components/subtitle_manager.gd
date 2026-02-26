## 字幕管理器 - 负责字幕显示和时间轴同步
## 支持从JSON数据加载字幕，与视频播放同步显示
class_name SubtitleManager
extends Node

## 信号
signal subtitle_changed(text: String, speaker: String)
signal subtitle_cleared()

## 配置
@export var auto_clear_delay: float = 0.5  ## 字幕结束后自动清除延迟

## 状态
var _subtitles: Array = []          ## 字幕数据列表
var _current_index: int = -1        ## 当前字幕索引
var _is_active: bool = false        ## 是否激活
var _video_player: VideoStreamPlayer  ## 视频播放器引用

#region 初始化

func _ready() -> void:
	print("[SubtitleManager] 字幕管理器初始化完成")

#endregion

#region 公共方法

## 设置视频播放器引用
func set_video_player(player: VideoStreamPlayer) -> void:
	_video_player = player

## 加载字幕数据
func load_subtitles(subtitles: Array) -> void:
	_subtitles = subtitles
	_current_index = -1
	_sort_subtitles()
	print("[SubtitleManager] 加载 %d 条字幕" % subtitles.size())

## 从节点数据加载字幕
func load_from_node(node_data: Dictionary) -> void:
	var subtitles = node_data.get("subtitles", [])
	load_subtitles(subtitles)

## 开始字幕显示
func start() -> void:
	_is_active = true
	_current_index = -1

## 停止字幕显示
func stop() -> void:
	_is_active = false
	_current_index = -1
	subtitle_cleared.emit()

## 更新字幕 (每帧调用)
func update(current_time: float) -> void:
	if not _is_active or _subtitles.is_empty():
		return

	# 查找当前时间对应的字幕
	var found_index = _find_subtitle_index(current_time)

	if found_index != _current_index and found_index >= 0:
		_current_index = found_index
		var subtitle = _subtitles[found_index]
		var text = subtitle.get("text", "")
		var speaker = subtitle.get("speaker", "")
		subtitle_changed.emit(text, speaker)
	elif found_index < 0 and _current_index >= 0:
		# 当前没有字幕，清除显示
		_current_index = -1
		subtitle_cleared.emit()

## 获取当前字幕文本
func get_current_subtitle() -> String:
	if _current_index >= 0 and _current_index < _subtitles.size():
		return _subtitles[_current_index].get("text", "")
	return ""

## 获取当前说话者
func get_current_speaker() -> String:
	if _current_index >= 0 and _current_index < _subtitles.size():
		return _subtitles[_current_index].get("speaker", "")
	return ""

## 是否有字幕数据
func has_subtitles() -> bool:
	return not _subtitles.is_empty()

## 获取字幕总数
func get_subtitle_count() -> int:
	return _subtitles.size()

#endregion

#region 私有方法

## 排序字幕 (按时间)
func _sort_subtitles() -> void:
	_subtitles.sort_custom(func(a, b): return a.get("time", 0) < b.get("time", 0))

## 查找字幕索引
func _find_subtitle_index(current_time: float) -> int:
	for i in range(_subtitles.size()):
		var subtitle = _subtitles[i]
		var start_time = subtitle.get("time", 0.0)
		var end_time = subtitle.get("time_end", start_time + 5.0)  # 默认5秒

		# 如果没有end_time，使用下一条字幕的开始时间或默认5秒
		if not subtitle.has("time_end"):
			if i + 1 < _subtitles.size():
				end_time = _subtitles[i + 1].get("time", start_time + 5.0) - 0.1
			else:
				end_time = start_time + 5.0

		if current_time >= start_time and current_time < end_time:
			return i

	return -1

#endregion

#region 静态方法

## 从JSON文件加载字幕
static func load_from_json(json_path: String) -> Array:
	if not ResourceLoader.exists(json_path):
		return []

	var file = FileAccess.open(json_path, FileAccess.READ)
	if not file:
		return []

	var json_string = file.get_as_text()
	var json = JSON.new()
	if json.parse(json_string) != OK:
		return []

	var data = json.data
	return data.get("subtitles", [])

#endregion
