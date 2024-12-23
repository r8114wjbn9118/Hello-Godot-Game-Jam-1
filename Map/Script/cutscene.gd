extends CanvasLayer

@onready var screen = $ColorRect

#region 通用開始/結束方式

func start(method):
	screen.color = Color("black")
	visible = true

	var tween = get_tree().create_tween()
	tween.tween_method(method, 0.0, 2.0, 1)
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(end)
	return tween

func end():
	visible = false

#endregion

#region level

var old_map
var new_map

func start_change_level():
	start(change_level)

func change_level(t):
	var min_len = max(0, t - 0.7)
	var max_len = t
	
	screen.material.set_shader_parameter("min_len", min_len)
	screen.material.set_shader_parameter("max_len", max_len)

	if t >= 0.5:
		if is_instance_valid(old_map):
			old_map.queue_free()
			old_map = null
		if new_map:
			get_tree().root.add_child(new_map)
			get_tree().current_scene = new_map
			new_map = null

#endregion

#region select

func start_goto_select():
	screen.material.set_shader_parameter("min_len", 0)
	screen.material.set_shader_parameter("max_len", 1)
	start(goto_select)

func goto_select(t):
	screen.color = lerp(
		Color("00000000"), # 透明黑
		Color("2d2d2d"), # 選關顏色
		t / 2
	)
	
	if t >= 1.8:
		GameManager.goto_scene("select")

#endregion

#region end

func start_goto_end():
	start(goto_end)
			
func goto_end(t):
	screen.material.set_shader_parameter("min_len", 0)
	screen.material.set_shader_parameter("max_len", t)
	
	if t >= 1.8:
		if not get_tree().current_scene is End:
			GameManager.goto_scene("end")
			
#endregion
