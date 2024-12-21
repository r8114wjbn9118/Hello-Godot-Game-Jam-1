shader_type canvas_item;
uniform float len:hint_range(0.0, 0.5) = 0.5;

void fragment() {
	if (length(UV-vec2(0.5, 0.5)) > len){
		discard;
	}
}
