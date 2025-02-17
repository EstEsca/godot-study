shader_type canvas_item;

//uniform sampler2D mask;
uniform sampler2D tex :
		repeat_enable;
uniform sampler2D tex_flow :
		repeat_enable;
uniform sampler2D tex_dissolve;

uniform vec2 flow_scroll = vec2(0, 0);
uniform float flow_amount : hint_range(-1, 1, 0.1) = float(0);
uniform float dissolve_amount : hint_range(-1, 1, 0.1) = float(0);

uniform float mask_edge_min : hint_range(0, 1, 0.05) = float(0.4) ;
uniform float mask_edge_max : hint_range(0, 1, 0.05) = float(0.6) ;

void vertex() {
	UV = UV;
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 base_uv = UV;
	vec2 mask_uv = UV * float(PI);
	float mask = sin(mask_uv.r) * sin(mask_uv.g);
	mask = smoothstep(mask_edge_min, mask_edge_max, mask);
	
	//COLOR = texture(TEXTURE, base_uv);
	
	vec2 flow_uv = base_uv + TIME * flow_scroll;
	vec2 flow = texture(tex_flow, flow_uv).rg;
	flow += vec2(-0.5);
	
	base_uv = UV + flow_amount * flow;
	/*
	float polar_base_uv = UV;
	polar_base_uv -= 0.5;
	polar_base_uv
	*/
	
	float dissolve = dissolve_amount + texture(tex_dissolve, UV).r;
	dissolve = clamp(dissolve, 0, 1);
	mask *= dissolve;
	
	vec4 tex_diffuse = texture(tex, base_uv);
	
	COLOR = tex_diffuse;
	COLOR *= mask;
	
	//COLOR = texture(tex, UV);
	
}
