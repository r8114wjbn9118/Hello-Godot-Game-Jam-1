@tool
extends Node2D
class_name WormManager

signal move_finish_signal()

@onready var point_manager = %Point
@onready var h_edge_manager = %HEdge
@onready var v_edge_manager = %VEdge
@export var main_worm:Worm
@export var sub_worm:Worm

#var move_path = []

var move_distance:int = 0
var max_move_distance:int = 8:
	set(value):
		main_worm.max_move_distance = value
		sub_worm.max_move_distance = value
		max_move_distance = value
		



func _ready() -> void:
	main_worm.move_finish_signal.connect(_on_worm_move_finish)
	sub_worm.move_finish_signal.connect(_on_worm_move_finish)
	%GameUI.move_input.connect(_on_ui_move_input)

func initialize(max_move_distance):
	self.max_move_distance = max_move_distance
	main_worm.init()
	sub_worm.init()
	
	#move_path = [main_worm.game_pos]
	move_distance = 0
	
	#create_body() # NOTE 已放進Worm
	#PathLine.max_distance = max_move_distance
	
	GameManager.prohibit_action(false)
	
func init_pos():
	main_worm.init_pos()
	sub_worm.init_pos()

#func create_body():
	#var main_worm_body = main_worm.create_body(max_move_distance)
	#add_child(main_worm_body)
	#
	#var sub_worm_body = sub_worm.create_body(max_move_distance)
	#add_child(sub_worm_body)
	



# NOTE 流程: _unhandled_input -> check -> Do -> move

func _unhandled_input(event: InputEvent) -> void:
	if GameManager.is_waiting():
		if Input.is_action_pressed("ui_up"):
			move_input(Vector2i.UP)
		elif Input.is_action_pressed("ui_left"):
			move_input(Vector2i.LEFT)
		elif Input.is_action_pressed("ui_right"):
			move_input(Vector2i.RIGHT)
		elif Input.is_action_pressed("ui_down"):
			move_input(Vector2i.DOWN)
		elif Input.is_action_pressed("ui_accept"):
			Undo()
			
func move_input(direction:Vector2i):
	#var action = check(direction)
	## 癈棄
	#if action < 0: # 返回
		#Undo()
		#return true
	if check(direction): # 正常移動
		Do(direction)
		return true
	#if action == 0: # 無法移動
	SoundManager.play_effect(SoundManager.EFFECT.BLOCK)
	return false

func check(direction):
	# 最大距離限制
	print(move_distance, "/", max_move_distance)
	if move_distance >= max_move_distance:
		SoundManager.play_ohno()
		return false

	# 設定目標點
	var target_map_pos = main_worm.game_pos + direction #* main_worm.action_distance
	var sub_target_map_pos = sub_worm.game_pos + direction * -1 #* sub_worm.action_distance

	## 癈棄
	## 目標位置與最後行動的位置相同, 輸出-1以執行undo
	## 如果有傳送效果可能需要再改?
	## 因為往下有路徑檢測, 所以需要先運行
	#if move_path.size() > 1 and target_map_pos == move_path[-2]:
		#return -1

	# 相撞
	if target_map_pos == sub_target_map_pos \
	or target_map_pos == sub_worm.game_pos \
	and sub_target_map_pos == main_worm.game_pos:
		return false
	
#region Test
	var map_point_list = point_manager.get_used_cells()
	
	# TEST 其中一隻蠑螈能走 就能走
	var main_can_move = target_map_pos in map_point_list and \
		check_edge_is_passable(main_worm.game_pos, target_map_pos)
	
	var sub_can_move = sub_target_map_pos in map_point_list and \
		check_edge_is_passable(sub_worm.game_pos, sub_target_map_pos)
		
	return main_can_move or sub_can_move
#endregion

	
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
	#move_path.append(target_map_pos) # NOTE 紀錄路徑
	move_distance += 1
	
#region Test
	var _have_point = target_map_pos in point_manager.get_used_cells()
	var _have_edge = check_edge_is_passable(main_worm.game_pos, target_map_pos)
	var _s_have_point = sub_target_map_pos in point_manager.get_used_cells()
	var _s_have_edge = check_edge_is_passable(sub_worm.game_pos, sub_target_map_pos)

	if (_have_point and _have_edge):
		change_edge_available_count(main_worm.game_pos, target_map_pos, 1)
		main_worm.start_move(target_map_pos)
	
	if (_s_have_point and _s_have_edge):
		change_edge_available_count(sub_worm.game_pos, sub_target_map_pos, 1)
		sub_worm.start_move(sub_target_map_pos)
#endregion
	GameManager.start_move()

func unmove(target_map_pos, sub_target_map_pos): # NOTE move 的反向操作 (不應該被直接調用)
	#move_path.pop_back() # NOTE 紀錄路徑
	move_distance -= 1
	
	change_edge_available_count(main_worm.game_pos, target_map_pos, -1)
	main_worm.set_pos(target_map_pos)
	
	change_edge_available_count(sub_worm.game_pos, sub_target_map_pos, -1)
	sub_worm.set_pos(sub_target_map_pos)
	#state = ACTION.MOVE

var _undo_redo = UndoRedo.new() # 命令模式

func Do( direction:Vector2i ):
	var target = main_worm.game_pos + direction # 設定目標點
	var target_sub = sub_worm.game_pos + direction * -1
	var unmove_target = main_worm.game_pos # 設定回復點
	var unmove_target_sub = sub_worm.game_pos
	
	_undo_redo.create_action("Move")
	_undo_redo.add_do_method(move.bind(target, target_sub))
	_undo_redo.add_do_method(%MainWorm.Do)
	_undo_redo.add_do_method(%SubWorm.Do)
	_undo_redo.add_do_method(GameManager.set_move_progress.bind(move_distance / float(max_move_distance)))
	_undo_redo.add_undo_method(GameManager.set_move_progress.bind(GameManager.get_move_progress()))
	_undo_redo.add_undo_method(unmove.bind(unmove_target, unmove_target_sub))
	_undo_redo.add_undo_method(%MainWorm.Undo)
	_undo_redo.add_undo_method(%SubWorm.Undo)
	#_undo_redo.add_undo_property(main_worm.body, "points", main_worm.body.points) # 廢棄
	#_undo_redo.add_undo_property(sub_worm.body, "points", sub_worm.body.points)
	_undo_redo.commit_action()


func Undo(): 
	if _undo_redo.has_undo():
		_undo_redo.undo()
		SoundManager.play_effect(SoundManager.EFFECT.ROAR)
	else:
		SoundManager.play_effect(SoundManager.EFFECT.BLOCK)



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
	if GameManager.is_moving():
		GameManager.move_finish()
		move_finish_signal.emit()
		return true
	return false

func _on_ui_move_input(action:String):
	if GameManager.is_waiting():
		if action == "up":
			move_input(Vector2i.UP)
		elif action == "left":
			move_input(Vector2i.LEFT)
		elif action == "right":
			move_input(Vector2i.RIGHT)
		elif action == "down":
			move_input(Vector2i.DOWN)
		elif action == "undo":
			Undo()
