extends Story
class_name Start

func story():
	var result = await super.story()
	if not result:
		start_eye()
	return result
		
func start_eye():
	var node := preload("res://Map/Eye/EyeAnim.tscn").instantiate()
	node.position = Vector2(size) / 2
	add_child(node)
	node._enter_anime(0.5)
	await get_tree().create_timer(1.5).timeout
	node._exit_anime(0.5)
	await get_tree().create_timer(0.5).timeout
	node.queue_free()
	end()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	super._on_anim_animation_finished(anim_name)
	if anim_name == "enter":
		start_story()
	if anim_name == "fade to select":
		finish()

func end():
	super.end()
	anim.play("fade to select")

func finish():
	GameManager.finish_anim("start")
	GameManager.goto_scene("select")
