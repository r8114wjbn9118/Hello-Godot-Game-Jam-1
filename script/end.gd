extends Control

@onready var img = %img

var state = "wait"
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
		$anim.play("fadein")
		


func start_show():
	state = "show"
	%text.text = tr("end_1")
	$anim.play("story01")
	$anim.animation_finished.connect(End)



func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "anim":
		start_shock()
	if anim_name == "fadein":
		start_show()

func End(anim_name: StringName):
	GameManager.goto_scene("credit")
