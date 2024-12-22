extends CanvasLayer

@onready var screen = $ColorRect

var old_map
var new_map

func start() -> void:
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_method(move, 0.0, 1.7, 1)
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(end)
	
func end():
	visible = false

func move(t):
	var min = max(0, t - 0.7)
	var max = t
	
	screen.material.set_shader_parameter("min_len", min)
	screen.material.set_shader_parameter("max_len", max)

	if t >= 0.5:
		if is_instance_valid(old_map):
			old_map.queue_free()
			old_map = null
		if new_map:
			get_tree().root.add_child(new_map)
			get_tree().current_scene = new_map
			new_map = null
