extends Node2D


func get_eye():
	return $EyeAnim

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		if !clicking:
			clicking = true
			_on_click()
var clicking:bool = false
func _on_click():
	var node = $EyeAnim
	node._exit_anime(1.5)
	await get_tree().create_timer(3.0).timeout
	node._enter_anime(1.5)
	await  get_tree().create_timer(1.5).timeout
	clicking = false
	
	
