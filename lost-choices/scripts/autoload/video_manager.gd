## 视频管理器 - 负责视频加载、播放、缓存（单机版）
## 管理所有视频资源的加载、预加载和播放控制
@warning_ignore("static_called_on_instance")
extends Node

## 信号定义
signal video_loaded(video_id: String)
signal video_error(video_id: String, error: String)
signal video_progress(video_id: String, progress: float)
signal video_completed(video_id: String)
signal video_started(video_id: String)

## 配置
const MAX_CACHE_SIZE: int = 5           ## 最大缓存视频数
const PRELOAD_COUNT: int = 2            ## 预加载后续视频数
const VIDEO_BASE_PATH: String = "res://assets/videos/"  ## 视频资源路径

## 状态变量
var _video_pool: Dictionary = {}        ## 视频缓存池
var _current_video_id: String = ""      ## 当前播放视频ID
var _is_playing: bool = false           ## 播放状态
var _video_player: VideoStreamPlayer    ## 视频播放器引用
var _preload_queue: Array = []          ## 预加载队列

#region 初始化

func _ready() -> void:
	print("[VideoManager] 视频管理器初始化完成")

## 设置视频播放器引用
func set_video_player(player: VideoStreamPlayer) -> void:
	_video_player = player
	if _video_player:
		_video_player.finished.connect(_on_video_finished)
		print("[VideoManager] 视频播放器已绑定")

#endregion

#region 视频加载

## 加载视频
func load_video(video_id: String) -> void:
	if _video_pool.has(video_id):
		video_loaded.emit(video_id)
		return

	var video_path = _get_video_path(video_id)

	if not ResourceLoader.exists(video_path):
		var error_msg = "视频文件不存在: %s" % video_path
		push_error("[VideoManager] " + error_msg)
		video_error.emit(video_id, error_msg)
		return

	# 检查缓存容量
	if _video_pool.size() >= MAX_CACHE_SIZE:
		_clear_oldest_cache()

	# 加载视频资源
	var video_stream = load(video_path)
	if video_stream == null:
		var error_msg = "视频加载失败: %s" % video_id
		push_error("[VideoManager] " + error_msg)
		video_error.emit(video_id, error_msg)
		return

	_video_pool[video_id] = {
		"stream": video_stream,
		"path": video_path,
		"loaded_time": Time.get_unix_time_from_system()
	}

	print("[VideoManager] 视频加载成功: %s" % video_id)
	video_loaded.emit(video_id)

## 预加载视频
func preload_videos(video_ids: Array) -> void:
	for video_id in video_ids:
		if not _video_pool.has(video_id) and video_id not in _preload_queue:
			_preload_queue.append(video_id)

	_process_preload_queue()

## 处理预加载队列
func _process_preload_queue() -> void:
	while _preload_queue.size() > 0 and _video_pool.size() < MAX_CACHE_SIZE:
		var video_id = _preload_queue.pop_front()
		load_video(video_id)

## 获取视频路径
func _get_video_path(video_id: String) -> String:
	# 检测浏览器类型，选择最佳格式
	if OS.has_feature("web"):
		var browser = _detect_browser()
		if browser == "safari":
			return VIDEO_BASE_PATH + video_id + ".webm"

	return VIDEO_BASE_PATH + video_id + ".ogv"

## 检测浏览器类型
func _detect_browser() -> String:
	if not OS.has_feature("web"):
		return "desktop"

	var ua: String = JavaScriptBridge.eval("""
		(function() {
			return navigator.userAgent.toLowerCase();
		})();
	""")

	if "safari" in ua and "chrome" not in ua:
		return "safari"
	elif "firefox" in ua:
		return "firefox"
	elif "chrome" in ua or "chromium" in ua:
		return "chrome"
	elif "edge" in ua:
		return "edge"

	return "unknown"

#endregion

#region 视频播放

## 播放视频
func play_video(video_id: String) -> void:
	if _video_player == null:
		push_error("[VideoManager] 视频播放器未设置")
		return

	# 确保视频已加载
	if not _video_pool.has(video_id):
		load_video(video_id)
		await video_loaded

	var video_data = _video_pool[video_id]
	_video_player.stream = video_data["stream"]
	_video_player.play()

	_current_video_id = video_id
	_is_playing = true

	print("[VideoManager] 开始播放视频: %s" % video_id)
	video_started.emit(video_id)

## 停止播放
func stop_video() -> void:
	if _video_player:
		_video_player.stop()
	_is_playing = false
	_current_video_id = ""

	print("[VideoManager] 视频播放停止")

## 暂停播放
func pause_video() -> void:
	if _video_player and _is_playing:
		_video_player.paused = true

## 继续播放
func resume_video() -> void:
	if _video_player and _video_player.paused:
		_video_player.paused = false

## 跳转到指定时间
func seek_to(time: float) -> void:
	if _video_player:
		_video_player.seek(time)

## 获取当前播放时间
func get_current_time() -> float:
	if _video_player:
		return _video_player.stream_position
	return 0.0

## 获取视频总时长
func get_video_duration() -> float:
	if _video_player and _video_player.stream:
		return _video_player.stream.get_duration()
	return 0.0

## 获取播放进度（0-1）
func get_playback_progress() -> float:
	var duration = get_video_duration()
	if duration > 0:
		return get_current_time() / duration
	return 0.0

## 视频播放完成回调
func _on_video_finished() -> void:
	var completed_id = _current_video_id
	_is_playing = false
	_current_video_id = ""

	print("[VideoManager] 视频播放完成: %s" % completed_id)
	video_completed.emit(completed_id)

#endregion

#region 缓存管理

## 清理最旧的缓存
func _clear_oldest_cache() -> void:
	var oldest_key = ""
	var oldest_time = INF

	for key in _video_pool:
		var load_time = _video_pool[key]["loaded_time"]
		if load_time < oldest_time:
			oldest_time = load_time
			oldest_key = key

	if oldest_key != "":
		_video_pool.erase(oldest_key)
		print("[VideoManager] 清理缓存: %s" % oldest_key)

## 清理所有缓存
func clear_cache() -> void:
	_video_pool.clear()
	_preload_queue.clear()
	print("[VideoManager] 缓存已清空")

## 获取缓存状态
func get_cache_status() -> Dictionary:
	return {
		"cached_count": _video_pool.size(),
		"max_cache": MAX_CACHE_SIZE,
		"current_video": _current_video_id,
		"is_playing": _is_playing,
		"preload_queue": _preload_queue.size()
	}

#endregion

#region 预加载策略

## 预加载可能的下一个视频
func preload_next_videos(current_node_id: String) -> void:
	var possible_nodes = StoryEngine.get_possible_next_nodes(current_node_id)
	var videos_to_preload = []

	for node_id in possible_nodes:
		var video_id = StoryEngine.get_video_id(node_id)
		if video_id and not _video_pool.has(video_id):
			videos_to_preload.append(video_id)

		if videos_to_preload.size() >= PRELOAD_COUNT:
			break

	if videos_to_preload.size() > 0:
		preload_videos(videos_to_preload)

#endregion

#region 工具方法

## 检查视频是否已缓存
func is_video_cached(video_id: String) -> bool:
	return _video_pool.has(video_id)

## 获取当前视频ID
func get_current_video_id() -> String:
	return _current_video_id

## 是否正在播放
func is_playing() -> bool:
	return _is_playing

#endregion
