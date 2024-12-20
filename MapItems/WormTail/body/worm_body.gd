@tool
class_name Worm extends Node2D

signal change_state(target, old_state, new_state)
signal move_finish_signal()

@export var move_speed:float = 200
@export var move_time:float = 0.5 # TEST 替代 move_speed

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




#func _physics_process(delta: float):
	#if state == ACTION.MOVE:
		#pass
		##move(delta)


#region by DF
@onready var _pathLine := $Node/PathLine
@onready var _bodyLine := $CanvasGroup/Node/Body
# Called when the node enters the scene tree for the first time.
func is_main(main:bool):
	if main:
		pass
	else:
		$"CanvasGroup/粉紅洞螈".visible = false
		$"CanvasGroup/藍藍洞螈".visible = true
		$CanvasGroup/Node/Body/BodyLine.texture = preload("res://MapItems/WormTail/body/身體(1).png")
		_bodyLine.setColor(Color("cfdeff"))

func _ready() -> void:
	_pathLine.init(self, %Point)
	_bodyLine.init(self, %Point)
	_pathLine.move(global_position)
	_bodyLine.move(global_position)

func set_pos(_game_pos, _target_pos): # NOTE 由父UNDO調用
	self.game_pos = _game_pos
	position = _target_pos

func _make_tween():
	var tween = get_tree().create_tween()
	tween.tween_method(_tween_move, position, target_pos, move_time)\
		.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_callback(move_finish)

func _tween_move(new_pos): # TEST 替代move
	position = new_pos
	_pathLine.move(global_position)
	_bodyLine.move(global_position)

#func move(delta):
	#position += position.direction_to(target_pos) * move_speed * delta
	#_pathLine.move(position)
	#_bodyLine.move(position)
	#
	#if reach_destination(position, target_pos):
		#move_finish()
		#return false
	#return true

func _move(): # NOTE move  (不應該被直接調用)
	pass
func _unmove(PathPoints, BodyPoints): # NOTE move 的反向操作 (不應該被直接調用)
	_pathLine.points = PathPoints
	_bodyLine.setPoints(BodyPoints)
	_pathLine.move(global_position)
	_bodyLine.move(global_position)


@onready var _undoRedo:UndoRedo = UndoRedo.new()
func Do(): # NOTE 由WormManager調用
	_undoRedo.create_action("nothing")
	_undoRedo.add_undo_method(_move)
	#print_tree_pretty()
	_undoRedo.add_undo_method(_unmove.bind(_pathLine.points, _bodyLine.getPoints()))
	_undoRedo.commit_action()
func Undo():
	if _undoRedo.has_undo():
		_undoRedo.undo()
#endregion

#func reach_destination(a, b):
	#if a.distance_squared_to(b) < move_speed / 100:
		#position = b
		#return true
	#return false


func can_move(direction, map_size):
	var _target_game_pos = game_pos + direction
	if _target_game_pos.x < 0 or _target_game_pos.x >= map_size.x:
		return null
	if _target_game_pos.y < 0 or _target_game_pos.y >= map_size.y:
		return null
	return _target_game_pos

func start_move(_target_game_pos, _target_pos):
	printt("Worm Start Move", _target_game_pos, _target_pos)
	
	#state = ACTION.MOVE # TEST
	self.target_game_pos = _target_game_pos
	self.target_pos = _target_pos
	_make_tween() # TEST

func move_finish():
	game_pos = target_game_pos
	target_game_pos = null
	state = ACTION.WAIT
	move_finish_signal.emit()
