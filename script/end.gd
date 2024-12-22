extends Control

@export var story_img:Array[Texture2D]
@export var story_count:int = 5
var story_index = 0

@onready var img = %img
@onready var text = %text
@onready var anim = %anim

var state = "wait" :
	set(value):
		state = value
		printt("Start", state)
var original_img_pos
var shock_offset
var timer

var window_size
var max_x

func _ready() -> void:
	SoundManager.play_BGM(SoundManager.BGM.ED)

func _process(delta: float) -> void:
	if state == "shock":
		shock(delta)

func start_shock():
	original_img_pos = img.position
	shock_offset = Vector2.ONE
	timer = 0
	window_size = get_tree().root.size
	max_x = window_size.x / 10
	state = "shock"
	
func shock(delta):
	timer += delta
	const frequency = PI * 10
	var offset_x = clamp(sin(timer * frequency) * 10 * min(timer, 3) ** 2, -max_x, max_x)
	var offset_y = window_size.y * (3 - sqrt(9 - (timer - 3) ** 2)) if timer >= 3 else 0
	img.position = original_img_pos + Vector2(offset_x, offset_y)
	if timer >= 3:
		anim.play("fadein")
		


func start_story():
	print(OS.get_locale())
	state = "story"
	story_index = 0
	img.position = Vector2.ZERO
	await get_tree().create_timer(5).timeout
	story()

func story():
	if story_index < story_count:
		text.text = tr("end_{0}".format([story_index + 1]))
		img.texture = story_img[story_index]
		await get_tree().create_timer(1).timeout
		anim.play("story")
	else:
		await get_tree().create_timer(15).timeout
		End()



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "anim":
		start_shock()
	if anim_name == "fadein":
		start_story()
	if anim_name == "story":
		story_index += 1
		story()
	if anim_name == "fade to credit":
		GameManager.goto_scene("credit")
		

func End():
	anim.play("fade to credit")
