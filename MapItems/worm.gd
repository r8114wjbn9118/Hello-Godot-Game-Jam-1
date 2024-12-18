@tool
extends Node2D

signal change_state(target, old_state, new_state)
signal move_finish_signal()

@export var move_speed:float = 200

enum ACTION {
	WAIT,
	MOVE,
}

var state:ACTION :
	set(value):
		change_state.emit(self, state, value)
		state = value

var game_pos:Vector2i
var target_game_pos
var target_pos

var move_path = []

func _physics_process(delta: float):
	if state == ACTION.MOVE:
		move(delta)
		
func move(delta):
	position += position.direction_to(target_pos) * move_speed * delta
	
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
