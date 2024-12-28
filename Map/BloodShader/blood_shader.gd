extends CanvasLayer

func _ready() -> void:
	set_mount(0)
	GameManager.change_move_progress.connect(_on_change_move_progress)
	
func set_mount(value:float):
	(%ColorRect.material as ShaderMaterial).set_shader_parameter("mount", value)



func _on_change_move_progress():
	set_mount(GameManager.get_move_progress())

#
