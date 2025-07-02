shader_type canvas_item;

uniform float divide = 0.065;      
uniform float blur = 0.385;        
uniform float fade_width = 0.995;  

void fragment() {
	float left_fade_edge = fade_width;
	float right_fade_edge = 1.0 - fade_width;

	float leftFade = 1.0;
	float rightFade = 1.0;

	// Normalize to 0..1 within the fade width region
	if (UV.y < left_fade_edge) {
		float px = UV.y / fade_width;
		leftFade = smoothstep(divide, divide + blur, px);
	}
	
	vec4 tex = texture(TEXTURE, UV); 
	tex.a = min(leftFade, rightFade);
	
	COLOR = tex;
}