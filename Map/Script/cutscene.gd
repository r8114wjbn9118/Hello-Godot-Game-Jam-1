extends CanvasLayer

@onready var screen = $ColorRect

var old_map
var new_map

func init(old, new) -> void:
	printt(old, new)
	old_map = old
	new_map = new

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_method(move, 0.0, 1.7, 1)
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(queue_free)

func move(t):
	var min = max(0, t - 0.7)
	var max = t
	
	screen.material.set_shader_parameter("min_len", min)
	screen.material.set_shader_parameter("max_len", max)

	if t >= 0.5:
		if old_map:
			printt(old_map)
			old_map.visible = false
			old_map.queue_free()
			old_map = null
		if new_map:
			print(new_map)
			new_map.visible = true
			new_map = null
