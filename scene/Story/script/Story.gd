extends Control
class_name Story

@export var story_name:String
@export var story_img:Array[Texture2D]
@export var story_count:int
@export var story_start_wait:int
@export var story_interval:int
@export var story_end_wait:int
var story_index = 0

@onready var img = %img
@onready var text = %text
@onready var skipBar = %skipBar
@onready var anim = %anim

var state = "wait":
	set(value):
		state = value
		printt("Start State", state)

func _ready() -> void:
	anim.animation_finished.connect(_on_anim_animation_finished)

func _process(delta: float) -> void:
	if state != "end":
		process_skip(delta)

var skip_timer:float = 0.0
var max_skip_time = 3
func process_skip(delta):
	var old = skip_timer
	if Input.is_anything_pressed():
		skip_timer += delta
		if skip_timer >= max_skip_time:
			end()
	else:
		if skip_timer > 0:
			skip_timer -= delta
			if skip_timer <= 0:
				skip_timer = 0.0
	if skip_timer != old:
		var value:float = skip_timer / max_skip_time
		skipBar.value = value * 100
		skipBar.modulate = lerp(
			Color("ffffff00"),
			Color("ffffffff"),
			value
		)

func start_story():
	state = "story"
	story_index = 0
	img.position = Vector2.ZERO
	if story_start_wait > 0:
		await get_tree().create_timer(story_start_wait).timeout
	story()

func story():
	if story_index < story_count:
		text.text = tr("{name}_{index}".format({"name":story_name, "index":story_index + 1}))
		img.texture = story_img[story_index]
		if story_interval > 0:
			await get_tree().create_timer(story_interval).timeout
		anim.play("story")
		return true
	
	if story_end_wait > 0:
		await get_tree().create_timer(story_end_wait).timeout
	return false

func end():
	state = "end"

func finish():
	pass



func _on_anim_animation_finished(anim_name: StringName) -> void:
	printt("aname", anim_name)
	if anim_name == "story":
		story_index += 1
		story()
