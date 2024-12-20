@tool
class_name Worm extends Node2D

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




func _physics_process(delta: float):
	if state == ACTION.MOVE:
		move(delta)


#region by DF
@onready var _pathLine := $Node/PathLine
@onready var _bodyLine := $Node/Body
# Called when the node enters the scene tree for the first time.
func _is_main(main:bool):
	pass

func _ready() -> void:
	_pathLine.init(self, %Point)
	_bodyLine.init(self, %Point)
	_pathLine.move(position)
	_bodyLine.move(position)

func set_pos(game_pos, target_pos): # NOTE 由UNDO調用
	self.game_pos = game_pos
	position = target_pos

func move(delta):
	position += position.direction_to(target_pos) * move_speed * delta
	_pathLine.move(position)
	_bodyLine.move(position)
	
	if reach_destination(position, target_pos):
		move_finish()
		return false
	return true

func _move(): # NOTE move  (不應該被直接調用)
	pass
func _unmove(PathPoints, BodyPoints): # NOTE move 的反向操作 (不應該被直接調用)
	_pathLine.points = PathPoints
	_bodyLine.setPoints(BodyPoints)
	_pathLine.move(position)
	_bodyLine.move(position)


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
