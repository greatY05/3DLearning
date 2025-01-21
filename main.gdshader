shader_type spatial;
//render_mode blend_add;
uniform sampler2D noise;
uniform float height_scale = 0.5;
uniform sampler2D normalmap;
uniform float distance = 0.5;
uniform float waveSpeed = 0.5;
uniform sampler2D texture_test : hint_default_white;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.02;
uniform float metallic : hint_range(0.0, 1.0, 0.1) = 0;
uniform sampler2D wave;
uniform float noise_scale = 100.0;
uniform float time_scale = 0.15;
varying vec2 tex_position;

uniform vec2 waveDir1 = vec2(2.0,0.0);
uniform vec2 waveDir2 = vec2(0.0, 2.0);
uniform float waveTimeScale : hint_range(0.0, 2.0)  = 0.5;

//edge
uniform float edge_scale = 0.1;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec3 edgeColor :source_color;

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture, filter_linear_mipmap;

float edge(float depth){
	depth = 2.0 * depth - 1.0;
	return near * far / (far+depth * (near - far));
}


varying float heightWorld;
varying vec3 worldPos;
void vertex() {
	//tex_position= VERTEX.xz / 2.0 + 0.5;
	//float height = texture(noise, tex_position).x;
	//VERTEX.y += height * abs(height_scale) * sin(TIME + VERTEX.x * 10.0 / waveSpeed);
	
	worldPos = (MODEL_MATRIX * vec4(VERTEX,1.0)).xyz;
	heightWorld = texture(wave, worldPos.xz / noise_scale + TIME * time_scale * 0.25).r;
	VERTEX.y += heightWorld * height_scale - 1.0;
}



uniform vec3 waterColor = vec3(0.0, 0.5, 1);
uniform vec3 lineColor = vec3(0.5, 1.0, 1.0);
void fragment() {
	vec2 uv = UV;
	uv += sin(uv.x *15.0 + TIME * 2.0 * waveSpeed) * 0.01 / 0.5;
	vec3 color = texture(texture_test, uv).rgb;
	vec3 placeholderColor;
	placeholderColor.r = (sin(TIME*6.0 + VERTEX.x * 10.0) + 1.0) * 0.5;
	placeholderColor.g = (cos(TIME*7.0 + VERTEX.x * 10.0) + 1.0) * 0.5;
	placeholderColor.b = (sin(TIME*8.0 + VERTEX.x * 10.0) + 1.0) * 0.5;
	
	
	vec3 codeColor = color.r * waterColor  + color.g * lineColor;
	ALBEDO = codeColor;
	NORMAL_MAP = texture(normalmap, tex_position).xyz;
	
	
	//edge
	float z_depth = edge(texture(DEPTH_TEXTURE,SCREEN_UV).x);
	float z_pos = edge(FRAGCOORD.z);
	float z_dif = z_depth - z_pos;
	
	vec2 timeDir1 = (TIME * waveDir1) * waveTimeScale;
	vec2 timeDir2 = (TIME * waveDir2) * waveTimeScale;
	
	
	vec3 blend = mix(texture(normalmap, worldPos.xz + timeDir1).rgb, texture(noise, worldPos.xz + timeDir2).rgb, 0.5);
	ROUGHNESS = roughness;
	METALLIC = metallic;
	NORMAL_MAP = blend;
	
}


//void light() {
	//vec3 whiteColoring = vec3(0.5, 0.5, 0.5);
	//ALBEDO = whiteColoring + 1.0;
//}
