// 组合场景氛围着色器
// 同时应用视差、缩放和光影效果
shader_type canvas_item;
render_mode blend_mix;

// 视差参数
uniform float parallax_strength: hint_range(0.0, 0.05) = 0.01;
uniform float parallax_speed: hint_range(0.1, 2.0) = 0.2;
uniform vec2 parallax_direction = vec2(1.0, 0.5);

// 缩放参数
uniform float zoom_speed: hint_range(0.05, 0.5) = 0.1;
uniform float zoom_amount: hint_range(0.0, 0.1) = 0.02;

// 光影参数
uniform float flicker_speed: hint_range(0.5, 5.0) = 1.0;
uniform float flicker_amount: hint_range(0.0, 0.3) = 0.05;
uniform vec3 tint_color: source_color = vec3(0.95, 0.92, 1.0);  // 冷色调

// 暗角效果
uniform float vignette_strength: hint_range(0.0, 1.0) = 0.3;
uniform float vignette_radius: hint_range(0.3, 1.0) = 0.7;

void fragment() {
	// 1. 视差偏移
	float offset_x = sin(TIME * parallax_speed) * parallax_strength * parallax_direction.x;
	float offset_y = cos(TIME * parallax_speed * 0.7) * parallax_strength * parallax_direction.y;

	// 2. 缩放
	float zoom = 1.0 + zoom_amount * sin(TIME * zoom_speed);

	// 组合UV变换
	vec2 center = vec2(0.5, 0.5);
	vec2 uv = center + (UV - center + vec2(offset_x, offset_y)) / zoom;
	uv = clamp(uv, vec2(0.0), vec2(1.0));

	// 3. 采样
	vec4 tex_color = texture(TEXTURE, uv);

	// 4. 光影闪烁
	float flicker = sin(TIME * flicker_speed) * 0.5 + 0.5;
	flicker = mix(1.0 - flicker_amount, 1.0, flicker);

	// 5. 色调
	vec3 final_color = tex_color.rgb * flicker;
	final_color = mix(final_color, final_color * tint_color, 0.2);

	// 6. 暗角效果
	vec2 vignette_uv = UV - 0.5;
	float vignette_dist = length(vignette_uv);
	float vignette = smoothstep(vignette_radius, vignette_radius - 0.3, vignette_dist);
	final_color *= mix(1.0 - vignette_strength * 0.5, 1.0, vignette);

	COLOR = vec4(clamp(final_color, 0.0, 1.0), tex_color.a);
}
