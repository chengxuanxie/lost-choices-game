## 场景过渡管理器
## 管理场景切换的过渡效果
class_name TransitionManager
extends CanvasLayer

## 信号
signal transition_completed()
signal transition_started(type: String)

## 过渡类型
enum TransitionType {
	FADE,       ## 淡入淡出
	FADE_TO_BLACK,  ## 淡出到黑屏
	FADE_FROM_BLACK, ## 从黑屏淡入
	DISSOLVE,   ## 溶解
	SLIDE_LEFT, ## 向左滑动
	SLIDE_RIGHT ## 向右滑动
}

## 节点
var _color_rect: ColorRect
var _tween: Tween

## 配置
var default_duration: float = 0.5
var default_type: TransitionType = TransitionType.FADE

## 状态
var _is_transitioning: bool = false

func _ready() -> void:
	layer = 100  # 确保在最上层
	_create_color_rect()

func _create_color_rect() -> void:
	_color_rect = ColorRect.new()
	_color_rect.color = Color.BLACK
	_color_rect.modulate.a = 0.0
	_color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_color_rect)

#region 公共方法

## 执行过渡效果
func transition(type: TransitionType = default_type, duration: float = default_duration) -> void:
	if _is_transitioning:
		return

	_is_transitioning = true
	transition_started.emit(TransitionType.keys()[type])

	match type:
		TransitionType.FADE:
			await _do_fade_transition(duration)
		TransitionType.FADE_TO_BLACK:
			await _do_fade_to_black(duration)
		TransitionType.FADE_FROM_BLACK:
			await _do_fade_from_black(duration)
		TransitionType.DISSOLVE:
			await _do_dissolve_transition(duration)
		TransitionType.SLIDE_LEFT:
			await _do_slide_transition(true, duration)
		TransitionType.SLIDE_RIGHT:
			await _do_slide_transition(false, duration)

	_is_transitioning = false
	transition_completed.emit()

## 过渡到新场景
func transition_to_scene(scene_path: String, type: TransitionType = default_type, duration: float = default_duration) -> void:
	await transition(type, duration / 2.0)
	get_tree().change_scene_to_file(scene_path)
	await _do_fade_from_black(duration / 2.0)

## 淡出到黑屏
func fade_out(duration: float = default_duration) -> void:
	await _do_fade_to_black(duration)

## 从黑屏淡入
func fade_in(duration: float = default_duration) -> void:
	await _do_fade_from_black(duration)

## 检查是否正在过渡
func is_transitioning() -> bool:
	return _is_transitioning

## 立即设置黑屏
func set_black() -> void:
	_color_rect.modulate.a = 1.0

## 立即清除黑屏
func clear_black() -> void:
	_color_rect.modulate.a = 0.0

#endregion

#region 私有方法

func _do_fade_transition(duration: float) -> void:
	# 淡出
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 1.0, duration / 2.0)
	await _tween.finished

	# 淡入
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 0.0, duration / 2.0)
	await _tween.finished

func _do_fade_to_black(duration: float) -> void:
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 1.0, duration)
	await _tween.finished

func _do_fade_from_black(duration: float) -> void:
	_color_rect.modulate.a = 1.0
	_tween = create_tween()
	_tween.tween_property(_color_rect, "modulate:a", 0.0, duration)
	await _tween.finished

func _do_dissolve_transition(duration: float) -> void:
	# 使用shader实现溶解效果
	_color_rect.modulate.a = 0.0
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_color_rect, "modulate:a", 1.0, duration / 2.0)
	await _tween.finished

	_tween = create_tween()
	_tween.set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_color_rect, "modulate:a", 0.0, duration / 2.0)
	await _tween.finished

func _do_slide_transition(left: bool, duration: float) -> void:
	var start_x = 1920.0 if left else -1920.0
	_color_rect.position.x = 0
	_color_rect.modulate.a = 1.0

	_tween = create_tween()
	_tween.tween_property(_color_rect, "position:x", -start_x, duration / 2.0)
	await _tween.finished

	_tween = create_tween()
	_tween.tween_property(_color_rect, "position:x", 0, duration / 2.0)
	await _tween.finished

	_color_rect.modulate.a = 0.0

#endregion
