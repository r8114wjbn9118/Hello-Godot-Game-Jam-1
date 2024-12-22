shader_type canvas_item;
uniform float min_len:hint_range(0.5, 0.5) = 0.5;
uniform float max_len:hint_range(0.5, 0.5) = 0.6;

void fragment() {
	if (!(length(UV-vec2(0.5, 0.5)) > min_len && length(UV-vec2(0.5, 0.5)) < max_len)){
		discard;
	}
}
