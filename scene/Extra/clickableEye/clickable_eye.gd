@tool
extends Node2D

var eye_manager:EyeManager

var game_pos

func init(eye_manager, game_pos):
	self.eye_manager = eye_manager
	self.game_pos = game_pos
	position = eye_manager.map_to_local(game_pos)

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
	await get_tree().create_timer(1.5).timeout
	clicking = false
	
	
