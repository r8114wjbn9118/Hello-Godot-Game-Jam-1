@tool
extends Node2D
class_name WormManager

signal move_finish_signal()

@export var move_speed:float = 1

@onready var point_manager = %Point
@onready var main_worm = %MainWorm
@onready var sub_worm = %SubWorm

enum ACTION {
	WAIT,
	MOVE,
	START,
	END,
}

var state:int = ACTION.START
var move_path = []
var max_move_distance:int

var body = []

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
	main_worm.move_finish_signal.connect(_on_worm_move_finish)
	sub_worm.move_finish_signal.connect(_on_worm_move_finish)
	pass

func initialize(max_move_distance):
	self.max_move_distance = max_move_distance
	state = ACTION.WAIT

	main_worm.rotation_degrees = 180
	
func init_pos():
	print("Init Pos")
	main_worm.game_pos = point_manager.get_point_game_pos(main_worm.position)
	main_worm.position = point_manager.get_point_position(main_worm.game_pos)

	sub_worm.game_pos = point_manager.get_point_game_pos(sub_worm.position)
	sub_worm.position = point_manager.get_point_position(sub_worm.game_pos)

func _physics_process(delta: float) -> void:
	if state == ACTION.MOVE:
		if main_worm.state == ACTION.WAIT \
		and sub_worm.state == ACTION.WAIT:
			state = ACTION.WAIT

func _unhandled_input(event: InputEvent) -> void:
	if state == ACTION.WAIT:
		if Input.is_action_pressed("ui_up"):
			check_move(Vector2i.UP)
		elif Input.is_action_pressed("ui_left"):
			check_move(Vector2i.LEFT)
		elif Input.is_action_pressed("ui_right"):
			check_move(Vector2i.RIGHT)
		elif Input.is_action_pressed("ui_down"):
			check_move(Vector2i.DOWN)

func check_move(direction):
	var point_list = point_manager.get_used_cells()

	var main_target_game_pos = main_worm.game_pos + direction
	if not main_target_game_pos in point_list:
		return false

	var sub_target_game_pos = sub_worm.game_pos + direction * -1
	if not sub_target_game_pos in point_list:
		return false

	if move_path.size() == max_move_distance:
		if main_target_game_pos == move_path[-1]:
			move_path.pop_back()
		else:
			return false
	else:
		move_path.append(main_target_game_pos)

	main_worm.start_move(
		main_target_game_pos,
		point_manager.get_point_position(main_target_game_pos)
	)
	sub_worm.start_move(
		sub_target_game_pos,
		point_manager.get_point_position(sub_target_game_pos)
	)
	state = ACTION.MOVE

	return true



func get_move_path():
	pass
func get_move_path_h():
	pass
func get_move_path_v():
	pass




func _on_worm_move_finish():
	if state == ACTION.MOVE:
		if main_worm.state == ACTION.WAIT \
		and sub_worm.state == ACTION.WAIT:
			state = ACTION.WAIT
			move_finish_signal.emit()
			return true
	return false
