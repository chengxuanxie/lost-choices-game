## 事件管理器 - 负责全局事件系统
class_name EventManager extends Node

## 信号
signal event_triggered(event_id: String, data: Dictionary)

## 事件监听器
var _listeners: Dictionary = {}

## 注册事件监听
func register(event_id: String, callback: Callable) -> void:
	if not _listeners.has(event_id):
		_listeners[event_id] = []
	_listeners[event_id].append(callback)

## 取消事件监听
func unregister(event_id: String, callback: Callable) -> void:
	if _listeners.has(event_id):
		_listeners[event_id].erase(callback)

## 触发事件
func trigger(event_id: String, data: Dictionary = {}) -> void:
	event_triggered.emit(event_id, data)

	if _listeners.has(event_id):
		for callback in _listeners[event_id]:
			if callback.is_valid():
				callback.call(data)

	print("[EventManager] 事件触发: %s" % event_id)

## 清除所有监听器
func clear_all() -> void:
	_listeners.clear()
