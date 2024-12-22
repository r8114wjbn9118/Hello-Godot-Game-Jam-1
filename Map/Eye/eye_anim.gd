@tool
class_name DragonEye extends Node2D

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


@export var s_scale:float = 8.0
func _ready() -> void:
	_enter_anime(2.5)
	($CanvasGroup.material as ShaderMaterial).\
		set_shader_parameter("s_scale", s_scale)
	
	
func _enter_anime(time:float):
	scale = Vector2.ZERO
	rotation = PI
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, time)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "rotation", 0.0, time)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)

func _exit_anime(time:float):
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, time)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "rotation", PI, time)\
		.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)



	
@export var trackMode:bool = false
var _time_offset = randf_range(0.0, 30.0)
func _process(delta: float) -> void:
	if Engine.is_editor_hint() or trackMode:
		_target.global_position = get_global_mouse_position()
	else:
		_target.position = lerp(_target.position, _rand_target, 8.0* delta)
	
	var time := fmod((Time.get_unix_time_from_system()+_time_offset)/2.0, 1.0)
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
