shader_type canvas_item;

uniform float scroll_speed : hint_range(0.0, 2.0) = 0.05;
uniform float angle_degrees : hint_range(0.0, 360.0, 1) = 45.0;
uniform float repeat_x : hint_range(1, 20, 1) = 1;
uniform float repeat_y : hint_range(1, 20, 1) = 1;
uniform vec4 tint : source_color = vec4(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	
	float angle_rad = radians(angle_degrees);
	vec2 direction = vec2(cos(angle_rad), sin(angle_rad));
	vec2 offset_uv = -(TIME * scroll_speed * direction);
	// Called for every pixel the material is visible on.
	
	//vec2 scaled_uv = UV * vec2(repeat_x, repeat_y);
	vec2 scaled_uv = fract(UV * vec2(repeat_x, repeat_y)  + offset_uv);
	vec2 texelSize = vec2(1.0) / vec2(textureSize(TEXTURE, 4));
	vec2 snappedUV = round(scaled_uv / texelSize) * texelSize;
	snappedUV = round(scaled_uv / texelSize) * texelSize;
	
	COLOR = texture(TEXTURE, scaled_uv) * tint;
	COLOR = texture(TEXTURE, snappedUV) * tint;
	//COLOR = texture(TEXTURE, UV);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
