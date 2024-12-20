@tool
class_name Worm extends Node2D

signal change_state(target, old_state, new_state)
signal move_finish_signal()

@export var move_speed:float = 200

@onready var point_manager = %Point

var state:GameManager.ACTION :
	set(value):
		change_state.emit(self, state, value)
		state = value

var game_pos:Vector2i
var target_game_pos
var target_pos

#var action_distance:int = 1 # 行動距離



func _physics_process(delta: float):
	if state == GameManager.ACTION.MOVE:
		if not move(delta):
			move_finish()


#region by DF
@onready var _pathLine := %Path
@onready var _bodyLine := %Body
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pathLine.init(self, point_manager)
	_bodyLine.init(self, point_manager)
	_pathLine.move(position)
	_bodyLine.move(position)

func set_pos(game_pos): # NOTE 由UNDO調用
	rotation = Vector2(self.game_pos - game_pos).angle() - PI / 2
	self.game_pos = game_pos
	position = point_manager.get_point_position(game_pos)

func move(delta):
	var distance = move_speed * delta

	position += position.direction_to(target_pos) * distance
	_pathLine.move(position)
	_bodyLine.move(position)
	
	return not reach_destination(position, target_pos, distance)

func _move(): # NOTE move  (不應該被直接調用)
	pass
func _unmove(PathPoints, BodyPoints): # NOTE move 的反向操作 (不應該被直接調用)
	_pathLine.setPoints(PathPoints)
	_bodyLine.setPoints(BodyPoints)
	_pathLine.move(position)
	_bodyLine.move(position)


@onready var _undoRedo:UndoRedo = UndoRedo.new()
func Do(): # NOTE 由WormManager調用
	_undoRedo.create_action("nothing")
	_undoRedo.add_undo_method(_move)
	#print_tree_pretty()
	_undoRedo.add_undo_method(_unmove.bind(_pathLine.getPoints(), _bodyLine.getPoints()))
	_undoRedo.commit_action()
func Undo():
	if _undoRedo.has_undo():
		_undoRedo.undo()
#endregion

func reach_destination(a, b, distance):
	if a.distance_squared_to(b) < distance:
		position = b
		return true
	return false



func start_move(target_game_pos):
	printt(name + " Start Move", target_game_pos)
	self.target_game_pos = target_game_pos
	self.target_pos = point_manager.get_point_position(target_game_pos)
	rotation = Vector2(game_pos - target_game_pos).angle() + PI / 2
	state = GameManager.ACTION.MOVE

func move_finish():
	game_pos = target_game_pos
	target_game_pos = null
	state = GameManager.ACTION.WAIT
	move_finish_signal.emit()
