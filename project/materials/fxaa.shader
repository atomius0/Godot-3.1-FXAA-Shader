// FXAA Shader for Godot 3.1 GLES2 renderer
// original shader source from: https://godotengine.org/qa/13916/fxaa-broken-in-godot-2-1-2
// link from: https://github.com/godotengine/godot/issues/26646

shader_type spatial;

uniform vec2 resolution = vec2(1024, 600);

void fragment() {
	float FXAA_REDUCE_MIN = (1.0/ 128.0);
	float FXAA_REDUCE_MUL = (1.0 / 8.0);
	float FXAA_SPAN_MAX =  8.0;
	//vec2 resolution = vec2(1024, 600);
	float val = 1.0;
	vec2 inverseVP = vec2(1.0 / resolution.x, 1.0 / resolution.y);
	vec3 rgbNW = texture(SCREEN_TEXTURE, SCREEN_UV + (vec2(-val, -val) * inverseVP)).xyz;
	vec3 rgbNE = texture(SCREEN_TEXTURE,SCREEN_UV + (vec2(val, -val) * inverseVP)).xyz;
	vec3 rgbSW = texture(SCREEN_TEXTURE,SCREEN_UV + (vec2(-val, val) * inverseVP)).xyz;
	vec3 rgbSE = texture(SCREEN_TEXTURE,SCREEN_UV + (vec2(val, val) * inverseVP)).xyz;
	vec3 rgbM  = texture(SCREEN_TEXTURE, SCREEN_UV).xyz; // is the .xyz correct?
	vec3 luma  = vec3(0.299, 0.587, 0.114);
	float lumaNW = dot(rgbNW, luma);
	float lumaNE = dot(rgbNE, luma);
	float lumaSW = dot(rgbSW, luma);
	float lumaSE = dot(rgbSE, luma);
	float lumaM  = dot(rgbM,  luma);
	float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
	float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));
	
	vec2 dir;
	dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
	dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));
	float dirReduce = max((lumaNW + lumaNE + lumaSW + lumaSE) *
		(0.25 * FXAA_REDUCE_MUL), FXAA_REDUCE_MIN);
	float rcpDirMin = 1.0 / (min(abs(dir.x), abs(dir.y)) + dirReduce);
	dir = min(vec2(FXAA_SPAN_MAX, FXAA_SPAN_MAX),
		max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
		dir * rcpDirMin)) * inverseVP;
	
	vec3 rgbA = (1.0/2.0) * (
		texture(SCREEN_TEXTURE,SCREEN_UV + dir * (1.0/3.0 - 0.5)).xyz +
		texture(SCREEN_TEXTURE,SCREEN_UV + dir * (2.0/3.0 - 0.5)).xyz);
	vec3 rgbB = rgbA * (1.0/2.0) + (1.0/4.0) * (
		texture(SCREEN_TEXTURE,SCREEN_UV + dir * (0.0/3.0 - 0.5)).xyz +
		texture(SCREEN_TEXTURE,SCREEN_UV + dir * (3.0/3.0 - 0.5)).xyz);
	
	float lumaB = dot(rgbB, luma);
	if ((lumaB < lumaMin) || (lumaB > lumaMax)){
		ALBEDO.rgb = rgbA;
	}else{
		ALBEDO.rgb = rgbB;
	}
}
