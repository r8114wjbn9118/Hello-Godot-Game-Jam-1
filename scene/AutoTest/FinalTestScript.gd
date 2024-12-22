extends Node

func _ready() -> void:
	var tween := get_tree().create_tween()
	tween.tween_interval(1.0)
	for key in GameManager.SCENE.keys():
		tween.tween_callback(GameManager.goto_scene.bind(key))
		tween.tween_interval(1.0)
	for key in range(1, GameManager.get_available_level()):
		tween.tween_callback(GameManager.goto_level.bind(key))
		tween.tween_interval(1.0)
	GameManager.reset_save_data()
	
