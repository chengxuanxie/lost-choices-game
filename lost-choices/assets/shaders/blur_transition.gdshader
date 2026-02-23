// 模糊到清晰过渡着色器
// 用于场景切换或醒来效果
shader_type canvas_item;
render_mode blend_mix;

uniform float blur_amount: hint_range(0.0, 1.0) = 0.0;  // 0=清晰, 1=模糊
uniform float brightness: hint_range(0.0, 2.0) = 1.0;   // 亮度调节

void fragment() {
	vec4 color;

	if (blur_amount < 0.01) {
		// 无模糊，直接采样
		color = texture(TEXTURE, UV);
	} else {
		// 简单的盒式模糊
		float blur = blur_amount * 0.01;
		color = vec4(0.0);

		color += texture(TEXTURE, UV + vec2(-blur, -blur));
		color += texture(TEXTURE, UV + vec2(0.0, -blur));
		color += texture(TEXTURE, UV + vec2(blur, -blur));
		color += texture(TEXTURE, UV + vec2(-blur, 0.0));
		color += texture(TEXTURE, UV + vec2(0.0, 0.0)) * 2.0;
		color += texture(TEXTURE, UV + vec2(blur, 0.0));
		color += texture(TEXTURE, UV + vec2(-blur, blur));
		color += texture(TEXTURE, UV + vec2(0.0, blur));
		color += texture(TEXTURE, UV + vec2(blur, blur));

		color /= 10.0;
	}

	// 应用亮度
	color.rgb *= brightness;

	COLOR = color;
}
