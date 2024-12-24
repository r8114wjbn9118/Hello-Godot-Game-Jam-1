extends Node2D

func _process(delta: float) -> void:
	set_mount(GameManager.get_move_progress())
func set_mount(value:float):
	(%ColorRect.material as ShaderMaterial).set_shader_parameter("mount", value)



#
