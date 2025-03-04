shader_type spatial;

uniform vec2 amp = vec2(0.2, 0.1);
uniform vec2 freq = vec2(3.0, 2.5);
uniform vec2 time_factor = vec2(2.0, 3.0);
uniform float delta = 0.01;
uniform vec2 step_threshold = vec2(0.1, .5);
uniform float ref_offset = float(1.0);

uniform vec2 tex_scale = vec2(2.0, 1.0);
uniform sampler2D albedo_tex : hint_default_white;

uniform vec2 scale_uv_offset = vec2(2.0, 1.0);
uniform vec2 panning_uv_offset = vec2(0.2, 0.1);
uniform float str_uv_offset = float(0.2);
uniform sampler2D tex_uv_offset : hint_default_black;
uniform sampler2D tex_screen : hint_screen_texture;

uniform sampler2D tex_normal : hint_normal;


float height (vec2 pos, float time){
	return (sin(pos.x * PI * freq.x + time_factor.x * time) * amp.x + sin(pos.y * PI * freq.y + time_factor.y * time) * amp.y);
}


void vertex() {
	VERTEX.y += height(VERTEX.xz, TIME);
	TANGENT = normalize(vec3(0.0, height(VERTEX.xz + vec2(0.0, delta), TIME) - height(VERTEX.xz + vec2(0.0, -delta), TIME), 2.0 * delta));
	BINORMAL = normalize(vec3(2.0 * delta, height(VERTEX.xz + vec2(delta, 0.0), TIME) - height(VERTEX.xz + vec2(-delta, 0.0), TIME), 0.0));
	NORMAL = cross(TANGENT, BINORMAL);
}

void fragment(){
	
	vec2 distortion = str_uv_offset * texture(tex_uv_offset, UV * scale_uv_offset + TIME * panning_uv_offset).rg;
	vec2 base_uv = TIME * vec2(0.05, 0.1) + UV * tex_scale + distortion ;
	ALBEDO = texture(albedo_tex, base_uv).rgb;
	METALLIC = 0.5;
	ROUGHNESS = 0.2;
	
	ALPHA = smoothstep(step_threshold.x, step_threshold.y, length(ALBEDO));
	
	NORMAL_MAP = texture(tex_normal, base_uv).rgb;
	
	vec2 ref_ofs = ref_offset * normalize(TANGENT * NORMAL_MAP.x + BINORMAL * NORMAL_MAP.y + NORMAL * NORMAL_MAP.z).rg;
	EMISSION = textureLod(tex_screen, SCREEN_UV - ref_ofs, 1.0).rgb * (1.0 - ALPHA);
	ALPHA = 1.0;
	
}