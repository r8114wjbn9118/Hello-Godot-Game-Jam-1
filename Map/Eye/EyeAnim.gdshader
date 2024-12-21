shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec2 pup_offset = vec2(0.5, 0.5);
varying mat4 world_to_screen;
varying mat4 screen_to_world;
void vertex(){
	world_to_screen = SCREEN_MATRIX * CANVAS_MATRIX;
	screen_to_world = inverse(world_to_screen);
}
vec2 spherize_uv(vec2 uv, vec2 center, float strength, vec2 offset) {
	vec2 delta = uv - center;
	float delta2 = dot(delta.xy, delta.xy);
	float delta4 = delta2 * delta2;
	vec2 delta_offset = vec2(delta4 * strength);
	return uv + delta * delta_offset + offset;
}
void fragment(){
	vec2 uv = SCREEN_UV;

	// Puts uv in world space
	uv = uv * 2.0 - 1.0;
	uv = (screen_to_world * vec4(uv,0,1)).xy;

	// Apply an offset of 20 units
	uv -= vec2(20., 20.);
	uv = spherize_uv(uv, pup_offset, 0.001, vec2(0.0));
	uv += vec2(20., 20.);
	//COLOR.rg = uv;

	// Puts uv back in screen space
	uv = (world_to_screen * vec4(uv,0,1)).xy;
	uv = uv * 0.5 + 0.5;
	COLOR = textureLod(screen_texture, uv, 0.0);

}