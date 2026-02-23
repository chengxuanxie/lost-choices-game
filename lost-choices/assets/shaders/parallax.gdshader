// 视差效果着色器
// 创建轻微的视角移动效果，模拟头部微动
shader_type canvas_item;
render_mode blend_mix;

// 参数配置
uniform float parallax_strength: hint_range(0.0, 0.05) = 0.015;  // 视差强度
uniform float parallax_speed: hint_range(0.1, 2.0) = 0.3;        // 视差速度
uniform vec2 parallax_direction = vec2(1.0, 0.5);                // 视差方向

void fragment() {
	// 基于时间的周期性偏移
	float offset_x = sin(TIME * parallax_speed) * parallax_strength * parallax_direction.x;
	float offset_y = cos(TIME * parallax_speed * 0.7) * parallax_strength * parallax_direction.y;

	// 应用UV偏移
	vec2 uv = UV + vec2(offset_x, offset_y);

	// 边缘处理 - 避免采样越界
	uv = clamp(uv, vec2(0.0), vec2(1.0));

	COLOR = texture(TEXTURE, uv);
}
