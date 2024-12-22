extends Control

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	GameManager.goto_scene("title")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("credit")

func _on_title_button_button_down() -> void:
	GameManager.goto_scene("title")

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
