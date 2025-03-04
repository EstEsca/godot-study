shader_type canvas_item;

uniform sampler2D tex :
		repeat_enable;

void vertex() {
	UV -= 0.5;
	UV *= 2.0;
	// Called for every vertex the material is visible on.
}

void fragment() {
	float angle = atan(UV.y, UV.x) / (2.0 * PI);
	float dist = length(vec2(UV.x, UV.y));
	vec2 polar_uv = vec2(angle, dist);
	
	COLOR = texture(tex, polar_uv);
}
