extends Control
class_name Start

#@onready var anim_tree = $AnimationTree
#@onready var BGM

func finish():
	GameManager.finish_anim("start")
	GameManager.goto_scene("select")
	
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	finish()
	


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		finish()
	pass # Replace with function body.
