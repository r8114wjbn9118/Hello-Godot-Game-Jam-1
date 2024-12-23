extends Control
class_name Title



@onready var anim_tree = $AnimationTree
#@onready var BGM = %BGM

func _ready() -> void:
	%ExtraButton.visible = GameManager.is_finish_game()
	%background.texture = GameManager.get_title_background()
	%StartButton.grab_focus()
	anim_tree["parameters/conditions/start"] = false

func goto():
	var scene = "select"
	if not GameManager.is_finished_anim("start"):
		scene = "start"
	SoundManager.play_BGM(SoundManager.BGM.IN_GAME)
	GameManager.goto_scene(scene)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadeout":
		if SoundManager.current_BGM != SoundManager.BGM.ED:
			SoundManager.play_BGM(SoundManager.BGM.GMAE_MENU)
		#BGM.play()
	if anim_name == "fadein":
		goto()
	pass # Replace with function body.




func _on_button_button_down() -> void:
	anim_tree["parameters/conditions/start"] = true
	#BGM.stop()


func _on_extra_button_button_down() -> void:
	GameManager.goto_scene("extra")
