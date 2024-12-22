class_name Extra extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SoundManager.stop()
	%AnimationPlayer.play("button_in")
	#%AnimationPlayer.play_with_capture(
		#"button_in", 1.0, 1.0, 1.0, false, Tween.TRANS_ELASTIC, Tween.EASE_OUT
	#)
	#for i in range(60):
		#var node := preload("res://Map/Eye/EyeAnim.tscn").instantiate()
		#node.trackMode  = true
		#node.position = \
			#Vector2(randi_range(0, get_window().size.x), randi_range(0, get_window().size.y))
		#%Control.add_child(node)





func _process(delta: float) -> void:
	pass


func _on_ed_button_button_down() -> void:
	GameManager.start_goto_end()


func _on_bgm_ingame_button_button_down() -> void:
	SoundManager.play_BGM(SoundManager.BGM.IN_GAME)


func _on_bgm_game_menu_button_button_down() -> void:
	SoundManager.play_BGM(SoundManager.BGM.GMAE_MENU)


func _on_song_button_button_down() -> void:
	SoundManager.play_BGM(SoundManager.BGM.ED)


func _on_button_button_down() -> void:
	GameManager.goto_scene("title")
