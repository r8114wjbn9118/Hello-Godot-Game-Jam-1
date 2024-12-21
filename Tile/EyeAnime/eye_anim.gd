@tool
class_name DragonEye extends Node2D

static func new_instance()-> DragonEye:
	return preload("res://Tile/EyeAnime/EyeAnim.tscn").instantiate()

@onready var _white_eye_ball = $"CanvasGroup/眼白"
@onready var _pupil = $"CanvasGroup/圓瞳孔"
@onready var _spupil = $"CanvasGroup/直瞳孔"
@onready var _shade = $"CanvasGroup/反光"
@onready var _target = $Target

@export var blink_curve:Curve

const RANDOM_R = 15.0

var eye_manager:EyeManager

var game_pos

var _rand_target:Vector2 = Vector2.ONE
func _set_rand_target():
	var r = randf_range(0.0, RANDOM_R)
	var angle = randf_range(0, 2*PI)
	_rand_target = Vector2(cos(angle), sin(angle)) * r
	
func init(eye_manager, game_pos):
	self.eye_manager = eye_manager
	self.game_pos = game_pos
	position = eye_manager.map_to_local(game_pos)

func _ready() -> void:
	if !Engine.is_editor_hint():
		$Camera2D.queue_free()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		_target.global_position = get_global_mouse_position()
	else:
		_target.position = lerp(_target.position, _rand_target, 8.0* delta)
	
	var time := fmod(Time.get_unix_time_from_system()/2.0, 1.0)
	$"CanvasGroup/直瞳孔".scale.y = blink_curve.sample_baked(time)
	
	
	const MAX_LEN = 3.0
	_shade.position = (_target.position / 14.0).limit_length(MAX_LEN/2.0)
	_pupil.position = (_target.position / 7.0).limit_length(MAX_LEN)
	_spupil.position = (_target.position / 4.0).limit_length(MAX_LEN*1.2)
	
	var offset = _spupil.position / MAX_LEN
	($CanvasGroup.material as ShaderMaterial).\
		set_shader_parameter("pup_offset", (offset/2.0 * -1.0) + Vector2(0.5, 0.5))
	($CanvasGroup.material as ShaderMaterial).\
		set_shader_parameter("world_position", global_position)












#
