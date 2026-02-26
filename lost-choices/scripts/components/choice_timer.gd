## 选择计时器 - 处理时间限制选择
## 当选择有时间限制时，显示倒计时并自动选择默认选项
class_name ChoiceTimer
extends Control

## 信号
signal timeout(default_choice: int)
signal time_updated(remaining: float, total: float)

## 配置
@export var default_choice_index: int = 0  ## 超时默认选择
@export var warning_threshold: float = 5.0  ## 警告阈值(秒)
@export var critical_threshold: float = 2.0  ## 危急阈值(秒)

## 节点引用
@onready var timer_bar: ProgressBar = $TimerBar
@onready var timer_label: Label = $TimerLabel

## 状态
var _time_limit: float = 0.0        ## 总时间限制
var _remaining_time: float = 0.0    ## 剩余时间
var _is_running: bool = false       ## 是否运行中
var _timer: Timer                   ## 内部计时器

#region 生命周期

func _ready() -> void:
	_setup_timer()
	visible = false

func _process(delta: float) -> void:
	if not _is_running:
		return

	_remaining_time -= delta
	_update_display()

	if _remaining_time <= 0:
		_on_timeout()

#endregion

#region 公共方法

## 开始倒计时
func start(time_limit: float, default_choice: int = 0) -> void:
	_time_limit = time_limit
	_remaining_time = time_limit
	default_choice_index = default_choice
	_is_running = true
	visible = true
	_update_display()
	print("[ChoiceTimer] 开始倒计时: %.1f秒, 默认选择: %d" % [time_limit, default_choice])

## 停止倒计时
func stop() -> void:
	_is_running = false
	visible = false
	print("[ChoiceTimer] 停止倒计时")

## 暂停
func pause() -> void:
	_is_running = false

## 继续
func resume() -> void:
	if _remaining_time > 0:
		_is_running = true

## 是否正在运行
func is_running() -> bool:
	return _is_running

## 获取剩余时间
func get_remaining_time() -> float:
	return _remaining_time

## 获取进度 (0-1)
func get_progress() -> float:
	if _time_limit <= 0:
		return 0.0
	return _remaining_time / _time_limit

#endregion

#region 私有方法

func _setup_timer() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)

func _update_display() -> void:
	if timer_bar:
		timer_bar.value = get_progress() * 100

	if timer_label:
		var seconds = int(ceil(_remaining_time))
		timer_label.text = "%d秒" % seconds

		# 根据剩余时间改变颜色
		if _remaining_time <= critical_threshold:
			timer_label.add_theme_color_override("font_color", Color.RED)
		elif _remaining_time <= warning_threshold:
			timer_label.add_theme_color_override("font_color", Color.YELLOW)
		else:
			timer_label.add_theme_color_override("font_color", Color.WHITE)

	time_updated.emit(_remaining_time, _time_limit)

func _on_timeout() -> void:
	_is_running = false
	visible = false
	timeout.emit(default_choice_index)
	print("[ChoiceTimer] 倒计时结束，默认选择: %d" % default_choice_index)

#endregion

#region 静态工厂方法

## 创建选择计时器实例
static func create(time_limit: float, default_choice: int = 0) -> ChoiceTimer:
	var timer = ChoiceTimer.new()
	timer._time_limit = time_limit
	timer.default_choice_index = default_choice
	return timer

#endregion
