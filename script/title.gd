extends Control
class_name Title



@onready var anim_tree = $AnimationTree
#@onready var BGM = %BGM

func _ready() -> void:
	%background.texture = GameManager.get_title_background()
	anim_tree["parameters/conditions/start"] = false

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		anim_tree["parameters/conditions/start"] = true
		#BGM.stop()
	
func goto():
	var scene = "select"
	if not GameManager.is_finished_anim("start"):
		scene = "start"
		
	GameManager.goto_scene(scene)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeout":
		SoundManager.play_BGM(SoundManager.BGM.GMAE_MENU)
		#BGM.play()
	if anim_name == "fadein":
		goto()
	pass # Replace with function body.




func _on_button_button_down() -> void:
	anim_tree["parameters/conditions/start"] = true
	#BGM.stop()
