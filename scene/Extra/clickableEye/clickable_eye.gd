extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	
	
