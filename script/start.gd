extends Control
class_name Start

@export var story_img:Array[Texture2D]
@export var story_count:int = 3
var story_index = 0

@onready var img = %img
@onready var text = %text
@onready var anim = %anim

var state = "wait" :
	set(value):
		state = value
		printt("Start", state)

func start_story():
	state = "story"
	story_index = 2
	img.position = Vector2.ZERO
	await get_tree().create_timer(1).timeout
	story()

func story():
	if story_index < story_count:
		text.text = tr("start_{0}".format([story_index + 1]))
		img.texture = story_img[story_index]
		await get_tree().create_timer(1).timeout
		anim.play("story")
	else:
		start_eye()
		
func start_eye():
	var node := preload("res://Map/Eye/EyeAnim.tscn").instantiate()
	node.position = Vector2(size) / 2
	add_child(node)
	node._enter_anime(0.5)
	await get_tree().create_timer(1.5).timeout
	node._exit_anime(0.5)
	await get_tree().create_timer(0.5).timeout
	node.queue_free()
	End()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "start":
		start_story()
	if anim_name == "story":
		story_index += 1
		story()
	if anim_name == "fade to select":
		finish()

func End():
	anim.play("fade to select")

func finish():
	GameManager.finish_anim("start")
	GameManager.goto_scene("select")
