extends CharacterBody2D
#class_name Worm

@export var move_speed:int = 72

@onready var point_manager = %Point

enum ACTION {
	WAIT_INPUT,
	MOVE,
	START,
	END,
}

var can_control:bool = false
var state:int = ACTION.START
var game_pos:Vector2i = Vector2i.ONE
var target_pos = null

var map_size:Vector2i
var sub_worm:Node2D

var route:Array = []
var _undo_redo = UndoRedo.new() # 命令模式

func Do( vec:Vector2i ):
	pass
func Reset():
	pass
func Undo():
	pass
func Redo():
	pass
	
func _ready() -> void:
	
	pass
	
func initialize(map_size, sub_worm):
	can_control = true
	self.map_size = map_size
	self.sub_worm = sub_worm
	self.sub_worm.map_size = map_size
	state = ACTION.WAIT_INPUT
	self.sub_worm.state = state



func _unhandled_input(event: InputEvent) -> void:
	if not can_control:
		return
	if state == ACTION.WAIT_INPUT:
		if Input.is_action_just_pressed("ui_up"):
			check_move(Vector2i.UP)
		elif Input.is_action_just_pressed("ui_left"):
			check_move(Vector2i.LEFT)
		elif Input.is_action_just_pressed("ui_right"):
			check_move(Vector2i.RIGHT)
		elif Input.is_action_just_pressed("ui_down"):
			check_move(Vector2i.DOWN)

func check_move(direction):
	var target_game_pos = can_move(direction)
	var sub_target_game_pos = sub_worm.can_move(direction * -1)
	printt(game_pos, direction, target_game_pos, sub_target_game_pos)
	
	if target_game_pos == null or sub_target_game_pos == null:
		return false
		
	start_move(target_game_pos)
	sub_worm.start_move(sub_target_game_pos)

	return true
	
func can_move(direction):
	var target_game_pos = game_pos + direction
	if target_game_pos.x < 0 or target_game_pos.x >= map_size.x:
		return null
	if target_game_pos.y < 0 or target_game_pos.y >= map_size.y:
		return null
	return target_game_pos
	pass

func start_move(target_game_pos):
	state = ACTION.MOVE
	game_pos = target_game_pos
	var target_point:Node2D = point_manager.get_pos_node(target_game_pos)
	target_pos = target_point.position
	pass



func _physics_process(delta: float):
	if state == ACTION.MOVE:
		move(delta)

func move(delta):
	position += position.direction_to(target_pos) * move_speed / 100
	
	if reach_destination(position, target_pos):
		state = ACTION.WAIT_INPUT
		return false
	return true

# 
func reach_destination(a, b):
	if a.distance_squared_to(b) < 1:
		position = b
		velocity = Vector2.ZERO
		return true
	return false
