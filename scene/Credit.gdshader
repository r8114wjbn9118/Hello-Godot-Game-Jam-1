shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE:hint_screen_texture;

uniform vec2 screen_size = vec2(1000.0, 500.0);
varying mat4 world_to_screen;
varying mat4 screen_to_world;
void vertex(){
	world_to_screen = SCREEN_MATRIX * CANVAS_MATRIX;
	screen_to_world = inverse(world_to_screen);
}
void fragment() {
	vec2 uv = SCREEN_UV;
	//uv = uv * 2.0 - 1.0;
	//uv = (screen_to_world * vec4(uv,0,1)).xy;
	//vec2 fix_screen_size = screen_size/2.0;
	float h = 1.0+((1.0-uv.y)/2.0);
	uv.x = (uv.x - 0.5)*h + 0.5;

	//uv = (world_to_screen * vec4(uv,0,1)).xy;
	//uv = uv * 0.5 + 0.5;
	COLOR = texture(SCREEN_TEXTURE, uv);
	//COLOR.rg = uv;
}
