@tool
extends Node2D
class_name WormManager

signal move_finish_signal()

@onready var point_manager = %Point
@onready var h_edge_manager = %HEdge
@onready var v_edge_manager = %VEdge
@onready var main_worm := %MainWorm
@onready var sub_worm := %SubWorm

enum ACTION {
	WAIT,
	MOVE,
	START,
	END,
}
var state:int = ACTION.START
var move_path = []

var move_speed:float = 200:
	set(value):
		main_worm.move_speed = value
		sub_worm.move_speed = value
		move_speed = value
var max_move_distance:int = 8

var body = []



func _ready() -> void:
	main_worm.move_finish_signal.connect(_on_worm_move_finish)
	sub_worm.move_finish_signal.connect(_on_worm_move_finish)

func initialize(move_speed, max_move_distance):
	self.move_speed = move_speed
	self.max_move_distance = max_move_distance
	
	init_pos()
	move_path = [main_worm.game_pos]
	
	create_body()
	
	state = ACTION.WAIT
	
func init_pos():
	main_worm.game_pos = point_manager.get_point_game_pos(main_worm.position)
	main_worm.position = point_manager.get_point_position(main_worm.game_pos)

	sub_worm.game_pos = point_manager.get_point_game_pos(sub_worm.position)
	sub_worm.position = point_manager.get_point_position(sub_worm.game_pos)

func create_body():
	var main_worm_body = main_worm.create_body(max_move_distance)
	add_child(main_worm_body)
	
	var sub_worm_body = sub_worm.create_body(max_move_distance)
	add_child(sub_worm_body)
	



# NOTE 流程: _unhandled_input -> check -> Do -> move

func _unhandled_input(event: InputEvent) -> void:
	if state == ACTION.WAIT:
		if Input.is_action_pressed("ui_up"):
			return move_input(Vector2i.UP)
		elif Input.is_action_pressed("ui_left"):
			return move_input(Vector2i.LEFT)
		elif Input.is_action_pressed("ui_right"):
			return move_input(Vector2i.RIGHT)
		elif Input.is_action_pressed("ui_down"):
			return move_input(Vector2i.DOWN)
		elif Input.is_action_pressed("z"):
			Undo()
			
func move_input(direction:Vector2i):
	var action = check(direction)
	if action < 0: # 返回
		Undo()
		return true
	if action > 0: # 正常移動
		Do(direction)
		return true
	#if action == 0: # 無法移動
	return false

func check(direction):
	var map_point_list = point_manager.get_used_cells()
	var target_edge_map_pos

	# 設定目標點
	var target_map_pos = main_worm.game_pos + direction #* main_worm.action_distance

	# 目標位置與最後行動的位置相同, 輸出-1以執行undo
	# 如果有傳送效果可能需要再改?
	# 因為往下有路徑檢測, 所以需要先運行
	if move_path.size() > 1 and target_map_pos == move_path[-2]:
		return -1
	
	# 最大距離限制
	print(move_path.size(), "/", max_move_distance)
	if move_path.size() > max_move_distance:
		return 0

	if not target_map_pos in map_point_list:
		return 0
	if not check_edge_is_passable(main_worm.game_pos, target_map_pos):
		return 0
		

	var sub_target_map_pos = sub_worm.game_pos + direction * -1 #* sub_worm.action_distance
	if not sub_target_map_pos in map_point_list:
		return 0
	if not check_edge_is_passable(sub_worm.game_pos, sub_target_map_pos):
		return 0
	
	# 相撞
	if target_map_pos == sub_target_map_pos \
	or target_map_pos == sub_worm.game_pos \
	and sub_target_map_pos == main_worm.game_pos:
		return 0
		

	return 1
	

	# NOTE 之後移動至Move
	
	#if target_map_pos == move_path[-1]: # undo
		#move_path.pop_back()
	#elif move_path.size() < max_move_distance: # do
		#move_path.append(target_map_pos)
	#else:
		#return false
	return true
	
func check_edge_is_passable(p1, p2):
	var edge_game_pos
	
	edge_game_pos = h_edge_manager.get_game_pos_from_two_point(p1, p2)
	if edge_game_pos != null:
		return h_edge_manager.is_passable(edge_game_pos)

	edge_game_pos = v_edge_manager.get_game_pos_from_two_point(p1, p2)
	if edge_game_pos != null:
		return v_edge_manager.is_passable(edge_game_pos)

	return false



func move( target_map_pos, sub_target_map_pos ): # NOTE 包含path 及 worm操作 (不應該被直接調用)
	var move_rotate = Vector2(main_worm.game_pos - target_map_pos).angle()
	move_path.append(target_map_pos) # NOTE 紀錄路徑
	
	change_edge_available_count(main_worm.game_pos, target_map_pos, -1)
	main_worm.rotation = move_rotate + PI / 2
	main_worm.start_move(
		target_map_pos,
		point_manager.get_point_position(target_map_pos)
	)
	
	change_edge_available_count(sub_worm.game_pos, sub_target_map_pos, -1)
	sub_worm.rotation = move_rotate - PI / 2
	sub_worm.start_move(
		sub_target_map_pos,
		point_manager.get_point_position(sub_target_map_pos)
	)
	state = ACTION.MOVE

func unmove(target_map_pos, sub_target_map_pos): # NOTE move 的反向操作 (不應該被直接調用)
	var move_rotate = Vector2(main_worm.game_pos - target_map_pos).angle()
	move_path.pop_back() # NOTE 紀錄路徑
	
	change_edge_available_count(main_worm.game_pos, target_map_pos, 1)
	main_worm.rotation = move_rotate - PI / 2
	main_worm.set_pos(target_map_pos, point_manager.get_point_position(target_map_pos))
	#main_worm.start_move(
		#target_map_pos,
		#point_manager.get_point_position(target_map_pos)
	#)
	
	change_edge_available_count(sub_worm.game_pos, sub_target_map_pos, 1)
	sub_worm.rotation = move_rotate + PI / 2
	sub_worm.set_pos(sub_target_map_pos, point_manager.get_point_position(sub_target_map_pos))
	#sub_worm.start_move(
		#sub_target_map_pos,
		#point_manager.get_point_position(sub_target_map_pos)
	#)
	#state = ACTION.MOVE

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




func change_edge_available_count(p1, p2, n):
	var edge_game_pos
	
	edge_game_pos = h_edge_manager.get_game_pos_from_two_point(p1, p2)
	if edge_game_pos != null:
		return h_edge_manager.change_available_count(edge_game_pos, n)

	edge_game_pos = v_edge_manager.get_game_pos_from_two_point(p1, p2)
	if edge_game_pos != null:
		return v_edge_manager.change_available_count(edge_game_pos, n)

	return false




func _on_worm_move_finish():
	if state == ACTION.MOVE:
		if main_worm.state == ACTION.WAIT \
		and sub_worm.state == ACTION.WAIT:
			state = ACTION.WAIT
			move_finish_signal.emit()
			return true
	return false
