## 资源管理器 - 负责本地资源的加载和管理
@warning_ignore("static_called_on_instance")
extends Node

## 资源路径配置
const PATHS: Dictionary = {
	"videos": "res://assets/videos/",
	"audio_bgm": "res://assets/audio/bgm/",
	"audio_sfx": "res://assets/audio/sfx/",
	"images": "res://assets/images/",
	"data": "res://data/"
}

## 资源缓存
var _resource_cache: Dictionary = {}

## 加载资源
func load_resource(path: String, cache: bool = true) -> Resource:
	if cache and _resource_cache.has(path):
		return _resource_cache[path]

	if not ResourceLoader.exists(path):
		push_error("[ResourceManager] 资源不存在: %s" % path)
		return null

	var resource = load(path)
	if cache and resource != null:
		_resource_cache[path] = resource

	return resource

## 预加载资源列表
func preload_resources(paths: Array) -> void:
	for path in paths:
		load_resource(path, true)

## 清理缓存
func clear_cache() -> void:
	_resource_cache.clear()
	print("[ResourceManager] 资源缓存已清空")

## 获取资源列表
func list_resources(type: String) -> Array:
	var path = PATHS.get(type, "")
	if path.is_empty():
		return []

	var dir = DirAccess.open(path)
	if dir == null:
		return []

	var files = []
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and not file_name.begins_with("."):
			files.append(path + file_name)
		file_name = dir.get_next()

	return files

## 检查资源是否存在
func resource_exists(path: String) -> bool:
	return ResourceLoader.exists(path)
