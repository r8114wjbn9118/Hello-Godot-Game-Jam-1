shader_type canvas_item;


uniform vec4 c:source_color;
void fragment() {
	if (length(UV-vec2(0.5, 2.0))>1.8 ){
		discard;
	}else{
		COLOR =c;
	}
}