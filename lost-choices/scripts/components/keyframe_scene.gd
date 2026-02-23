## 关键帧场景组件
## 用于显示关键帧图片序列，配合着色器动画效果
class_name KeyframeScene
extends Control

## 信号
signal scene_completed()
signal frame_changed(frame_index: int)

## 导出配置
@export_group("关键帧配置")
@export var keyframes: Array[Texture2D] = []           ## 关键帧图片序列
@export var frame_durations: Array[float] = []         ## 每帧持续时间（秒）
@export var default_duration: float = 5.0              ## 默认帧持续时间
@export var crossfade_duration: float = 1.0            ## 交叉淡入淡出时间

@export_group("动画效果")
@export var use_parallax: bool = true                  ## 启用视差效果
@export var use_zoom: bool = true                      ## 启用缩放效果
@export var use_light_flicker: bool = true             ## 启用光影闪烁
@export var use_vignette: bool = true                  ## 启用暗角效果

@export_group("着色器参数")
@export var parallax_strength: float = 0.01            ## 视差强度
@export var zoom_amount: float = 0.02                  ## 缩放幅度
@export var flicker_amount: float = 0.05               ## 闪烁强度
@export var vignette_strength: float = 0.3             ## 暗角强度

## 内部变量
var _current_frame: int = 0
var _is_playing: bool = false
var _frame_timer: float = 0.0
var _is_transitioning: bool = false
var _is_setup: bool = false

# 节点引用
var _texture_rects: Array[TextureRect] = []
var _shader_material: ShaderMaterial

#region 生命周期

func _ready() -> void:
	# 设置基础属性
	anchor_right = 1.0
	anchor_bottom = 1.0
	# 只有在有预设关键帧时才初始化
	if not keyframes.is_empty():
		_setup_scene()

func _process(delta: float) -> void:
	if not _is_playing:
		return

	_frame_timer += delta
	var current_duration = _get_frame_duration(_current_frame)

	# 检查是否需要切换帧
	if _frame_timer >= current_duration and not _is_transitioning:
		_advance_frame()

#endregion

#region 公共方法

## 播放场景
func play() -> void:
	if keyframes.is_empty():
		push_warning("[KeyframeScene] 没有关键帧可播放")
		return

	if not _is_setup:
		_setup_scene()

	_is_playing = true
	_current_frame = 0
	_frame_timer = 0.0
	_show_frame(0)
	print("[KeyframeScene] 开始播放，共 %d 帧" % keyframes.size())

## 暂停播放
func pause() -> void:
	_is_playing = false

## 继续播放
func resume() -> void:
	_is_playing = true

## 停止播放
func stop() -> void:
	_is_playing = false
	_current_frame = 0
	_frame_timer = 0.0

## 跳转到指定帧
func seek_to_frame(frame_index: int) -> void:
	if frame_index < 0 or frame_index >= keyframes.size():
		return

	_current_frame = frame_index
	_frame_timer = 0.0
	_show_frame(frame_index)

## 获取当前帧索引
func get_current_frame() -> int:
	return _current_frame

## 获取总帧数
func get_frame_count() -> int:
	return keyframes.size()

## 获取播放进度 (0-1)
func get_progress() -> float:
	if keyframes.is_empty():
		return 0.0

	var total_duration = 0.0
	var elapsed = 0.0

	for i in range(keyframes.size()):
		var duration = _get_frame_duration(i)
		if i < _current_frame:
			elapsed += duration
		elif i == _current_frame:
			elapsed += _frame_timer

		total_duration += duration

	return elapsed / total_duration if total_duration > 0 else 0.0

## 设置关键帧（运行时）
func set_keyframes(frames: Array[Texture2D], durations: Array[float] = []) -> void:
	keyframes = frames
	frame_durations = durations
	_is_setup = false
	_setup_scene()

## 从目录加载关键帧
func load_from_directory(dir_path: String, pattern: String = "*.png") -> void:
	var dir = DirAccess.open(dir_path)
	if dir == null:
		push_error("[KeyframeScene] 无法打开目录: %s" % dir_path)
		return

	var file_names: Array[String] = []

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.match(pattern):
			file_names.append(file_name)
		file_name = dir.get_next()

	# 排序
	file_names.sort()

	# 加载纹理
	keyframes.clear()
	for fn in file_names:
		var full_path = dir_path.path_join(fn)
		if ResourceLoader.exists(full_path):
			var texture = load(full_path)
			if texture is Texture2D:
				keyframes.append(texture)

	print("[KeyframeScene] 从目录加载了 %d 个关键帧" % keyframes.size())
	_is_setup = false
	_setup_scene()

#endregion

#region 私有方法

func _setup_scene() -> void:
	if _is_setup:
		return

	_is_setup = true

	# 清除旧的纹理矩形
	for child in get_children():
		child.queue_free()
	_texture_rects.clear()

	if keyframes.is_empty():
		print("[KeyframeScene] 没有关键帧，跳过场景设置")
		return

	# 创建着色器材质
	_shader_material = _create_shader_material()

	# 为每个关键帧创建TextureRect（用于交叉淡入淡出）
	var num_rects = min(2, keyframes.size())  # 最多2个，用于淡入淡出
	for i in range(num_rects):
		var tex_rect = TextureRect.new()
		tex_rect.name = "Frame%d" % i
		tex_rect.texture = keyframes[i] if i < keyframes.size() else null
		tex_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		# 设置锚点
		tex_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex_rect.offset_left = 0
		tex_rect.offset_right = 0
		tex_rect.offset_top = 0
		tex_rect.offset_bottom = 0

		# 设置着色器材质
		if _shader_material:
			tex_rect.material = _shader_material.duplicate()

		tex_rect.modulate.a = 1.0 if i == 0 else 0.0

		add_child(tex_rect)
		_texture_rects.append(tex_rect)

	print("[KeyframeScene] 场景设置完成，创建了 %d 个纹理矩形" % _texture_rects.size())

func _create_shader_material() -> ShaderMaterial:
	var shader_path := ""

	# 根据配置选择着色器
	if use_parallax and use_zoom and use_light_flicker:
		shader_path = "res://assets/shaders/scene_atmosphere.gdshader"
	elif use_parallax:
		shader_path = "res://assets/shaders/parallax.gdshader"
	elif use_zoom:
		shader_path = "res://assets/shaders/slow_zoom.gdshader"
	elif use_light_flicker:
		shader_path = "res://assets/shaders/light_flicker.gdshader"
	else:
		return null

	# 检查着色器文件是否存在
	if not ResourceLoader.exists(shader_path):
		push_warning("[KeyframeScene] 着色器文件不存在: %s" % shader_path)
		return null

	var shader = load(shader_path)
	if shader == null:
		push_warning("[KeyframeScene] 无法加载着色器: %s" % shader_path)
		return null

	var material = ShaderMaterial.new()
	material.shader = shader

	# 设置着色器参数
	if use_parallax and use_zoom and use_light_flicker:
		material.set_shader_parameter("parallax_strength", parallax_strength)
		material.set_shader_parameter("zoom_amount", zoom_amount)
		material.set_shader_parameter("flicker_amount", flicker_amount)
		material.set_shader_parameter("vignette_strength", vignette_strength if use_vignette else 0.0)
	elif use_parallax:
		material.set_shader_parameter("parallax_strength", parallax_strength)
	elif use_zoom:
		material.set_shader_parameter("zoom_amount", zoom_amount)
	elif use_light_flicker:
		material.set_shader_parameter("flicker_amount", flicker_amount)

	return material

func _show_frame(frame_index: int) -> void:
	if frame_index < 0 or frame_index >= keyframes.size():
		return

	if _texture_rects.is_empty():
		return

	# 更新纹理
	var tex_rect = _texture_rects[0]
	tex_rect.texture = keyframes[frame_index]
	tex_rect.modulate.a = 1.0

	frame_changed.emit(frame_index)

func _transition_to_frame(frame_index: int) -> void:
	if frame_index < 0 or frame_index >= keyframes.size():
		_is_transitioning = false
		return

	if _texture_rects.size() < 2:
		_show_frame(frame_index)
		_is_transitioning = false
		return

	_is_transitioning = true

	var current_rect = _texture_rects[0]
	var next_rect = _texture_rects[1]

	# 设置下一帧
	next_rect.texture = keyframes[frame_index]
	next_rect.modulate.a = 0.0

	# 创建淡入淡出动画
	var tween = create_tween()
	tween.set_parallel(true)

	tween.tween_property(current_rect, "modulate:a", 0.0, crossfade_duration)
	tween.tween_property(next_rect, "modulate:a", 1.0, crossfade_duration)

	tween.set_parallel(false)
	tween.tween_callback(_on_transition_complete.bind(current_rect, next_rect))

func _on_transition_complete(current_rect: TextureRect, next_rect: TextureRect) -> void:
	# 交换顺序
	_texture_rects[0] = next_rect
	_texture_rects[1] = current_rect
	move_child(next_rect, 0)
	_is_transitioning = false

func _advance_frame() -> void:
	var next_frame = _current_frame + 1

	if next_frame >= keyframes.size():
		# 场景结束
		_is_playing = false
		scene_completed.emit()
		print("[KeyframeScene] 场景播放完成")
		return

	# 淡入淡出切换
	_transition_to_frame(next_frame)
	_current_frame = next_frame
	_frame_timer = 0.0

func _get_frame_duration(frame_index: int) -> float:
	if frame_index >= 0 and frame_index < frame_durations.size():
		return frame_durations[frame_index]
	return default_duration

#endregion
