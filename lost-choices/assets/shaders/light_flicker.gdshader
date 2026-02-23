// 光影闪烁着色器
// 模拟环境光线的自然变化
shader_type canvas_item;
render_mode blend_mix;

// 参数配置
uniform float flicker_speed: hint_range(0.5, 5.0) = 1.5;        // 闪烁速度
uniform float flicker_amount: hint_range(0.0, 0.3) = 0.08;      // 闪烁强度
uniform float color_shift: hint_range(0.0, 0.1) = 0.02;         // 色彩偏移
uniform vec3 tint_color: source_color = vec3(1.0, 0.95, 0.9);   // 色调

void fragment() {
	// 获取原始颜色
	vec4 tex_color = texture(TEXTURE, UV);

	// 多层闪烁效果叠加
	float flicker1 = sin(TIME * flicker_speed) * 0.5 + 0.5;
	float flicker2 = sin(TIME * flicker_speed * 1.7 + 1.0) * 0.3 + 0.5;
	float flicker3 = sin(TIME * flicker_speed * 0.5 + 2.0) * 0.2 + 0.5;

	float combined_flicker = (flicker1 + flicker2 + flicker3) / 3.0;
	float brightness = 1.0 - flicker_amount * (1.0 - combined_flicker);

	// 应用色调和亮度变化
	vec3 final_color = tex_color.rgb * brightness;
	final_color = mix(final_color, final_color * tint_color, 0.3);

	// 添加轻微的色温变化
	float warmth = sin(TIME * 0.3) * color_shift;
	final_color.r += warmth;
	final_color.b -= warmth;

	COLOR = vec4(clamp(final_color, 0.0, 1.0), tex_color.a);
}
