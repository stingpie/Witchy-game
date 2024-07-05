// NOTE: Shader automatically converted from Godot Engine 4.2.1.stable's StandardMaterial3D.

shader_type spatial;
render_mode blend_mix,depth_draw_always,cull_back,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : source_color;
uniform sampler2D texture_albedo : source_color,filter_linear_mipmap,repeat_enable;

uniform sampler2D mask: filter_linear_mipmap;

uniform vec3 main_color: source_color;
uniform vec3 aux_color: source_color;

void vertex() {
	//UV=UV*uv1_scale.xy+uv1_offset.xy;
}






void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = (texture(texture_albedo,base_uv)-vec4(0.5,0.5,0.5,0))*vec4(2,2,2,1);
	vec4 mask_tex = texture(mask,base_uv);
	ALPHA = mask_tex.a;
	ALBEDO = albedo.rgb * (vec3(1,1,1)-albedo_tex.rgb * aux_color) + albedo_tex.rgb * main_color;
	//float metallic_tex = dot(texture(texture_metallic,base_uv),metallic_texture_channel);
	//METALLIC = metallic_tex * metallic;
	//vec4 roughness_texture_channel = vec4(1.0,0.0,0.0,0.0);
	//float roughness_tex = dot(texture(texture_roughness,base_uv),roughness_texture_channel);
	//ROUGHNESS = roughness_tex * roughness;
	//SPECULAR = specular;
}
