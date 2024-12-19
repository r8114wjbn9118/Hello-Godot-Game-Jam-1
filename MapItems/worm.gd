@tool
extends Node2D
class_name Worm

signal change_state(target, old_state, new_state)
signal move_finish_signal()

@export var move_speed:float = 200

enum ACTION {
	WAIT,
	MOVE,
	BACK,
}

var state:ACTION :
	set(value):
		change_state.emit(self, state, value)
		state = value

var game_pos:Vector2i
var target_game_pos
var target_pos

var action_distance:int = 1 # 行動距離
var move_path = [] # TODO

var body:WormTail


func _physics_process(delta: float):
	if state == ACTION.MOVE:
		move(delta)


func create_body(max_distance):
	body = WormTail.new(self, max_distance, %Point)
	return body
	
func set_pos(game_pos, target_pos): # NOTE 由UNDO調用
	self.game_pos = game_pos
	position = target_pos

func move(delta):
	position += position.direction_to(target_pos) * move_speed * delta
	body.move(position)
	
	if reach_destination(position, target_pos):
		move_finish()
		return false
	return true

func reach_destination(a, b):
	if a.distance_squared_to(b) < move_speed / 100:
		position = b
		return true
	return false


func can_move(direction, map_size):
	var target_game_pos = game_pos + direction
	if target_game_pos.x < 0 or target_game_pos.x >= map_size.x:
		return null
	if target_game_pos.y < 0 or target_game_pos.y >= map_size.y:
		return null
	return target_game_pos
	pass

func start_move(target_game_pos, target_pos):
	printt("Worm Start Move", target_game_pos, target_pos)
	state = ACTION.MOVE
	self.target_game_pos = target_game_pos
	self.target_pos = target_pos

func move_finish():
	game_pos = target_game_pos
	target_game_pos = null
	state = ACTION.WAIT
	move_finish_signal.emit()
