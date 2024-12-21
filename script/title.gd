extends Control
class_name Title

@onready var anim_tree = $AnimationTree
#@onready var BGM = %GameMenu

#var select_level_scene = preload("res://scene/selectLevel.tscn")
var select_level_scene = preload("res://Map/Map.tscn")

func _ready() -> void:
	anim_tree["parameters/conditions/start"] = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		anim_tree["parameters/conditions/start"] = true
		#BGM.stop()
	



func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "fadeout":
		SoundManager.play_BGM(SoundManager.BGM.GMAE_MENU)
		#BGM.play()
	if anim_name == "fadein":
		GameManager.goto_scene("select")
	pass # Replace with function body.




func _on_button_button_down() -> void:
	anim_tree["parameters/conditions/start"] = true
	#BGM.stop()
