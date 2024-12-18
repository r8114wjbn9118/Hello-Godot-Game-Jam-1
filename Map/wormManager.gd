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



func _ready() -> void:
	main_worm.move_finish_signal.connect(_on_worm_move_finish)
	sub_worm.move_finish_signal.connect(_on_worm_move_finish)
	pass

func initialize(max_move_distance):
	self.max_move_distance = max_move_distance
	state = ACTION.WAIT

	main_worm.rotation_degrees = 180
	
func init_pos():
	main_worm.game_pos = point_manager.get_point_game_pos(main_worm.position)
	main_worm.position = point_manager.get_point_position(main_worm.game_pos)

	sub_worm.game_pos = point_manager.get_point_game_pos(sub_worm.position)
	sub_worm.position = point_manager.get_point_position(sub_worm.game_pos)

func _physics_process(delta: float) -> void:
	if state == ACTION.MOVE:
		if main_worm.state == ACTION.WAIT \
		and sub_worm.state == ACTION.WAIT:
			state = ACTION.WAIT




# NOTE 流程: _unhandled_input -> check -> Do -> move

func _unhandled_input(event: InputEvent) -> void:
	if state == ACTION.WAIT:
		if Input.is_action_pressed("ui_up") and check(Vector2i.UP):
			Do(Vector2i.UP)
		elif Input.is_action_pressed("ui_left") and check(Vector2i.LEFT):
			Do(Vector2i.LEFT)
		elif Input.is_action_pressed("ui_right") and check(Vector2i.RIGHT):
			Do(Vector2i.RIGHT)
		elif Input.is_action_pressed("ui_down") and check(Vector2i.DOWN):
			Do(Vector2i.DOWN)
		elif Input.is_action_pressed("z"):
			Undo()

func check(direction): 
	var map_point_list = point_manager.get_used_cells()

	var target_map_pos = main_worm.game_pos + direction # 設定目標點
	if not target_map_pos in map_point_list:
		return false

	var sub_target_map_pos = sub_worm.game_pos + direction * -1
	if not sub_target_map_pos in map_point_list:
		return false
	# NOTE 之後移動至Move
	#if move_path.size() == max_move_distance: 
		#if target_map_pos == move_path[-1]: # NOTE 意義不明?
			#move_path.pop_back()
		#else:
			#return false
	#else:
		#move_path.append(target_map_pos)
	return true




func move( target_map_pos, sub_target_map_pos ): # NOTE 包含path 及 worm操作 (不應該被直接調用)
	move_path.append(target_map_pos) # NOTE 紀錄路徑
	main_worm.start_move(
		target_map_pos,
		point_manager.get_point_position(target_map_pos)
	)
	sub_worm.start_move(
		sub_target_map_pos,
		point_manager.get_point_position(sub_target_map_pos)
	)
	state = ACTION.MOVE

func unmove(target_map_pos, sub_target_map_pos): # NOTE move 的反向操作 (不應該被直接調用)
	move_path.pop_back() # NOTE 紀錄路徑
	main_worm.start_move(
		target_map_pos,
		point_manager.get_point_position(target_map_pos)
	)
	sub_worm.start_move(
		sub_target_map_pos,
		point_manager.get_point_position(sub_target_map_pos)
	)
	state = ACTION.MOVE

var _undo_redo = UndoRedo.new() # 命令模式

func Do( direction:Vector2i ):
	var target = main_worm.game_pos + direction # 設定目標點
	var target_sub = sub_worm.game_pos + direction * -1
	var unmove_target = main_worm.game_pos # 設定回復點
	var unmove_target_sub = sub_worm.game_pos 
	
	_undo_redo.create_action("Move")
	_undo_redo.add_do_method(move.bind(target, target_sub))
	_undo_redo.add_undo_method(unmove.bind(unmove_target, unmove_target_sub))
	_undo_redo.add_undo_property(main_worm.body, "points", main_worm.body.points)
	_undo_redo.add_undo_property(sub_worm.body, "points", sub_worm.body.points)
	_undo_redo.commit_action()

func Reset(): # TODO
	pass
func Undo(): 
	if _undo_redo.has_undo():
		_undo_redo.undo()
func Redo(): # TODO
	if _undo_redo.has_redo():
		_undo_redo.redo()











func get_move_path():
	var list:Array[Vector2i] = []
	pass
	return list
func get_move_path_h():
	var list:Array[Vector2i] = []
	pass
	return list
func get_move_path_v():
	var list:Array[Vector2i] = []
	pass
	return list




func _on_worm_move_finish():
	if state == ACTION.MOVE:
		if main_worm.state == ACTION.WAIT \
		and sub_worm.state == ACTION.WAIT:
			state = ACTION.WAIT
			move_finish_signal.emit()
			return true
	return false
