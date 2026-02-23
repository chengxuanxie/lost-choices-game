// 缓慢缩放着色器
// 创建缓慢的放大/缩小效果，增加画面动感
shader_type canvas_item;
render_mode blend_mix;

// 参数配置
uniform float zoom_speed: hint_range(0.05, 0.5) = 0.15;     // 缩放速度
uniform float zoom_amount: hint_range(0.0, 0.1) = 0.03;     // 缩放幅度
uniform vec2 zoom_center = vec2(0.5, 0.5);                  // 缩放中心点

void fragment() {
	// 周期性缩放
	float zoom = 1.0 + zoom_amount * sin(TIME * zoom_speed);

	// 从中心点缩放
	vec2 uv = zoom_center + (UV - zoom_center) / zoom;

	// 边缘处理
	uv = clamp(uv, vec2(0.0), vec2(1.0));

	COLOR = texture(TEXTURE, uv);
}
